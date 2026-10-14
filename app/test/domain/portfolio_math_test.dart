import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokefolio/domain/portfolio_math.dart';

Decimal d(String v) => Decimal.parse(v);

void main() {
  group('computeTotals', () {
    test('sums multiple copies of the same card', () {
      final t = computeTotals([
        ValuedCopy(cardId: 'a', purchasePrice: d('100'), marketPrice: d('150')),
        ValuedCopy(cardId: 'a', purchasePrice: d('120'), marketPrice: d('150')),
        ValuedCopy(cardId: 'b', purchasePrice: d('5'), marketPrice: d('4.50')),
      ]);
      expect(t.marketValue, d('304.50'));
      expect(t.costBasis, d('225'));
      expect(t.unrealizedGain, d('79.50'));
      expect(t.unrealizedGainPercent, d('35.33'));
      expect(t.copies, 3);
      expect(t.distinctCards, 2);
    });

    test('unknown prices are excluded instead of valued at zero', () {
      final t = computeTotals([
        ValuedCopy(cardId: 'a', purchasePrice: d('100'), marketPrice: d('150')),
        ValuedCopy(cardId: 'b', purchasePrice: d('40')),
      ]);
      expect(t.marketValue, d('150'));
      expect(t.unrealizedGain, d('50'));
      expect(t.unpricedCopies, 1);
    });

    test('no gain when no copy has both prices', () {
      final t = computeTotals([ValuedCopy(cardId: 'a', marketPrice: d('10'))]);
      expect(t.unrealizedGain, isNull);
      expect(t.copiesWithoutCost, 1);
    });
  });

  test('allocate keeps every cent', () {
    final parts = allocate(d('100'), 3);
    expect(parts, [d('33.34'), d('33.33'), d('33.33')]);
    expect(parts.reduce((a, b) => a + b), d('100'));
  });
}
