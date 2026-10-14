package app.pokefolio.catalog.provider;

import java.time.LocalDate;
import java.util.List;

/**
 * Source of catalog data (sets and cards). Implementations are isolated adapters; the rest of PokeFolio only
 * sees the imported {@code CardSet}/{@code PokemonCard} rows.
 */
public interface CardCatalogProvider {

    /** Stable identifier stored with every imported row, e.g. {@code mock}. */
    String providerId();

    List<ProviderCardSet> fetchSets();

    List<ProviderCard> fetchCards(String setExternalId);

    record ProviderCardSet(String externalId, String name, String series, LocalDate releaseDate,
            Integer totalCards) {
    }

    record ProviderCard(String externalId, String setExternalId, String name, String number, String rarity,
            String supertype, String pokemonType, String imageUrl, String imageUrlLarge) {
    }
}
