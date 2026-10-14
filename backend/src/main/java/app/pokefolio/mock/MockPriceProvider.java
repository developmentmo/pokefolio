package app.pokefolio.mock;

import app.pokefolio.common.Money;
import app.pokefolio.pricing.PriceProvider;
import java.math.BigDecimal;
import java.time.Clock;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/**
 * Deterministic sample prices: a smooth pseudo-random walk around each card's base price. Every quote is flagged
 * as sample data so the app can label it as such.
 */
@Component
@ConditionalOnProperty(name = "pokefolio.provider", havingValue = "mock", matchIfMissing = true)
public class MockPriceProvider implements PriceProvider {

    public static final String SOURCE = "PokeFolio sample data";

    private final Clock clock;

    public MockPriceProvider(Clock clock) {
        this.clock = clock;
    }

    @Override
    public String sourceId() {
        return SOURCE;
    }

    @Override
    public boolean sampleData() {
        return true;
    }

    @Override
    public Optional<Quote> currentPrice(CardRef card) {
        return priceOn(card.externalId(), LocalDate.now(clock));
    }

    @Override
    public List<Quote> history(CardRef card, LocalDate from, LocalDate to) {
        List<Quote> quotes = new ArrayList<>();
        for (LocalDate day = from; !day.isAfter(to); day = day.plusDays(1)) {
            priceOn(card.externalId(), day).ifPresent(quotes::add);
        }
        return quotes;
    }

    Optional<Quote> priceOn(String externalId, LocalDate day) {
        MockCatalogData.MockCard card = MockCatalogData.BY_EXTERNAL_ID.get(externalId);
        if (card == null || card.basePrice() == null) {
            return Optional.empty();
        }
        if (MockCatalogData.STALE_CARDS.contains(externalId)
                && day.isAfter(LocalDate.now(clock).minusDays(MockCatalogData.STALE_DAYS))) {
            return Optional.empty();
        }
        double seed = Math.abs(externalId.hashCode() % 1000) / 100.0;
        double t = day.toEpochDay();
        double factor = 1.0
                + 0.12 * Math.sin(t / 29.0 + seed)
                + 0.05 * Math.sin(t / 7.0 + seed * 3)
                + 0.02 * Math.sin(t / 2.3 + seed * 7);
        BigDecimal market = Money.normalize(card.basePrice().multiply(BigDecimal.valueOf(factor)));
        BigDecimal low = Money.normalize(market.multiply(new BigDecimal("0.85")));
        BigDecimal high = Money.normalize(market.multiply(new BigDecimal("1.20")));
        return Optional.of(new Quote(market, low, high, "EUR",
                day.atTime(LocalTime.NOON).toInstant(ZoneOffset.UTC)));
    }
}
