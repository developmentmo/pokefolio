package app.pokefolio.pricing;

import app.pokefolio.catalog.provider.CatalogSyncService;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/** Synchronises the catalog on startup and refreshes prices on a schedule. */
@Component
@ConditionalOnProperty(name = "pokefolio.catalog.sync-on-startup", havingValue = "true", matchIfMissing = true)
public class CatalogBootstrap {

    private final CatalogSyncService catalogSync;
    private final PriceService prices;

    public CatalogBootstrap(CatalogSyncService catalogSync, PriceService prices) {
        this.catalogSync = catalogSync;
        this.prices = prices;
    }

    @EventListener(ApplicationReadyEvent.class)
    public void onStartup() {
        catalogSync.synchronize();
        prices.backfillAll();
        prices.refreshAll();
    }

    /** Default: once a day, which fits comfortably within small API plans. */
    @Scheduled(cron = "${pokefolio.pricing.refresh-cron:0 0 6 * * *}", zone = "UTC")
    public void scheduledRefresh() {
        prices.refreshAll();
    }
}
