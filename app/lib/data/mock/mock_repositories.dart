import '../../domain/enums.dart';
import '../../domain/inputs.dart';
import '../../domain/models.dart';
import '../repositories.dart';
import 'mock_backend.dart';

/// Small artificial latency so loading states are visible in demo mode.
Future<T> _delay<T>(T Function() action) =>
    Future<void>.delayed(const Duration(milliseconds: 250)).then((_) => action());

class MockAuthenticationRepository implements AuthenticationRepository {
  MockAuthenticationRepository(this._backend);

  final MockBackend _backend;

  @override
  Future<AuthSession> login(String email, String password) => _delay(() => _backend.login(email, password));

  @override
  Future<AuthSession> register(String email, String password, String displayName) =>
      _delay(() => _backend.register(email, password, displayName));

  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<void> logout() async => _backend.logout();

  @override
  Future<void> requestPasswordReset(String email) => _delay(() => _backend.requestPasswordReset(email));

  @override
  Future<void> resetPassword(String token, String newPassword) =>
      _delay(() => _backend.resetPassword(token, newPassword));

  @override
  Future<Account> updateAccount({String? displayName}) => _delay(() => _backend.updateAccount(displayName));

  @override
  Future<void> changePassword(String currentPassword, String newPassword) =>
      _delay(() => _backend.changePassword(currentPassword, newPassword));

  @override
  Future<void> deleteAccount(String password) => _delay(() => _backend.deleteAccount(password));
}

class MockCardCatalogRepository implements CardCatalogRepository {
  MockCardCatalogRepository(this._backend);

  final MockBackend _backend;

  @override
  Future<PageResult<PokemonCard>> search({
    String? query,
    String? setId,
    String? rarity,
    CardSort sort = CardSort.name,
    int page = 0,
    int size = 24,
  }) => _delay(() => _backend.searchCards(query, setId, rarity, sort, page, size));

  @override
  Future<PokemonCard> getCard(String id) => _delay(() => _backend.card(id));

  @override
  Future<CatalogFilters> filters() => _delay(_backend.filters);
}

class MockPriceRepository implements PriceRepository {
  MockPriceRepository(this._backend);

  final MockBackend _backend;

  @override
  Future<PriceHistory> history(String cardId, {int days = 90}) => _delay(() => _backend.priceHistory(cardId, days));
}

class MockPortfolioRepository implements PortfolioRepository {
  MockPortfolioRepository(this._backend);

  final MockBackend _backend;

  @override
  Future<Dashboard> dashboard() => _delay(_backend.dashboard);

  @override
  Future<PortfolioSummary> summary() => _delay(_backend.summary);

  @override
  Future<PortfolioHistory> history({int days = 90}) => _delay(() => _backend.history(days));

  @override
  Future<PageResult<CollectionEntry>> collection({
    String? query,
    CollectionSort sort = CollectionSort.value,
    int page = 0,
    int size = 50,
  }) => _delay(() => _backend.collection(query, sort, page, size));

  @override
  Future<PageResult<Holding>> holdings({HoldingStatus? status, String? cardId, int page = 0, int size = 100}) =>
      _delay(() => _backend.holdings(status ?? HoldingStatus.active, cardId, page, size));

  @override
  Future<Holding> holding(String id) => _delay(() => _backend.holding(id));

  @override
  Future<List<Holding>> addHoldings(String cardId, int quantity, HoldingInput input) =>
      _delay(() => _backend.addHoldings(cardId, quantity, input));

  @override
  Future<Holding> updateHolding(String id, HoldingInput input) => _delay(() => _backend.updateHolding(id, input));
}

class MockTransactionRepository implements TransactionRepository {
  MockTransactionRepository(this._backend);

  final MockBackend _backend;

  @override
  Future<PageResult<PortfolioTransaction>> list({TransactionType? type, int page = 0, int size = 20}) =>
      _delay(() => _backend.transactions(type, page, size));

  @override
  Future<PortfolioTransaction> get(String id) => _delay(() => _backend.transaction(id));

  @override
  Future<PortfolioTransaction> sell(SaleInput input) => _delay(() => _backend.sell(input));

  @override
  Future<PortfolioTransaction> gift(GiftInput input) => _delay(() => _backend.gift(input));

  @override
  Future<PortfolioTransaction> trade(TradeInput input) => _delay(() => _backend.trade(input));

  @override
  Future<PortfolioTransaction> correct(GiftInput input) => _delay(() => _backend.gift(input, correction: true));
}
