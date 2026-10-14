package app.pokefolio.pricing;

import app.pokefolio.catalog.PokemonCard;
import app.pokefolio.catalog.PokemonCardRepository;
import io.micrometer.core.instrument.MeterRegistry;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PriceService {

    private static final Logger log = LoggerFactory.getLogger(PriceService.class);

    private final PriceObservationRepository observations;
    private final PriceProvider provider;
    private final PokemonCardRepository cards;
    private final PricingProperties properties;
    private final MeterRegistry meters;
    private final Clock clock;

    public PriceService(PriceObservationRepository observations, PriceProvider provider,
            PokemonCardRepository cards, PricingProperties properties, MeterRegistry meters, Clock clock) {
        this.observations = observations;
        this.provider = provider;
        this.cards = cards;
        this.properties = properties;
        this.meters = meters;
        this.clock = clock;
    }

    public String currency() {
        return properties.currency();
    }

    @Transactional(readOnly = true)
    public Map<UUID, PriceObservation> latest(Collection<UUID> cardIds) {
        if (cardIds.isEmpty()) {
            return Map.of();
        }
        return observations.findLatestForCards(cardIds, properties.currency()).stream()
                .collect(Collectors.toMap(PriceObservation::getCardId, Function.identity()));
    }

    /** Price info for every requested card; cards without a price map to {@link PriceInfo#unknown}. */
    @Transactional(readOnly = true)
    public Map<UUID, PriceInfo> currentPriceInfo(Collection<UUID> cardIds) {
        Map<UUID, PriceObservation> latest = latest(cardIds);
        Map<UUID, PriceInfo> result = new HashMap<>();
        for (UUID id : cardIds) {
            result.put(id, toInfo(latest.get(id)));
        }
        return result;
    }

    public PriceInfo toInfo(PriceObservation o) {
        if (o == null) {
            return PriceInfo.unknown(properties.currency());
        }
        boolean stale = o.getObservedAt().isBefore(clock.instant().minus(properties.staleAfter()));
        return new PriceInfo(PriceInfo.Status.AVAILABLE, o.getMarketPrice(), o.getLowPrice(), o.getHighPrice(),
                o.getCurrency(), o.getSource(), o.getObservedAt(), stale, o.isSampleData());
    }

    @Transactional(readOnly = true)
    public PriceHistoryDto history(UUID cardId, int days) {
        Instant to = clock.instant();
        Instant from = to.minus(days, ChronoUnit.DAYS);
        List<PriceHistoryDto.Point> points = observations.findInRange(List.of(cardId), properties.currency(), from, to)
                .stream()
                .map(o -> new PriceHistoryDto.Point(o.getObservedAt(), o.getMarketPrice(), o.getLowPrice(),
                        o.getHighPrice(), o.getSource(), o.isSampleData()))
                .toList();
        return new PriceHistoryDto(cardId, properties.currency(), points);
    }

    /**
     * Fetches current prices. A provider failure or missing price never deletes or overwrites data: the last
     * known observation stays in place and is shown with its date (and a stale flag once it ages).
     */
    @Transactional
    public RefreshResult refreshAll() {
        return refresh(cards.findAllWithSet());
    }

    @Transactional
    public void backfillAll() {
        backfill(cards.findAllWithSet());
    }

    @Transactional
    public RefreshResult refresh(Collection<PokemonCard> cards) {
        int stored = 0;
        int missing = 0;
        int failed = 0;
        for (PokemonCard card : cards) {
            try {
                var quote = provider.currentPrice(ref(card));
                if (quote.isPresent()) {
                    if (store(card, quote.get())) {
                        stored++;
                    }
                } else {
                    missing++;
                }
            } catch (RuntimeException e) {
                failed++;
                log.warn("Price refresh failed for card {} ({}): {}", card.getExternalId(), card.getName(),
                        e.getMessage());
            }
        }
        meters.counter("pokefolio.prices.refresh", "outcome", "stored").increment(stored);
        meters.counter("pokefolio.prices.refresh", "outcome", "missing").increment(missing);
        meters.counter("pokefolio.prices.refresh", "outcome", "failed").increment(failed);
        log.info("Price refresh via '{}': {} stored, {} without price, {} failed", provider.sourceId(), stored,
                missing, failed);
        return new RefreshResult(stored, missing, failed);
    }

    /** Imports history for cards that have no observations yet. */
    @Transactional
    public void backfill(Collection<PokemonCard> cards) {
        LocalDate to = LocalDate.now(clock);
        LocalDate from = to.minusDays(properties.backfillDays());
        int stored = 0;
        for (PokemonCard card : cards) {
            if (observations.existsByCardId(card.getId())) {
                continue;
            }
            try {
                // the card has no observations yet, so no duplicate check per row is needed
                List<PriceObservation> batch = provider.history(ref(card), from, to).stream()
                        .filter(q -> properties.currency().equals(q.currency()) && q.market() != null)
                        .map(q -> new PriceObservation(card, provider.sourceId(), q.currency(), q.market(), q.low(),
                                q.high(), provider.sampleData(), q.observedAt(), clock.instant()))
                        .toList();
                observations.saveAll(batch);
                stored += batch.size();
            } catch (RuntimeException e) {
                log.warn("Price backfill failed for card {}: {}", card.getExternalId(), e.getMessage());
            }
        }
        log.info("Price backfill stored {} observations", stored);
    }

    private boolean store(PokemonCard card, PriceProvider.Quote quote) {
        if (!properties.currency().equals(quote.currency()) || quote.market() == null) {
            return false;
        }
        if (observations.existsByCardIdAndSourceAndCurrencyAndObservedAt(card.getId(), provider.sourceId(),
                quote.currency(), quote.observedAt())) {
            return false;
        }
        observations.save(new PriceObservation(card, provider.sourceId(), quote.currency(), quote.market(),
                quote.low(), quote.high(), provider.sampleData(), quote.observedAt(), clock.instant()));
        return true;
    }

    private static PriceProvider.CardRef ref(PokemonCard card) {
        return new PriceProvider.CardRef(card.getProvider(), card.getExternalId(), card.getName(),
                card.getSet().getExternalId(), card.getNumber());
    }

    public record RefreshResult(int stored, int missing, int failed) {
    }
}
