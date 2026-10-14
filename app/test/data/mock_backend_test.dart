import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokefolio/core/network/api_exception.dart';
import 'package:pokefolio/data/mock/mock_backend.dart';
import 'package:pokefolio/domain/enums.dart';
import 'package:pokefolio/domain/inputs.dart';

const _attrs = HoldingInput(condition: CardCondition.nearMint, language: CardLanguage.en, variant: CardVariant.holo);

HoldingInput _priced(String price) => HoldingInput(
  condition: CardCondition.nearMint,
  language: CardLanguage.en,
  variant: CardVariant.holo,
  purchasePrice: Decimal.parse(price),
  purchaseDate: DateTime(2024, 1, 1),
);

void main() {
  late MockBackend backend;
  final today = DateTime.now();

  setUp(() {
    backend = MockBackend(seedDemoData: false);
    backend.register('ash@example.com', 'pikachu-forever', 'Ash');
  });

  test('multiple copies, unknown prices and totals', () {
    backend.addHoldings('card-base1-4', 3, _priced('100'));
    backend.addHoldings('card-neo2-13', 1, _priced('50'));
    final summary = backend.summary();
    final price = backend.card('card-base1-4').price!.market!;
    expect(summary.copies, 4);
    expect(summary.unpricedCopies, 1);
    expect(summary.marketValue, price * Decimal.fromInt(3));
    expect(summary.costBasis, Decimal.fromInt(350));
    expect(summary.warnings, containsAll(['SAMPLE_PRICES', 'UNPRICED_COPIES']));
  });

  test('sale removes copies and records realized gain', () {
    final ids = backend.addHoldings('card-base1-4', 2, _priced('100')).map((h) => h.id).toList();
    final tx = backend.sell(
      SaleInput(holdingIds: [ids.first], date: today, proceeds: Decimal.fromInt(300), fees: Decimal.fromInt(20)),
    );
    expect(tx.realizedGain, Decimal.fromInt(180));
    expect(backend.summary().copies, 1);
    expect(
      () => backend.sell(SaleInput(holdingIds: [ids.first], date: today, proceeds: Decimal.one)),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 409)),
    );
  });

  test('trade with several cards on both sides', () {
    final given = [
      ...backend.addHoldings('card-base1-4', 2, _attrs).map((h) => h.id),
      backend.addHoldings('card-base1-58', 1, _attrs).single.id,
    ];
    final tx = backend.trade(
      TradeInput(
        givenHoldingIds: given,
        received: const [
          ReceivedCardInput(
            cardId: 'card-swsh7-215',
            quantity: 1,
            condition: CardCondition.mint,
            language: CardLanguage.ja,
            variant: CardVariant.normal,
          ),
          ReceivedCardInput(
            cardId: 'card-swsh8-269',
            quantity: 2,
            condition: CardCondition.mint,
            language: CardLanguage.en,
            variant: CardVariant.normal,
          ),
        ],
        date: today,
      ),
    );
    expect(tx.lines.where((l) => l.direction == LineDirection.outgoing), hasLength(3));
    expect(tx.lines.where((l) => l.direction == LineDirection.incoming), hasLength(3));
    expect(backend.summary().copies, 3);
  });

  test('failed trade leaves the collection untouched', () {
    final ids = backend.addHoldings('card-base1-4', 2, _attrs).map((h) => h.id).toList();
    expect(
      () => backend.trade(
        TradeInput(
          givenHoldingIds: ids,
          received: const [
            ReceivedCardInput(
              cardId: 'does-not-exist',
              quantity: 1,
              condition: CardCondition.mint,
              language: CardLanguage.en,
              variant: CardVariant.normal,
            ),
          ],
          date: today,
        ),
      ),
      throwsA(isA<ApiException>()),
    );
    expect(backend.holdings(HoldingStatus.active, null, 0, 50).totalElements, 2);
    expect(backend.transactions(TransactionType.trade, 0, 10).totalElements, 0);
  });

  test('users only see their own data', () {
    final id = backend.addHoldings('card-base1-4', 1, _attrs).single.id;
    backend.logout();
    backend.register('misty@example.com', 'starmie-forever', 'Misty');
    expect(backend.summary().copies, 0);
    expect(() => backend.holding(id), throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)));
    expect(
      () => backend.gift(GiftInput(holdingIds: [id], date: today)),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
    );
  });

  test('stale sample prices are flagged and keep the last known value', () {
    final price = backend.card('card-sv4pt5-234').price!;
    expect(price.isAvailable, isTrue);
    expect(price.stale, isTrue);
    expect(backend.card('card-neo2-13').price!.isAvailable, isFalse);
  });
}
