import 'package:dio/dio.dart';

/// User-presentable error derived from the backend's problem details.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.code, this.fieldErrors = const {}});

  final String message;
  final int? statusCode;
  final String? code;
  final Map<String, String> fieldErrors;

  bool get isUnauthorized => statusCode == 401;

  factory ApiException.fromDio(DioException e) {
    final response = e.response;
    if (response == null) {
      return const ApiException('Geen verbinding met de PokeFolio-server. Controleer je internetverbinding.');
    }
    final data = response.data;
    final status = response.statusCode;
    String? code;
    var fields = <String, String>{};
    String? detail;
    if (data is Map) {
      code = data['code'] as String?;
      detail = data['detail'] as String?;
      final errors = data['errors'];
      if (errors is Map) {
        fields = errors.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
    }
    return ApiException(_dutchMessage(status, code, detail), statusCode: status, code: code, fieldErrors: fields);
  }

  static String _dutchMessage(int? status, String? code, String? detail) {
    switch (code) {
      case 'validation_failed':
        return 'Controleer de ingevulde gegevens.';
      case 'concurrent_modification':
        return 'De gegevens zijn intussen gewijzigd. Vernieuw en probeer het opnieuw.';
    }
    return switch (status) {
      400 => detail ?? 'Ongeldige invoer.',
      401 =>
        detail == 'Invalid e-mail address or password'
            ? 'Onjuist e-mailadres of wachtwoord.'
            : 'Je sessie is verlopen. Log opnieuw in.',
      403 => 'Je hebt geen toegang tot deze gegevens.',
      404 => 'Niet gevonden.',
      409 =>
        detail == 'An account with this e-mail address already exists'
            ? 'Er bestaat al een account met dit e-mailadres.'
            : (detail ?? 'Deze actie botst met de huidige gegevens.'),
      _ => 'Er ging iets mis op de server. Probeer het later opnieuw.',
    };
  }

  @override
  String toString() => message;
}
