import '../domain/enums.dart';
import '../domain/inputs.dart';
import '../domain/models.dart';

/// Repository abstractions. Two implementations exist: `api/` (PokeFolio backend) and `mock/` (in-app sample
/// data). Screens and state only depend on these interfaces.

enum CardSort { name, number, newest }

enum CollectionSort {
  value('Waarde'),
  name('Naam'),
  recent('Recent toegevoegd'),
  gain('Winst/verlies'),
  copies('Aantal exemplaren');

  const CollectionSort(this.label);
  final String label;
}

abstract class AuthenticationRepository {
  Future<AuthSession> login(String email, String password);
  Future<AuthSession> register(String email, String password, String displayName);

  /// Restores a session from the stored refresh token, or returns null.
  Future<AuthSession?> restoreSession();
  Future<void> logout();
  Future<void> requestPasswordReset(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<Account> updateAccount({String? displayName});
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> deleteAccount(String password);
}

abstract class CardCatalogRepository {
  Future<PageResult<PokemonCard>> search({
    String? query,
    String? setId,
    String? rarity,
    CardSort sort = CardSort.name,
    int page = 0,
    int size = 24,
  });
  Future<PokemonCard> getCard(String id);
  Future<CatalogFilters> filters();
}

abstract class PriceRepository {
  Future<PriceHistory> history(String cardId, {int days = 90});
}

abstract class PortfolioRepository {
  Future<Dashboard> dashboard();
  Future<PortfolioSummary> summary();
  Future<PortfolioHistory> history({int days = 90});
  Future<PageResult<CollectionEntry>> collection({
    String? query,
    CollectionSort sort = CollectionSort.value,
    int page = 0,
    int size = 50,
  });
  Future<PageResult<Holding>> holdings({HoldingStatus? status, String? cardId, int page = 0, int size = 100});
  Future<Holding> holding(String id);
  Future<List<Holding>> addHoldings(String cardId, int quantity, HoldingInput input);
  Future<Holding> updateHolding(String id, HoldingInput input);
}

abstract class TransactionRepository {
  Future<PageResult<PortfolioTransaction>> list({TransactionType? type, int page = 0, int size = 20});
  Future<PortfolioTransaction> get(String id);
  Future<PortfolioTransaction> sell(SaleInput input);
  Future<PortfolioTransaction> gift(GiftInput input);
  Future<PortfolioTransaction> trade(TradeInput input);

  /// Removes copies that were registered by mistake.
  Future<PortfolioTransaction> correct(GiftInput input);
}
