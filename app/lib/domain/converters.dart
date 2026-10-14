import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';

/// Money is transported as JSON numbers and kept as exact [Decimal]s in the app.
class DecimalConverter implements JsonConverter<Decimal, Object> {
  const DecimalConverter();

  @override
  Decimal fromJson(Object json) => Decimal.parse(json.toString());

  @override
  Object toJson(Decimal object) => object.toString();
}

class NullableDecimalConverter implements JsonConverter<Decimal?, Object?> {
  const NullableDecimalConverter();

  @override
  Decimal? fromJson(Object? json) => json == null ? null : Decimal.parse(json.toString());

  @override
  Object? toJson(Decimal? object) => object?.toString();
}

/// ISO dates without time (LocalDate on the backend).
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => formatDateOnly(object);
}

class NullableDateOnlyConverter implements JsonConverter<DateTime?, String?> {
  const NullableDateOnlyConverter();

  @override
  DateTime? fromJson(String? json) => json == null ? null : DateTime.parse(json);

  @override
  String? toJson(DateTime? object) => object == null ? null : formatDateOnly(object);
}

String formatDateOnly(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
