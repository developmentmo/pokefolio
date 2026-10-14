package app.pokefolio.pricing;

import java.math.BigDecimal;
import java.time.Instant;

/**
 * Current price of a card as presented to clients. {@code status = UNKNOWN} means no price is available:
 * clients must show "unknown", never zero.
 */
public record PriceInfo(Status status, BigDecimal market, BigDecimal low, BigDecimal high, String currency,
        String source, Instant observedAt, boolean stale, boolean sampleData) {

    public enum Status { AVAILABLE, UNKNOWN }

    public static PriceInfo unknown(String currency) {
        return new PriceInfo(Status.UNKNOWN, null, null, null, currency, null, null, false, false);
    }

    public boolean isAvailable() {
        return status == Status.AVAILABLE;
    }
}
