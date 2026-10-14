import 'dart:math' as math;

import 'package:decimal/decimal.dart';

import '../../domain/models.dart';

/// Sample catalog, identical to the backend mock provider. Prices are SAMPLE DATA, not market prices.
class MockCatalog {
  MockCatalog._();

  static const source = 'PokeFolio sample data';
  static const staleCard = 'sv4pt5-234';
  static const staleDays = 9;

  static final sets = <CardSet>[
    _set('base1', 'Base Set', 'Base', DateTime(1999, 1, 9), 102),
    _set('base2', 'Jungle', 'Base', DateTime(1999, 6, 16), 64),
    _set('base3', 'Fossil', 'Base', DateTime(1999, 10, 10), 62),
    _set('neo2', 'Neo Discovery', 'Neo', DateTime(2001, 6, 1), 75),
    _set('swsh7', 'Evolving Skies', 'Sword & Shield', DateTime(2021, 8, 27), 203),
    _set('swsh8', 'Fusion Strike', 'Sword & Shield', DateTime(2021, 11, 12), 264),
    _set('sv3', 'Obsidian Flames', 'Scarlet & Violet', DateTime(2023, 8, 11), 197),
    _set('sv3pt5', '151', 'Scarlet & Violet', DateTime(2023, 9, 22), 165),
    _set('sv4pt5', 'Paldean Fates', 'Scarlet & Violet', DateTime(2024, 1, 26), 91),
    _set('sv8pt5', 'Prismatic Evolutions', 'Scarlet & Violet', DateTime(2025, 1, 17), 131),
  ];

  static final _raw = <(String, String, String, String, String, String?)>[
    ('base1', '4', 'Charizard', 'Rare Holo', 'Fire', '420.00'),
    ('base1', '2', 'Blastoise', 'Rare Holo', 'Water', '180.00'),
    ('base1', '15', 'Venusaur', 'Rare Holo', 'Grass', '150.00'),
    ('base1', '10', 'Mewtwo', 'Rare Holo', 'Psychic', '95.00'),
    ('base1', '58', 'Pikachu', 'Common', 'Lightning', '12.50'),
    ('base2', '51', 'Eevee', 'Common', 'Colorless', '6.00'),
    ('base2', '60', 'Pikachu', 'Common', 'Lightning', '8.00'),
    ('base3', '5', 'Gengar', 'Rare Holo', 'Psychic', '85.00'),
    ('neo2', '13', 'Umbreon', 'Rare Holo', 'Darkness', null),
    ('neo2', '1', 'Espeon', 'Rare Holo', 'Psychic', '70.00'),
    ('swsh7', '215', 'Umbreon VMAX', 'Alternate Art Secret', 'Darkness', '1450.00'),
    ('swsh7', '212', 'Sylveon VMAX', 'Alternate Art Secret', 'Psychic', '240.00'),
    ('swsh7', '218', 'Rayquaza VMAX', 'Alternate Art Secret', 'Dragon', '520.00'),
    ('swsh8', '271', 'Gengar VMAX', 'Alternate Art Secret', 'Darkness', '390.00'),
    ('swsh8', '269', 'Mew VMAX', 'Alternate Art Secret', 'Psychic', '210.00'),
    ('sv3', '223', 'Charizard ex', 'Special Illustration Rare', 'Darkness', '95.00'),
    ('sv3', '125', 'Charizard ex', 'Double Rare', 'Darkness', '9.50'),
    ('sv3pt5', '199', 'Charizard ex', 'Special Illustration Rare', 'Fire', '145.00'),
    ('sv3pt5', '173', 'Pikachu', 'Illustration Rare', 'Lightning', '22.00'),
    ('sv3pt5', '205', 'Mew ex', 'Hyper Rare', 'Psychic', '55.00'),
    ('sv3pt5', '150', 'Mewtwo', 'Rare', 'Psychic', '2.50'),
    ('sv3pt5', '094', 'Gengar', 'Rare', 'Psychic', '1.80'),
    ('sv3pt5', '133', 'Eevee', 'Common', 'Colorless', '0.40'),
    ('sv3pt5', '025', 'Pikachu', 'Common', 'Lightning', '0.60'),
    ('sv4pt5', '234', 'Charizard ex', 'Special Illustration Rare', 'Darkness', '120.00'),
    ('sv8pt5', '161', 'Umbreon ex', 'Special Illustration Rare', 'Darkness', '1150.00'),
    ('sv8pt5', '167', 'Eevee ex', 'Special Illustration Rare', 'Colorless', '160.00'),
    ('sv8pt5', '156', 'Sylveon ex', 'Special Illustration Rare', 'Psychic', '120.00'),
  ];

  static final Map<String, Decimal?> basePrices = {
    for (final r in _raw) '${r.$1}-${r.$2}': r.$6 == null ? null : Decimal.parse(r.$6!),
  };

  /// Catalog cards without price information (prices are attached by the mock backend).
  static final cards = <PokemonCard>[
    for (final r in _raw)
      PokemonCard(
        id: 'card-${r.$1}-${r.$2}',
        externalId: '${r.$1}-${r.$2}',
        provider: 'mock',
        name: r.$3,
        number: r.$2,
        rarity: r.$4,
        supertype: 'Pokémon',
        pokemonType: r.$5,
        set: sets.firstWhere((s) => s.externalId == r.$1),
      ),
  ];

  static CardSet _set(String id, String name, String series, DateTime release, int total) =>
      CardSet(id: 'set-$id', externalId: id, name: name, series: series, releaseDate: release, totalCards: total);

  /// Same deterministic walk as the backend's MockPriceProvider.
  static Decimal? priceOn(String externalId, DateTime day, DateTime today) {
    final base = basePrices[externalId];
    if (base == null) return null;
    final d = DateTime.utc(day.year, day.month, day.day);
    final t = DateTime.utc(today.year, today.month, today.day);
    if (externalId == staleCard && d.isAfter(t.subtract(const Duration(days: staleDays)))) return null;
    final seed = _javaHash(externalId).remainder(1000).abs() / 100.0;
    final epochDay = d.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
    final factor =
        1.0 +
        0.12 * math.sin(epochDay / 29.0 + seed) +
        0.05 * math.sin(epochDay / 7.0 + seed * 3) +
        0.02 * math.sin(epochDay / 2.3 + seed * 7);
    return Decimal.parse((base.toDouble() * factor).toStringAsFixed(2));
  }

  /// Java's String.hashCode, so sample prices match the backend exactly.
  static int _javaHash(String s) {
    var h = 0;
    for (final unit in s.codeUnits) {
      h = (31 * h + unit) & 0xFFFFFFFF;
    }
    return h >= 0x80000000 ? h - 0x100000000 : h;
  }
}
