import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../core/network/api_client.dart';
import '../core/storage/token_storage.dart';
import '../features/auth/auth_controller.dart';
import 'api/api_repositories.dart';
import 'mock/mock_backend.dart';
import 'mock/mock_repositories.dart';
import 'repositories.dart';

/// Whether the app talks to the in-app mock backend. Overridable in tests.
final useMockDataProvider = Provider<bool>((ref) => AppConfig.useMockData);

final mockBackendProvider = Provider<MockBackend>((ref) => MockBackend());

final tokenStorageProvider = Provider<TokenStorage>((ref) => SecureTokenStorage());

final Provider<TokenManager> tokenManagerProvider = Provider<TokenManager>(
  (ref) => TokenManager(
    refresh: () => (ref.read(authenticationRepositoryProvider) as ApiAuthenticationRepository).refreshAccessToken(),
  ),
);

final Provider<Dio> dioProvider = Provider<Dio>(
  (ref) => createApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    tokens: ref.watch(tokenManagerProvider),
    onSessionExpired: () => ref.read(authControllerProvider.notifier).sessionExpired(),
  ),
);

final Provider<AuthenticationRepository> authenticationRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  if (ref.watch(useMockDataProvider)) return MockAuthenticationRepository(ref.watch(mockBackendProvider));
  return ApiAuthenticationRepository(
    ref.watch(dioProvider),
    ref.watch(tokenManagerProvider),
    ref.watch(tokenStorageProvider),
  );
});

final cardCatalogRepositoryProvider = Provider<CardCatalogRepository>((ref) {
  if (ref.watch(useMockDataProvider)) return MockCardCatalogRepository(ref.watch(mockBackendProvider));
  return ApiCardCatalogRepository(ref.watch(dioProvider));
});

final priceRepositoryProvider = Provider<PriceRepository>((ref) {
  if (ref.watch(useMockDataProvider)) return MockPriceRepository(ref.watch(mockBackendProvider));
  return ApiPriceRepository(ref.watch(dioProvider));
});

final portfolioRepositoryProvider = Provider<PortfolioRepository>((ref) {
  if (ref.watch(useMockDataProvider)) return MockPortfolioRepository(ref.watch(mockBackendProvider));
  return ApiPortfolioRepository(ref.watch(dioProvider));
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  if (ref.watch(useMockDataProvider)) return MockTransactionRepository(ref.watch(mockBackendProvider));
  return ApiTransactionRepository(ref.watch(dioProvider));
});
