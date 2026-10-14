import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../core/storage/token_storage.dart';
import '../../domain/enums.dart';
import '../../domain/inputs.dart';
import '../../domain/models.dart';
import '../repositories.dart';

Map<String, dynamic> _json(Response<dynamic> r) => r.data as Map<String, dynamic>;

class ApiAuthenticationRepository implements AuthenticationRepository {
  ApiAuthenticationRepository(this._dio, this._tokens, this._storage);

  final Dio _dio;
  final TokenManager _tokens;
  final TokenStorage _storage;

  Future<AuthSession> _store(Response<dynamic> response) async {
    final session = AuthSession.fromJson(_json(response));
    _tokens.accessToken = session.accessToken;
    await _storage.writeRefreshToken(session.refreshToken);
    return session;
  }

  @override
  Future<AuthSession> login(String email, String password) =>
      guardApi(() async => _store(await _dio.post('/auth/login', data: {'email': email, 'password': password})));

  @override
  Future<AuthSession> register(String email, String password, String displayName) => guardApi(
    () async => _store(
      await _dio.post('/auth/register', data: {'email': email, 'password': password, 'displayName': displayName}),
    ),
  );

  @override
  Future<AuthSession?> restoreSession() async {
    final refresh = await _storage.readRefreshToken();
    if (refresh == null) return null;
    try {
      return await _store(await _dio.post('/auth/refresh', data: {'refreshToken': refresh}));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _storage.clear();
        return null;
      }
      throw ApiException.fromDio(e);
    }
  }

  /// Used by [TokenManager] when an access token expires.
  Future<String?> refreshAccessToken() async {
    try {
      return (await restoreSession())?.accessToken;
    } on ApiException {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    final refresh = await _storage.readRefreshToken();
    _tokens.accessToken = null;
    await _storage.clear();
    if (refresh != null) {
      try {
        await _dio.post('/auth/logout', data: {'refreshToken': refresh});
      } on DioException {
        // the local session is gone either way
      }
    }
  }

  @override
  Future<void> requestPasswordReset(String email) =>
      guardApi(() => _dio.post('/auth/password/forgot', data: {'email': email}));

  @override
  Future<void> resetPassword(String token, String newPassword) =>
      guardApi(() => _dio.post('/auth/password/reset', data: {'token': token, 'newPassword': newPassword}));

  @override
  Future<Account> updateAccount({String? displayName}) =>
      guardApi(() async => Account.fromJson(_json(await _dio.patch('/account', data: {'displayName': displayName}))));

  @override
  Future<void> changePassword(String currentPassword, String newPassword) => guardApi(
    () => _dio.post('/account/password', data: {'currentPassword': currentPassword, 'newPassword': newPassword}),
  );

  @override
  Future<void> deleteAccount(String password) => guardApi(() async {
    await _dio.delete('/account', data: {'password': password});
    _tokens.accessToken = null;
    await _storage.clear();
  });
}

class ApiCardCatalogRepository implements CardCatalogRepository {
  ApiCardCatalogRepository(this._dio);

  final Dio _dio;

  @override
  Future<PageResult<PokemonCard>> search({
    String? query,
    String? setId,
    String? rarity,
    CardSort sort = CardSort.name,
    int page = 0,
    int size = 24,
  }) => guardApi(() async {
    final r = await _dio.get(
      '/cards',
      queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        'setId': ?setId,
        'rarity': ?rarity,
        'sort': sort.name.toUpperCase(),
        'page': page,
        'size': size,
      },
    );
    return PageResult.fromJson(_json(r), PokemonCard.fromJson);
  });

  @override
  Future<PokemonCard> getCard(String id) =>
      guardApi(() async => PokemonCard.fromJson(_json(await _dio.get('/cards/$id'))));

  @override
  Future<CatalogFilters> filters() =>
      guardApi(() async => CatalogFilters.fromJson(_json(await _dio.get('/catalog/filters'))));
}

class ApiPriceRepository implements PriceRepository {
  ApiPriceRepository(this._dio);

  final Dio _dio;

  @override
  Future<PriceHistory> history(String cardId, {int days = 90}) => guardApi(
    () async => PriceHistory.fromJson(_json(await _dio.get('/cards/$cardId/prices', queryParameters: {'days': days}))),
  );
}

class ApiPortfolioRepository implements PortfolioRepository {
  ApiPortfolioRepository(this._dio);

  final Dio _dio;

  @override
  Future<Dashboard> dashboard() =>
      guardApi(() async => Dashboard.fromJson(_json(await _dio.get('/portfolio/dashboard'))));

  @override
  Future<PortfolioSummary> summary() =>
      guardApi(() async => PortfolioSummary.fromJson(_json(await _dio.get('/portfolio/summary'))));

  @override
  Future<PortfolioHistory> history({int days = 90}) => guardApi(
    () async => PortfolioHistory.fromJson(_json(await _dio.get('/portfolio/history', queryParameters: {'days': days}))),
  );

  @override
  Future<PageResult<CollectionEntry>> collection({
    String? query,
    CollectionSort sort = CollectionSort.value,
    int page = 0,
    int size = 50,
  }) => guardApi(() async {
    final r = await _dio.get(
      '/collection',
      queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        'sort': sort.name.toUpperCase(),
        'page': page,
        'size': size,
      },
    );
    return PageResult.fromJson(_json(r), CollectionEntry.fromJson);
  });

  @override
  Future<PageResult<Holding>> holdings({HoldingStatus? status, String? cardId, int page = 0, int size = 100}) =>
      guardApi(() async {
        final r = await _dio.get(
          '/holdings',
          queryParameters: {
            'status': enumApiValue(status ?? HoldingStatus.active),
            'cardId': ?cardId,
            'page': page,
            'size': size,
          },
        );
        return PageResult.fromJson(_json(r), Holding.fromJson);
      });

  @override
  Future<Holding> holding(String id) => guardApi(() async => Holding.fromJson(_json(await _dio.get('/holdings/$id'))));

  @override
  Future<List<Holding>> addHoldings(String cardId, int quantity, HoldingInput input) => guardApi(() async {
    final r = await _dio.post('/holdings', data: {'cardId': cardId, 'quantity': quantity, ...input.toJson()});
    return (r.data as List).map((e) => Holding.fromJson(e as Map<String, dynamic>)).toList();
  });

  @override
  Future<Holding> updateHolding(String id, HoldingInput input) =>
      guardApi(() async => Holding.fromJson(_json(await _dio.put('/holdings/$id', data: input.toJson()))));
}

class ApiTransactionRepository implements TransactionRepository {
  ApiTransactionRepository(this._dio);

  final Dio _dio;

  Future<PortfolioTransaction> _post(String path, Map<String, dynamic> body) =>
      guardApi(() async => PortfolioTransaction.fromJson(_json(await _dio.post(path, data: body))));

  @override
  Future<PageResult<PortfolioTransaction>> list({TransactionType? type, int page = 0, int size = 20}) => guardApi(
    () async {
      final r = await _dio.get('/transactions', queryParameters: {'type': ?type?.apiValue, 'page': page, 'size': size});
      return PageResult.fromJson(_json(r), PortfolioTransaction.fromJson);
    },
  );

  @override
  Future<PortfolioTransaction> get(String id) =>
      guardApi(() async => PortfolioTransaction.fromJson(_json(await _dio.get('/transactions/$id'))));

  @override
  Future<PortfolioTransaction> sell(SaleInput input) => _post('/transactions/sales', input.toJson());

  @override
  Future<PortfolioTransaction> gift(GiftInput input) => _post('/transactions/gifts', input.toJson());

  @override
  Future<PortfolioTransaction> trade(TradeInput input) => _post('/transactions/trades', input.toJson());

  @override
  Future<PortfolioTransaction> correct(GiftInput input) => _post('/transactions/corrections', input.toJson());
}
