package app.pokefolio.catalog;

import app.pokefolio.pricing.PriceInfo;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public final class CatalogDtos {

    private CatalogDtos() {
    }

    public record CardSetDto(UUID id, String externalId, String name, String series, LocalDate releaseDate,
            Integer totalCards) {

        public static CardSetDto from(CardSet set) {
            return new CardSetDto(set.getId(), set.getExternalId(), set.getName(), set.getSeries(),
                    set.getReleaseDate(), set.getTotalCards());
        }
    }

    /** Card as shown in lists and embedded in holdings. */
    public record CardDto(UUID id, String externalId, String provider, String name, String number, String rarity,
            String supertype, String pokemonType, String imageUrl, String imageUrlLarge, CardSetDto set,
            PriceInfo price) {

        public static CardDto from(PokemonCard card, PriceInfo price) {
            return new CardDto(card.getId(), card.getExternalId(), card.getProvider(), card.getName(),
                    card.getNumber(), card.getRarity(), card.getSupertype(), card.getPokemonType(),
                    card.getImageUrl(), card.getImageUrlLarge(), CardSetDto.from(card.getSet()), price);
        }
    }

    public record CatalogFiltersDto(List<CardSetDto> sets, List<String> rarities) {
    }
}
