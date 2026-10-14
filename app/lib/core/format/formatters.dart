import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

/// Dutch formatting for money, dates and percentages.
class Fmt {
  const Fmt._();

  static final _dateFormat = DateFormat('d MMM yyyy', 'nl_NL');
  static final _dateTimeFormat = DateFormat('d MMM yyyy HH:mm', 'nl_NL');
  static final _shortDate = DateFormat('d MMM', 'nl_NL');

  static String money(Decimal? amount, {String currency = 'EUR'}) {
    if (amount == null) return 'Onbekend';
    final format = NumberFormat.currency(locale: 'nl_NL', name: currency, symbol: _symbol(currency));
    return format.format(amount.toDouble());
  }

  /// Signed money, e.g. "+ € 12,50".
  static String signedMoney(Decimal? amount, {String currency = 'EUR'}) {
    if (amount == null) return 'Onbekend';
    final sign = amount > Decimal.zero ? '+' : (amount < Decimal.zero ? '−' : '');
    return '$sign${money(amount.abs(), currency: currency)}';
  }

  static String percent(Decimal? value) {
    if (value == null) return '—';
    final sign = value > Decimal.zero ? '+' : (value < Decimal.zero ? '−' : '');
    return '$sign${NumberFormat('0.0', 'nl_NL').format(value.abs().toDouble())}%';
  }

  static String date(DateTime? d) => d == null ? '—' : _dateFormat.format(d.toLocal());

  static String dateTime(DateTime? d) => d == null ? '—' : _dateTimeFormat.format(d.toLocal());

  static String shortDate(DateTime d) => _shortDate.format(d);

  static String _symbol(String currency) => switch (currency) {
    'EUR' => '€',
    'USD' => r'$',
    'GBP' => '£',
    _ => currency,
  };
}

/// Parses user input like "12,50" or "12.50" into a Decimal with at most 2 decimals.
Decimal? parseMoneyInput(String? input) {
  if (input == null) return null;
  final cleaned = input.trim().replaceAll('€', '').replaceAll(' ', '').replaceAll(',', '.');
  if (cleaned.isEmpty) return null;
  final value = Decimal.tryParse(cleaned);
  if (value == null || value < Decimal.zero) return null;
  if (value.scale > 2) return null;
  return value;
}
