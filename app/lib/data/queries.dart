import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import '../domain/models.dart';
import 'providers.dart';
import 'repositories.dart';

/// Read-side state for screens. Mutations call `ref.invalidatePortfolio()` so every view refreshes.

final dashboardProvider = FutureProvider.autoDispose<Dashboard>(
  (ref) => ref.watch(portfolioRepositoryProvider).dashboard(),
);

final portfolioHistoryProvider = FutureProvider.autoDispose.family<PortfolioHistory, int>(
  (ref, days) => ref.watch(portfolioRepositoryProvider).history(days: days),
);

typedef CollectionQuery = ({String query, CollectionSort sort});

/// Largest page size the API accepts for list endpoints.
const maxPageSize = 100;

/// Loads every page of a paginated endpoint, for views that need the complete list.
Future<List<T>> fetchAllPages<T>(Future<PageResult<T>> Function(int page) load) async {
  final items = <T>[];
  for (var page = 0; ; page++) {
    final result = await load(page);
    items.addAll(result.content);
    if (!result.hasMore) return items;
  }
}

final collectionProvider = FutureProvider.autoDispose.family<List<CollectionEntry>, CollectionQuery>((ref, q) {
  final repo = ref.watch(portfolioRepositoryProvider);
  return fetchAllPages((page) => repo.collection(query: q.query, sort: q.sort, page: page, size: maxPageSize));
});

final activeHoldingsProvider = FutureProvider.autoDispose<List<Holding>>((ref) {
  final repo = ref.watch(portfolioRepositoryProvider);
  return fetchAllPages((page) => repo.holdings(status: HoldingStatus.active, page: page, size: maxPageSize));
});

final cardHoldingsProvider = FutureProvider.autoDispose.family<List<Holding>, String>((ref, cardId) {
  final repo = ref.watch(portfolioRepositoryProvider);
  return fetchAllPages((page) => repo.holdings(cardId: cardId, page: page, size: maxPageSize));
});

final holdingProvider = FutureProvider.autoDispose.family<Holding, String>(
  (ref, id) => ref.watch(portfolioRepositoryProvider).holding(id),
);

typedef CardQuery = ({String query, String? setId, String? rarity, CardSort sort, int page});

final cardSearchProvider = FutureProvider.autoDispose.family<PageResult<PokemonCard>, CardQuery>(
  (ref, q) => ref
      .watch(cardCatalogRepositoryProvider)
      .search(query: q.query, setId: q.setId, rarity: q.rarity, sort: q.sort, page: q.page),
);

final catalogFiltersProvider = FutureProvider<CatalogFilters>(
  (ref) => ref.watch(cardCatalogRepositoryProvider).filters(),
);

final cardProvider = FutureProvider.autoDispose.family<PokemonCard, String>(
  (ref, id) => ref.watch(cardCatalogRepositoryProvider).getCard(id),
);

typedef PriceHistoryQuery = ({String cardId, int days});

final priceHistoryProvider = FutureProvider.autoDispose.family<PriceHistory, PriceHistoryQuery>(
  (ref, q) => ref.watch(priceRepositoryProvider).history(q.cardId, days: q.days),
);

typedef TransactionQuery = ({TransactionType? type, int page});

final transactionsProvider = FutureProvider.autoDispose.family<PageResult<PortfolioTransaction>, TransactionQuery>(
  (ref, q) => ref.watch(transactionRepositoryProvider).list(type: q.type, page: q.page, size: 25),
);

extension WidgetRefInvalidation on WidgetRef {
  void invalidatePortfolio() {
    invalidate(dashboardProvider);
    invalidate(portfolioHistoryProvider);
    invalidate(collectionProvider);
    invalidate(activeHoldingsProvider);
    invalidate(cardHoldingsProvider);
    invalidate(holdingProvider);
    invalidate(transactionsProvider);
  }
}
