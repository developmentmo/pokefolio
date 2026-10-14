package app.pokefolio.mock;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * Fixed sample catalog for development. Prices are SAMPLE DATA ("voorbeeldgegevens"), not market prices.
 */
public final class MockCatalogData {

    public record MockSet(String externalId, String name, String series, LocalDate releaseDate, int totalCards) {
    }

    /** @param basePrice sample price in EUR, or {@code null} when the mock provider deliberately has no price */
    public record MockCard(String setId, String number, String name, String rarity, String type,
            BigDecimal basePrice) {

        public String externalId() {
            return setId + "-" + number;
        }
    }

    public static final List<MockSet> SETS = List.of(
            new MockSet("base1", "Base Set", "Base", LocalDate.of(1999, 1, 9), 102),
            new MockSet("base2", "Jungle", "Base", LocalDate.of(1999, 6, 16), 64),
            new MockSet("base3", "Fossil", "Base", LocalDate.of(1999, 10, 10), 62),
            new MockSet("neo2", "Neo Discovery", "Neo", LocalDate.of(2001, 6, 1), 75),
            new MockSet("swsh7", "Evolving Skies", "Sword & Shield", LocalDate.of(2021, 8, 27), 203),
            new MockSet("swsh8", "Fusion Strike", "Sword & Shield", LocalDate.of(2021, 11, 12), 264),
            new MockSet("sv3", "Obsidian Flames", "Scarlet & Violet", LocalDate.of(2023, 8, 11), 197),
            new MockSet("sv3pt5", "151", "Scarlet & Violet", LocalDate.of(2023, 9, 22), 165),
            new MockSet("sv4pt5", "Paldean Fates", "Scarlet & Violet", LocalDate.of(2024, 1, 26), 91),
            new MockSet("sv8pt5", "Prismatic Evolutions", "Scarlet & Violet", LocalDate.of(2025, 1, 17), 131));

    public static final List<MockCard> CARDS = List.of(
            card("base1", "4", "Charizard", "Rare Holo", "Fire", "420.00"),
            card("base1", "2", "Blastoise", "Rare Holo", "Water", "180.00"),
            card("base1", "15", "Venusaur", "Rare Holo", "Grass", "150.00"),
            card("base1", "10", "Mewtwo", "Rare Holo", "Psychic", "95.00"),
            card("base1", "58", "Pikachu", "Common", "Lightning", "12.50"),
            card("base2", "51", "Eevee", "Common", "Colorless", "6.00"),
            card("base2", "60", "Pikachu", "Common", "Lightning", "8.00"),
            card("base3", "5", "Gengar", "Rare Holo", "Psychic", "85.00"),
            card("neo2", "13", "Umbreon", "Rare Holo", "Darkness", null),
            card("neo2", "1", "Espeon", "Rare Holo", "Psychic", "70.00"),
            card("swsh7", "215", "Umbreon VMAX", "Alternate Art Secret", "Darkness", "1450.00"),
            card("swsh7", "212", "Sylveon VMAX", "Alternate Art Secret", "Psychic", "240.00"),
            card("swsh7", "218", "Rayquaza VMAX", "Alternate Art Secret", "Dragon", "520.00"),
            card("swsh8", "271", "Gengar VMAX", "Alternate Art Secret", "Darkness", "390.00"),
            card("swsh8", "269", "Mew VMAX", "Alternate Art Secret", "Psychic", "210.00"),
            card("sv3", "223", "Charizard ex", "Special Illustration Rare", "Darkness", "95.00"),
            card("sv3", "125", "Charizard ex", "Double Rare", "Darkness", "9.50"),
            card("sv3pt5", "199", "Charizard ex", "Special Illustration Rare", "Fire", "145.00"),
            card("sv3pt5", "173", "Pikachu", "Illustration Rare", "Lightning", "22.00"),
            card("sv3pt5", "205", "Mew ex", "Hyper Rare", "Psychic", "55.00"),
            card("sv3pt5", "150", "Mewtwo", "Rare", "Psychic", "2.50"),
            card("sv3pt5", "094", "Gengar", "Rare", "Psychic", "1.80"),
            card("sv3pt5", "133", "Eevee", "Common", "Colorless", "0.40"),
            card("sv3pt5", "025", "Pikachu", "Common", "Lightning", "0.60"),
            card("sv4pt5", "234", "Charizard ex", "Special Illustration Rare", "Darkness", "120.00"),
            card("sv8pt5", "161", "Umbreon ex", "Special Illustration Rare", "Darkness", "1150.00"),
            card("sv8pt5", "167", "Eevee ex", "Special Illustration Rare", "Colorless", "160.00"),
            card("sv8pt5", "156", "Sylveon ex", "Special Illustration Rare", "Psychic", "120.00"));

    /** Cards whose sample price feed "stopped" a while ago, to exercise stale-price handling. */
    public static final Set<String> STALE_CARDS = Set.of("sv4pt5-234");

    /** Number of days ago the stale feed stopped. */
    public static final int STALE_DAYS = 9;

    public static final Map<String, MockCard> BY_EXTERNAL_ID =
            CARDS.stream().collect(Collectors.toUnmodifiableMap(MockCard::externalId, Function.identity()));

    private MockCatalogData() {
    }

    private static MockCard card(String setId, String number, String name, String rarity, String type,
            String price) {
        return new MockCard(setId, number, name, rarity, type, price == null ? null : new BigDecimal(price));
    }
}
