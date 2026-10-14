package app.pokefolio.catalog.provider;

import app.pokefolio.catalog.CardSet;
import app.pokefolio.catalog.CardSetRepository;
import app.pokefolio.catalog.PokemonCard;
import app.pokefolio.catalog.PokemonCardRepository;
import java.time.Clock;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/** Upserts provider catalog data into the local catalog tables. */
@Service
public class CatalogSyncService {

    private static final Logger log = LoggerFactory.getLogger(CatalogSyncService.class);

    private final CardCatalogProvider provider;
    private final CardSetRepository sets;
    private final PokemonCardRepository cards;
    private final Clock clock;

    public CatalogSyncService(CardCatalogProvider provider, CardSetRepository sets, PokemonCardRepository cards,
            Clock clock) {
        this.provider = provider;
        this.sets = sets;
        this.cards = cards;
        this.clock = clock;
    }

    @Transactional
    public List<PokemonCard> synchronize() {
        Instant now = clock.instant();
        String providerId = provider.providerId();
        List<PokemonCard> imported = new ArrayList<>();
        for (CardCatalogProvider.ProviderCardSet s : provider.fetchSets()) {
            CardSet set = sets.findByProviderAndExternalId(providerId, s.externalId())
                    .orElseGet(() -> new CardSet(providerId, s.externalId(), now));
            set.update(s.name(), s.series(), s.releaseDate(), s.totalCards(), now);
            sets.save(set);
            for (CardCatalogProvider.ProviderCard c : provider.fetchCards(s.externalId())) {
                PokemonCard card = cards.findByProviderAndExternalId(providerId, c.externalId())
                        .orElseGet(() -> new PokemonCard(set, providerId, c.externalId(), now));
                card.update(c.name(), c.number(), c.rarity(), c.supertype(), c.pokemonType(), c.imageUrl(),
                        c.imageUrlLarge(), now);
                cards.save(card);
                imported.add(card);
            }
        }
        log.info("Catalog synchronised from provider '{}': {} cards", providerId, imported.size());
        return imported;
    }
}
