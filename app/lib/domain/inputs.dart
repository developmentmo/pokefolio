import 'package:decimal/decimal.dart';

import 'converters.dart';
import 'enums.dart';

/// Write models sent to the backend. The owner is never part of a request: the server derives it from the token.
class HoldingInput {
  const HoldingInput({
    required this.condition,
    required this.language,
    required this.variant,
    this.purchasePrice,
    this.purchaseDate,
    this.notes,
  });

  final CardCondition condition;
  final CardLanguage language;
  final CardVariant variant;
  final Decimal? purchasePrice;
  final DateTime? purchaseDate;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'condition': enumApiValue(condition),
    'language': enumApiValue(language),
    'variant': enumApiValue(variant),
    'purchasePrice': purchasePrice?.toString(),
    'purchaseDate': purchaseDate == null ? null : formatDateOnly(purchaseDate!),
    'notes': (notes == null || notes!.trim().isEmpty) ? null : notes!.trim(),
  };
}

class SaleInput {
  const SaleInput({required this.holdingIds, required this.date, required this.proceeds, this.fees, this.notes});

  final List<String> holdingIds;
  final DateTime date;
  final Decimal proceeds;
  final Decimal? fees;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'holdingIds': holdingIds,
    'date': formatDateOnly(date),
    'proceeds': proceeds.toString(),
    'fees': fees?.toString(),
    'notes': notes,
  };
}

class GiftInput {
  const GiftInput({required this.holdingIds, required this.date, this.notes});

  final List<String> holdingIds;
  final DateTime date;
  final String? notes;

  Map<String, dynamic> toJson() => {'holdingIds': holdingIds, 'date': formatDateOnly(date), 'notes': notes};
}

class ReceivedCardInput {
  const ReceivedCardInput({
    required this.cardId,
    required this.quantity,
    required this.condition,
    required this.language,
    required this.variant,
    this.value,
    this.notes,
  });

  final String cardId;
  final int quantity;
  final CardCondition condition;
  final CardLanguage language;
  final CardVariant variant;
  final Decimal? value;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'cardId': cardId,
    'quantity': quantity,
    'condition': enumApiValue(condition),
    'language': enumApiValue(language),
    'variant': enumApiValue(variant),
    'value': value?.toString(),
    'notes': notes,
  };
}

class TradeInput {
  const TradeInput({
    required this.givenHoldingIds,
    required this.received,
    required this.date,
    this.cashReceived,
    this.cashPaid,
    this.notes,
  });

  final List<String> givenHoldingIds;
  final List<ReceivedCardInput> received;
  final DateTime date;
  final Decimal? cashReceived;
  final Decimal? cashPaid;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'givenHoldingIds': givenHoldingIds,
    'received': received.map((r) => r.toJson()).toList(),
    'date': formatDateOnly(date),
    'cashReceived': cashReceived?.toString(),
    'cashPaid': cashPaid?.toString(),
    'notes': notes,
  };
}
