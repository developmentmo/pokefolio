package app.pokefolio.mock;

import app.pokefolio.catalog.provider.CardCatalogProvider;
import java.util.List;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/** Sample catalog used until a real provider is verified and enabled. */
@Component
@ConditionalOnProperty(name = "pokefolio.provider", havingValue = "mock", matchIfMissing = true)
public class MockCardCatalogProvider implements CardCatalogProvider {

    public static final String PROVIDER_ID = "mock";

    @Override
    public String providerId() {
        return PROVIDER_ID;
    }

    @Override
    public List<ProviderCardSet> fetchSets() {
        return MockCatalogData.SETS.stream()
                .map(s -> new ProviderCardSet(s.externalId(), s.name(), s.series(), s.releaseDate(), s.totalCards()))
                .toList();
    }

    @Override
    public List<ProviderCard> fetchCards(String setExternalId) {
        return MockCatalogData.CARDS.stream()
                .filter(c -> c.setId().equals(setExternalId))
                // No images: we do not hotlink copyrighted card art; the app renders its own placeholder.
                .map(c -> new ProviderCard(c.externalId(), c.setId(), c.name(), c.number(), c.rarity(), "Pokémon",
                        c.type(), null, null))
                .toList();
    }
}
