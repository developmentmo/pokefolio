package app.pokefolio.pricing;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Source of market prices. Implementations are isolated adapters; portfolio and transaction logic only read
 * stored {@link PriceObservation}s and never call a provider directly.
 */
public interface PriceProvider {

    /** Human readable source name stored with each observation, shown to users. */
    String sourceId();

    /** True when quotes are sample data rather than real market prices. */
    boolean sampleData();

    /** The latest available price, or empty when the provider has none for this card. */
    Optional<Quote> currentPrice(CardRef card);

    /** Historical prices (for backfill); providers without history return an empty list. */
    List<Quote> history(CardRef card, LocalDate from, LocalDate to);

    record CardRef(String provider, String externalId, String name, String setExternalId, String number) {
    }

    record Quote(BigDecimal market, BigDecimal low, BigDecimal high, String currency, Instant observedAt) {
    }
}
