import 'package:decimal/decimal.dart';

/// Portfolio formulas, identical to the backend's ValuationCalculator:
/// unknown prices are excluded (never valued at zero) and gains only use copies with both a market price and a
/// purchase price.
class ValuedCopy {
  const ValuedCopy({required this.cardId, this.purchasePrice, this.marketPrice});

  final String cardId;
  final Decimal? purchasePrice;
  final Decimal? marketPrice;
}

class PortfolioTotals {
  const PortfolioTotals({
    required this.marketValue,
    required this.costBasis,
    required this.unrealizedGain,
    required this.unrealizedGainPercent,
    required this.copies,
    required this.distinctCards,
    required this.pricedCopies,
    required this.unpricedCopies,
    required this.copiesWithoutCost,
  });

  final Decimal marketValue;
  final Decimal costBasis;
  final Decimal? unrealizedGain;
  final Decimal? unrealizedGainPercent;
  final int copies;
  final int distinctCards;
  final int pricedCopies;
  final int unpricedCopies;
  final int copiesWithoutCost;
}

PortfolioTotals computeTotals(List<ValuedCopy> copies) {
  var market = Decimal.zero;
  var cost = Decimal.zero;
  var gain = Decimal.zero;
  var gainCost = Decimal.zero;
  var priced = 0;
  var withoutCost = 0;
  var gainCopies = 0;
  final cards = <String>{};
  for (final c in copies) {
    cards.add(c.cardId);
    if (c.marketPrice != null) {
      market += c.marketPrice!;
      priced++;
    }
    if (c.purchasePrice != null) {
      cost += c.purchasePrice!;
    } else {
      withoutCost++;
    }
    if (c.marketPrice != null && c.purchasePrice != null) {
      gain += c.marketPrice! - c.purchasePrice!;
      gainCost += c.purchasePrice!;
      gainCopies++;
    }
  }
  Decimal? percent;
  if (gainCopies > 0 && gainCost != Decimal.zero) {
    percent = (gain * Decimal.fromInt(100) / gainCost).toDecimal(scaleOnInfinitePrecision: 4).round(scale: 2);
  }
  return PortfolioTotals(
    marketValue: market,
    costBasis: cost,
    unrealizedGain: gainCopies == 0 ? null : gain,
    unrealizedGainPercent: percent,
    copies: copies.length,
    distinctCards: cards.length,
    pricedCopies: priced,
    unpricedCopies: copies.length - priced,
    copiesWithoutCost: withoutCost,
  );
}

/// Splits [amount] over [parts] lines without losing cents; the remainder goes to the first line.
List<Decimal> allocate(Decimal amount, int parts) {
  if (parts <= 0) throw ArgumentError.value(parts, 'parts', 'must be positive');
  final cents = (amount * Decimal.fromInt(100)).round().toBigInt().toInt();
  final share = cents ~/ parts;
  final remainder = cents - share * parts;
  return List.generate(parts, (i) {
    final c = i == 0 ? share + remainder : share;
    return (Decimal.fromInt(c) / Decimal.fromInt(100)).toDecimal();
  });
}
