import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pokefolio/core/format/formatters.dart';

void main() {
  setUpAll(() => initializeDateFormatting('nl_NL'));

  test('formats euros the Dutch way and unknown as Onbekend', () {
    expect(Fmt.money(Decimal.parse('1234.5')), '€\u00A01.234,50');
    expect(Fmt.money(null), 'Onbekend');
    expect(Fmt.signedMoney(Decimal.parse('-3')), '−€\u00A03,00');
    expect(Fmt.percent(Decimal.parse('12.34')), '+12,3%');
  });

  test('parses money input with comma or dot and rejects invalid values', () {
    expect(parseMoneyInput('12,50'), Decimal.parse('12.50'));
    expect(parseMoneyInput('€ 7.5'), Decimal.parse('7.5'));
    expect(parseMoneyInput(''), isNull);
    expect(parseMoneyInput('-1'), isNull);
    expect(parseMoneyInput('1.234'), isNull);
    expect(parseMoneyInput('abc'), isNull);
  });
}
