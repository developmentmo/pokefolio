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

final collectionProvider = FutureProvider.autoDispose.family<PageResult<CollectionEntry>, CollectionQuery>(
  (ref, q) => ref.watch(portfolioRepositoryProvider).collection(query: q.query, sort: q.sort, size: 500),
);

final activeHoldingsProvider = FutureProvider.autoDispose<List<Holding>>(
  (ref) async =>
      (await ref.watch(portfolioRepositoryProvider).holdings(status: HoldingStatus.active, size: 200)).content,
);

final cardHoldingsProvider = FutureProvider.autoDispose.family<List<Holding>, String>(
  (ref, cardId) async => (await ref.watch(portfolioRepositoryProvider).holdings(cardId: cardId, size: 200)).content,
);

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
