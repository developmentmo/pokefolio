package app.pokefolio.portfolio;

import app.pokefolio.catalog.CatalogDtos.CardDto;
import app.pokefolio.common.ConflictException;
import app.pokefolio.common.NotFoundException;
import app.pokefolio.common.PageResponse;
import app.pokefolio.portfolio.CardHolding.CardAttributes;
import app.pokefolio.portfolio.HoldingDtos.CollectionEntryDto;
import app.pokefolio.portfolio.HoldingDtos.HoldingDto;
import app.pokefolio.portfolio.HoldingDtos.UpdateHoldingRequest;
import app.pokefolio.pricing.PriceInfo;
import app.pokefolio.pricing.PriceService;
import java.math.BigDecimal;
import java.time.Clock;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class HoldingService {

    public enum CollectionSort { VALUE, NAME, RECENT, GAIN, COPIES }

    private final CardHoldingRepository holdings;
    private final PriceService prices;
    private final Clock clock;

    public HoldingService(CardHoldingRepository holdings, PriceService prices, Clock clock) {
        this.holdings = holdings;
        this.prices = prices;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public PageResponse<HoldingDto> list(UUID userId, HoldingStatus status, UUID cardId, int page, int size) {
        Page<CardHolding> result = holdings.search(userId, status, cardId,
                PageRequest.of(page, size, Sort.by(Sort.Order.desc("createdAt"))));
        Map<UUID, PriceInfo> priceInfo = priceInfo(result.getContent());
        return PageResponse.of(result, h -> toDto(h, priceInfo.get(h.getCard().getId())));
    }

    @Transactional(readOnly = true)
    public HoldingDto get(UUID userId, UUID id) {
        CardHolding holding = load(userId, id);
        return toDto(holding, priceInfo(List.of(holding)).get(holding.getCard().getId()));
    }

    /** Edits descriptive attributes of a copy that is still in the collection. */
    @Transactional
    public HoldingDto update(UUID userId, UUID id, UpdateHoldingRequest request) {
        CardHolding holding = load(userId, id);
        if (!holding.isActive()) {
            throw new ConflictException("Only copies in the collection can be edited");
        }
        Instant now = clock.instant();
        holding.apply(new CardAttributes(request.condition(), request.language(), request.variant(),
                app.pokefolio.common.Money.normalize(request.purchasePrice()), request.purchaseDate(),
                request.notes()), now);
        return toDto(holding, priceInfo(List.of(holding)).get(holding.getCard().getId()));
    }

    /** Current collection grouped per catalog card, filtered, sorted and paginated. */
    @Transactional(readOnly = true)
    public PageResponse<CollectionEntryDto> collection(UUID userId, String query, CollectionSort sort, int page,
            int size) {
        List<CardHolding> active = holdings.findAllByUserIdAndStatus(userId, HoldingStatus.ACTIVE);
        Map<UUID, PriceInfo> priceInfo = priceInfo(active);
        Map<UUID, List<CardHolding>> byCard = new LinkedHashMap<>();
        for (CardHolding h : active) {
            byCard.computeIfAbsent(h.getCard().getId(), k -> new ArrayList<>()).add(h);
        }
        String q = query == null ? null : query.trim().toLowerCase(Locale.ROOT);
        List<CollectionEntryDto> entries = new ArrayList<>();
        for (List<CardHolding> copies : byCard.values()) {
            var card = copies.getFirst().getCard();
            if (q != null && !q.isEmpty()
                    && !card.getName().toLowerCase(Locale.ROOT).contains(q)
                    && !card.getSet().getName().toLowerCase(Locale.ROOT).contains(q)
                    && !card.getNumber().equalsIgnoreCase(q)) {
                continue;
            }
            entries.add(toEntry(copies, priceInfo.get(card.getId())));
        }
        entries.sort(comparator(sort == null ? CollectionSort.VALUE : sort));
        return PageResponse.of(entries, page, size);
    }

    Map<UUID, PriceInfo> priceInfo(Collection<CardHolding> list) {
        return prices.currentPriceInfo(list.stream().map(h -> h.getCard().getId()).distinct().toList());
    }

    public HoldingDto toDto(CardHolding h, PriceInfo price) {
        BigDecimal market = price != null && price.isAvailable() && h.isActive() ? price.market() : null;
        BigDecimal gain = market != null && h.getPurchasePrice() != null
                ? market.subtract(h.getPurchasePrice()) : null;
        return new HoldingDto(h.getId(), CardDto.from(h.getCard(), price), h.getCondition(), h.getLanguage(),
                h.getVariant(), h.getPurchasePrice(), h.getPurchaseCurrency(), h.getPurchaseDate(), h.getAcquiredOn(),
                h.getNotes(), h.getStatus(), h.getDisposedOn(), market, gain, h.getCreatedAt());
    }

    private CollectionEntryDto toEntry(List<CardHolding> copies, PriceInfo price) {
        List<ValuationCalculator.ValuedCopy> valued = copies.stream()
                .map(h -> new ValuationCalculator.ValuedCopy(h.getCard().getId(), h.getPurchasePrice(),
                        price != null && price.isAvailable() ? price.market() : null))
                .toList();
        ValuationCalculator.Totals totals = ValuationCalculator.totals(valued);
        Instant lastAdded = copies.stream().map(CardHolding::getCreatedAt).max(Comparator.naturalOrder()).orElse(null);
        List<HoldingDto> dtos = copies.stream()
                .sorted(Comparator.comparing(CardHolding::getCreatedAt).reversed())
                .map(h -> toDto(h, price)).toList();
        return new CollectionEntryDto(CardDto.from(copies.getFirst().getCard(), price), copies.size(),
                totals.pricedCopies() == 0 ? null : totals.marketValue(), totals.costBasis(),
                totals.copiesWithoutCost(), totals.unrealizedGain(), lastAdded, dtos);
    }

    private static Comparator<CollectionEntryDto> comparator(CollectionSort sort) {
        Comparator<CollectionEntryDto> byName = Comparator.comparing(e -> e.card().name().toLowerCase(Locale.ROOT));
        return switch (sort) {
            case VALUE -> Comparator.comparing(CollectionEntryDto::marketValue,
                    Comparator.nullsLast(Comparator.reverseOrder())).thenComparing(byName);
            case GAIN -> Comparator.comparing(CollectionEntryDto::unrealizedGain,
                    Comparator.nullsLast(Comparator.reverseOrder())).thenComparing(byName);
            case NAME -> byName.thenComparing(e -> e.card().number());
            case RECENT -> Comparator.comparing(CollectionEntryDto::lastAddedAt,
                    Comparator.nullsLast(Comparator.reverseOrder()));
            case COPIES -> Comparator.comparingInt(CollectionEntryDto::copies).reversed().thenComparing(byName);
        };
    }

    private CardHolding load(UUID userId, UUID id) {
        return holdings.findByIdAndUserId(id, userId).orElseThrow(() -> new NotFoundException("Copy not found"));
    }
}
