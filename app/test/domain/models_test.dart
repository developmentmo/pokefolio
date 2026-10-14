import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokefolio/domain/enums.dart';
import 'package:pokefolio/domain/inputs.dart';
import 'package:pokefolio/domain/models.dart';

const _set = {
  'id': 's1',
  'externalId': 'base1',
  'name': 'Base Set',
  'series': 'Base',
  'releaseDate': '1999-01-09',
  'totalCards': 102,
};

void main() {
  test('parses a card with an exact decimal price', () {
    final card = PokemonCard.fromJson({
      'id': 'c1',
      'externalId': 'base1-4',
      'provider': 'mock',
      'name': 'Charizard',
      'number': '4',
      'rarity': 'Rare Holo',
      'set': _set,
      'price': {
        'status': 'AVAILABLE',
        'market': 420.1,
        'currency': 'EUR',
        'source': 'PokeFolio sample data',
        'observedAt': '2026-10-14T12:00:00Z',
        'stale': false,
        'sampleData': true,
      },
    });
    expect(card.price!.market, Decimal.parse('420.1'));
    expect(card.price!.isAvailable, isTrue);
    expect(card.displayNumber, '4/102');
    expect(card.set.releaseDate, DateTime(1999, 1, 9));
  });

  test('unknown price has no amount', () {
    final price = PriceInfo.fromJson({'status': 'UNKNOWN', 'currency': 'EUR', 'stale': false, 'sampleData': false});
    expect(price.isAvailable, isFalse);
    expect(price.market, isNull);
  });

  test('parses transactions with enum values', () {
    final tx = PortfolioTransaction.fromJson({
      'id': 't1',
      'type': 'TRADE',
      'occurredOn': '2026-10-01',
      'currency': 'EUR',
      'cashOut': 50,
      'createdAt': '2026-10-01T10:00:00Z',
      'lines': [
        {
          'holdingId': 'h1',
          'direction': 'OUT',
          'card': {'id': 'c1', 'name': 'Charizard', 'number': '4', 'setName': 'Base Set'},
          'condition': 'NEAR_MINT',
          'language': 'EN',
          'variant': 'FIRST_EDITION',
        },
      ],
    });
    expect(tx.type, TransactionType.trade);
    expect(tx.lines.single.direction, LineDirection.outgoing);
    expect(tx.lines.single.variant, CardVariant.firstEdition);
    expect(tx.cashOut, Decimal.fromInt(50));
  });

  test('inputs serialise to the API contract without an owner id', () {
    final json = HoldingInput(
      condition: CardCondition.lightPlayed,
      language: CardLanguage.ja,
      variant: CardVariant.reverseHolo,
      purchasePrice: Decimal.parse('12.50'),
      purchaseDate: DateTime(2024, 2, 3),
      notes: '  ',
    ).toJson();
    expect(json, {
      'condition': 'LIGHT_PLAYED',
      'language': 'JA',
      'variant': 'REVERSE_HOLO',
      'purchasePrice': '12.5',
      'purchaseDate': '2024-02-03',
      'notes': null,
    });
    expect(json.containsKey('userId'), isFalse);
  });
}
