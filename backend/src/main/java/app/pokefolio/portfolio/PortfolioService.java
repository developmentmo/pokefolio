package app.pokefolio.portfolio;

import app.pokefolio.common.Money;
import app.pokefolio.portfolio.HoldingDtos.HoldingDto;
import app.pokefolio.portfolio.PortfolioDtos.DashboardDto;
import app.pokefolio.portfolio.PortfolioDtos.HistoryPointDto;
import app.pokefolio.portfolio.PortfolioDtos.PortfolioHistoryDto;
import app.pokefolio.portfolio.PortfolioDtos.PortfolioSummaryDto;
import app.pokefolio.pricing.PriceObservation;
import app.pokefolio.pricing.PriceObservationRepository;
import app.pokefolio.pricing.PriceService;
import app.pokefolio.transaction.TransactionLine;
import app.pokefolio.transaction.TransactionLineRepository;
import app.pokefolio.transaction.TransactionService;
import java.math.BigDecimal;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.TreeSet;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class PortfolioService {

    static final String METHODOLOGY = "Each day counts the copies held at the end of that day (acquired on or "
            + "before the day, not disposed on or before it), valued at the latest market price observed on or "
            + "before that day. Copies without any known price are counted as unpriced and excluded from the value. "
            + "Sold, given away and traded copies stop counting on their disposal date; received trade cards start "
            + "counting on the trade date.";

    private final CardHoldingRepository holdings;
    private final PriceService prices;
    private final PriceObservationRepository observations;
    private final TransactionLineRepository lines;
    private final TransactionService transactions;
    private final HoldingService holdingService;
    private final Clock clock;

    public PortfolioService(CardHoldingRepository holdings, PriceService prices,
            PriceObservationRepository observations, TransactionLineRepository lines,
            TransactionService transactions, HoldingService holdingService, Clock clock) {
        this.holdings = holdings;
        this.prices = prices;
        this.observations = observations;
        this.lines = lines;
        this.transactions = transactions;
        this.holdingService = holdingService;
        this.clock = clock;
    }

    public PortfolioSummaryDto summary(UUID userId) {
        List<CardHolding> active = holdings.findAllByUserIdAndStatus(userId, HoldingStatus.ACTIVE);
        return summary(userId, active, prices.latest(active.stream().map(h -> h.getCard().getId()).distinct().toList()));
    }

    public DashboardDto dashboard(UUID userId) {
        List<CardHolding> active = holdings.findAllByUserIdAndStatus(userId, HoldingStatus.ACTIVE);
        Map<UUID, PriceObservation> latest =
                prices.latest(active.stream().map(h -> h.getCard().getId()).distinct().toList());
        List<HoldingDto> dtos = active.stream()
                .map(h -> holdingService.toDto(h, prices.toInfo(latest.get(h.getCard().getId()))))
                .toList();
        List<HoldingDto> recent = dtos.stream()
                .sorted(Comparator.comparing(HoldingDto::createdAt).reversed()).limit(5).toList();
        List<HoldingDto> valuable = dtos.stream().filter(d -> d.marketValue() != null)
                .sorted(Comparator.comparing(HoldingDto::marketValue).reversed()).limit(5).toList();
        return new DashboardDto(summary(userId, active, latest), recent, valuable,
                transactions.list(userId, null, null, null, 0, 5).getContent());
    }

    public PortfolioHistoryDto history(UUID userId, int days) {
        LocalDate to = LocalDate.now(clock);
        LocalDate from = to.minusDays(days - 1L);
        List<CardHolding> all = holdings.findAllByUserId(userId);
        List<ValuationCalculator.HoldingPeriod> periods = all.stream()
                .filter(h -> h.getDisposedOn() == null || !h.getDisposedOn().isBefore(from))
                .map(h -> new ValuationCalculator.HoldingPeriod(h.getCard().getId(), h.getAcquiredOn(),
                        h.getDisposedOn(), h.getPurchasePrice()))
                .toList();
        List<UUID> cardIds = periods.stream().map(ValuationCalculator.HoldingPeriod::cardId).distinct().toList();
        Map<UUID, List<ValuationCalculator.DatedPrice>> pricesByCard = new HashMap<>();
        boolean sample = false;
        if (!cardIds.isEmpty()) {
            Instant start = from.atStartOfDay().toInstant(ZoneOffset.UTC);
            Instant end = to.plusDays(1).atStartOfDay().toInstant(ZoneOffset.UTC);
            List<PriceObservation> obs = new ArrayList<>(
                    observations.findLatestBefore(cardIds, prices.currency(), start));
            obs.addAll(observations.findInRange(cardIds, prices.currency(), start, end));
            obs.sort(Comparator.comparing(PriceObservation::getObservedAt));
            for (PriceObservation o : obs) {
                sample |= o.isSampleData();
                pricesByCard.computeIfAbsent(o.getCardId(), k -> new ArrayList<>())
                        .add(new ValuationCalculator.DatedPrice(LocalDate.ofInstant(o.getObservedAt(), ZoneOffset.UTC),
                                o.getMarketPrice()));
            }
        }
        List<HistoryPointDto> points = ValuationCalculator.history(periods, pricesByCard, from, to).stream()
                .map(p -> new HistoryPointDto(p.date(), p.marketValue(), p.costBasis(), p.copies(),
                        p.unpricedCopies()))
                .toList();
        return new PortfolioHistoryDto(prices.currency(), sample, METHODOLOGY, points);
    }

    private PortfolioSummaryDto summary(UUID userId, List<CardHolding> active, Map<UUID, PriceObservation> latest) {
        List<ValuationCalculator.ValuedCopy> valued = new ArrayList<>();
        int stale = 0;
        boolean sample = false;
        Instant oldest = null;
        Instant newest = null;
        TreeSet<String> sources = new TreeSet<>();
        for (CardHolding h : active) {
            PriceObservation o = latest.get(h.getCard().getId());
            valued.add(new ValuationCalculator.ValuedCopy(h.getCard().getId(), h.getPurchasePrice(),
                    o == null ? null : o.getMarketPrice()));
            if (o != null) {
                sources.add(o.getSource());
                sample |= o.isSampleData();
                if (prices.toInfo(o).stale()) {
                    stale++;
                }
                oldest = oldest == null || o.getObservedAt().isBefore(oldest) ? o.getObservedAt() : oldest;
                newest = newest == null || o.getObservedAt().isAfter(newest) ? o.getObservedAt() : newest;
            }
        }
        ValuationCalculator.Totals totals = ValuationCalculator.totals(valued);

        BigDecimal realized = null;
        for (TransactionLine line : lines.findSaleLines(userId)) {
            BigDecimal cost = line.getHolding().getPurchasePrice();
            if (cost != null && line.getAllocatedAmount() != null) {
                realized = Objects.requireNonNullElse(realized, Money.zero())
                        .add(line.getAllocatedAmount().subtract(cost));
            }
        }

        List<String> warnings = new ArrayList<>();
        if (sample) {
            warnings.add("SAMPLE_PRICES");
        }
        if (totals.unpricedCopies() > 0) {
            warnings.add("UNPRICED_COPIES");
        }
        if (stale > 0) {
            warnings.add("STALE_PRICES");
        }
        if (totals.copiesWithoutCost() > 0) {
            warnings.add("MISSING_PURCHASE_PRICES");
        }
        return new PortfolioSummaryDto(prices.currency(), totals.marketValue(), totals.costBasis(),
                totals.unrealizedGain(), totals.unrealizedGainPercent(), realized, totals.distinctCards(),
                totals.copies(), totals.pricedCopies(), totals.unpricedCopies(), totals.copiesWithoutCost(), stale,
                List.copyOf(sources), sample, oldest, newest, warnings);
    }
}
