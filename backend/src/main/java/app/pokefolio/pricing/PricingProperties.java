package app.pokefolio.pricing;

import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * @param currency     portfolio currency (MVP: single currency)
 * @param staleAfter   prices older than this are flagged as stale
 * @param backfillDays days of history to import for cards without observations
 */
@ConfigurationProperties(prefix = "pokefolio.pricing")
public record PricingProperties(String currency, Duration staleAfter, int backfillDays) {

    public PricingProperties {
        currency = currency == null ? "EUR" : currency;
        staleAfter = staleAfter == null ? Duration.ofHours(48) : staleAfter;
        backfillDays = backfillDays <= 0 ? 180 : backfillDays;
    }
}
