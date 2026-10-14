import 'dart:async';

import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Holds the short-lived access token and knows how to refresh it.
class TokenManager {
  TokenManager({required this.refresh});

  /// Exchanges the stored refresh token for a new access token; returns null when the session is gone.
  final Future<String?> Function() refresh;

  String? accessToken;
  Future<String?>? _refreshing;

  /// Ensures concurrent 401s trigger a single refresh.
  Future<String?> refreshOnce() {
    return _refreshing ??= refresh().whenComplete(() => _refreshing = null);
  }
}

/// Dio configured for the PokeFolio API: JSON, timeouts, bearer token and one transparent refresh on 401.
Dio createApiClient({required String baseUrl, required TokenManager tokens, void Function()? onSessionExpired}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: '$baseUrl/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      contentType: Headers.jsonContentType,
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = tokens.accessToken;
        if (token != null && !options.path.startsWith('/auth/')) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final request = error.requestOptions;
        final isAuthCall = request.path.startsWith('/auth/');
        if (error.response?.statusCode == 401 && !isAuthCall && request.extra['retried'] != true) {
          final newToken = await tokens.refreshOnce();
          if (newToken != null) {
            request.headers['Authorization'] = 'Bearer $newToken';
            request.extra['retried'] = true;
            try {
              return handler.resolve(await dio.fetch(request));
            } on DioException catch (e) {
              return handler.next(e);
            }
          }
          onSessionExpired?.call();
        }
        handler.next(error);
      },
    ),
  );
  return dio;
}

/// Runs a request and converts Dio errors into [ApiException]s.
Future<T> guardApi<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    throw ApiException.fromDio(e);
  }
}
