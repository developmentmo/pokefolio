/// Build-time configuration via `--dart-define`. Never put secrets here: everything in a Flutter build is public.
class AppConfig {
  const AppConfig._();

  static const appName = 'PokeFolio';

  /// Base URL of the PokeFolio backend, e.g. `http://localhost:8080`.
  static const apiBaseUrl = String.fromEnvironment('POKEFOLIO_API_URL');

  /// `api` or `mock`. Defaults to `api` when an API URL is configured, otherwise to the in-app mock data.
  static const _dataSource = String.fromEnvironment('POKEFOLIO_DATA_SOURCE');

  static bool get useMockData => _dataSource.isNotEmpty ? _dataSource == 'mock' : apiBaseUrl.isEmpty;
}
