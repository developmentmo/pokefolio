import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';
import 'enums.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class Account with _$Account {
  const factory Account({
    required String id,
    required String email,
    required String displayName,
    required String preferredCurrency,
    required DateTime createdAt,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}

@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
    required Account account,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) => _$AuthSessionFromJson(json);
}

@freezed
abstract class CardSet with _$CardSet {
  const factory CardSet({
    required String id,
    required String externalId,
    required String name,
    String? series,
    @NullableDateOnlyConverter() DateTime? releaseDate,
    int? totalCards,
  }) = _CardSet;

  factory CardSet.fromJson(Map<String, dynamic> json) => _$CardSetFromJson(json);
}

/// Current price of a card. [status] unknown means "no price": never display it as zero.
@freezed
abstract class PriceInfo with _$PriceInfo {
  const PriceInfo._();

  const factory PriceInfo({
    required PriceStatus status,
    @NullableDecimalConverter() Decimal? market,
    @NullableDecimalConverter() Decimal? low,
    @NullableDecimalConverter() Decimal? high,
    required String currency,
    String? source,
    DateTime? observedAt,
    @Default(false) bool stale,
    @Default(false) bool sampleData,
  }) = _PriceInfo;

  factory PriceInfo.fromJson(Map<String, dynamic> json) => _$PriceInfoFromJson(json);

  bool get isAvailable => status == PriceStatus.available && market != null;
}

@freezed
abstract class PokemonCard with _$PokemonCard {
  const PokemonCard._();

  const factory PokemonCard({
    required String id,
    required String externalId,
    required String provider,
    required String name,
    required String number,
    String? rarity,
    String? supertype,
    String? pokemonType,
    String? imageUrl,
    String? imageUrlLarge,
    required CardSet set,
    PriceInfo? price,
  }) = _PokemonCard;

  factory PokemonCard.fromJson(Map<String, dynamic> json) => _$PokemonCardFromJson(json);

  String get displayNumber => set.totalCards == null ? number : '$number/${set.totalCards}';
}

@freezed
abstract class Holding with _$Holding {
  const factory Holding({
    required String id,
    required PokemonCard card,
    required CardCondition condition,
    required CardLanguage language,
    required CardVariant variant,
    @NullableDecimalConverter() Decimal? purchasePrice,
    required String purchaseCurrency,
    @NullableDateOnlyConverter() DateTime? purchaseDate,
    @DateOnlyConverter() required DateTime acquiredOn,
    String? notes,
    required HoldingStatus status,
    @NullableDateOnlyConverter() DateTime? disposedOn,
    @NullableDecimalConverter() Decimal? marketValue,
    @NullableDecimalConverter() Decimal? unrealizedGain,
    required DateTime createdAt,
  }) = _Holding;

  factory Holding.fromJson(Map<String, dynamic> json) => _$HoldingFromJson(json);
}

@freezed
abstract class CollectionEntry with _$CollectionEntry {
  const factory CollectionEntry({
    required PokemonCard card,
    required int copies,
    @NullableDecimalConverter() Decimal? marketValue,
    @DecimalConverter() required Decimal costBasis,
    required int copiesWithoutCost,
    @NullableDecimalConverter() Decimal? unrealizedGain,
    DateTime? lastAddedAt,
    required List<Holding> holdings,
  }) = _CollectionEntry;

  factory CollectionEntry.fromJson(Map<String, dynamic> json) => _$CollectionEntryFromJson(json);
}

@freezed
abstract class PortfolioSummary with _$PortfolioSummary {
  const PortfolioSummary._();

  const factory PortfolioSummary({
    required String currency,
    @DecimalConverter() required Decimal marketValue,
    @DecimalConverter() required Decimal costBasis,
    @NullableDecimalConverter() Decimal? unrealizedGain,
    @NullableDecimalConverter() Decimal? unrealizedGainPercent,
    @NullableDecimalConverter() Decimal? realizedGain,
    required int distinctCards,
    required int copies,
    required int pricedCopies,
    required int unpricedCopies,
    required int copiesWithoutCost,
    required int stalePricedCopies,
    required List<String> priceSources,
    required bool sampleData,
    DateTime? oldestPriceAt,
    DateTime? latestPriceAt,
    required List<String> warnings,
  }) = _PortfolioSummary;

  factory PortfolioSummary.fromJson(Map<String, dynamic> json) => _$PortfolioSummaryFromJson(json);

  bool get isEmpty => copies == 0;
}

@freezed
abstract class Dashboard with _$Dashboard {
  const factory Dashboard({
    required PortfolioSummary summary,
    required List<Holding> recentlyAdded,
    required List<Holding> mostValuable,
    required List<PortfolioTransaction> recentTransactions,
  }) = _Dashboard;

  factory Dashboard.fromJson(Map<String, dynamic> json) => _$DashboardFromJson(json);
}

@freezed
abstract class HistoryPoint with _$HistoryPoint {
  const factory HistoryPoint({
    @DateOnlyConverter() required DateTime date,
    @DecimalConverter() required Decimal marketValue,
    @DecimalConverter() required Decimal costBasis,
    required int copies,
    required int unpricedCopies,
  }) = _HistoryPoint;

  factory HistoryPoint.fromJson(Map<String, dynamic> json) => _$HistoryPointFromJson(json);
}

@freezed
abstract class PortfolioHistory with _$PortfolioHistory {
  const factory PortfolioHistory({
    required String currency,
    required bool sampleData,
    required String methodology,
    required List<HistoryPoint> points,
  }) = _PortfolioHistory;

  factory PortfolioHistory.fromJson(Map<String, dynamic> json) => _$PortfolioHistoryFromJson(json);
}

@freezed
abstract class PricePoint with _$PricePoint {
  const factory PricePoint({
    required DateTime observedAt,
    @DecimalConverter() required Decimal market,
    @NullableDecimalConverter() Decimal? low,
    @NullableDecimalConverter() Decimal? high,
    required String source,
    required bool sampleData,
  }) = _PricePoint;

  factory PricePoint.fromJson(Map<String, dynamic> json) => _$PricePointFromJson(json);
}

@freezed
abstract class PriceHistory with _$PriceHistory {
  const factory PriceHistory({required String cardId, required String currency, required List<PricePoint> points}) =
      _PriceHistory;

  factory PriceHistory.fromJson(Map<String, dynamic> json) => _$PriceHistoryFromJson(json);
}

@freezed
abstract class CardRef with _$CardRef {
  const factory CardRef({
    required String id,
    required String name,
    required String number,
    required String setName,
    String? rarity,
  }) = _CardRef;

  factory CardRef.fromJson(Map<String, dynamic> json) => _$CardRefFromJson(json);
}

@freezed
abstract class TransactionLine with _$TransactionLine {
  const factory TransactionLine({
    required String holdingId,
    required LineDirection direction,
    @NullableDecimalConverter() Decimal? allocatedAmount,
    required CardRef card,
    required CardCondition condition,
    required CardLanguage language,
    required CardVariant variant,
    @NullableDecimalConverter() Decimal? purchasePrice,
  }) = _TransactionLine;

  factory TransactionLine.fromJson(Map<String, dynamic> json) => _$TransactionLineFromJson(json);
}

/// Named PortfolioTransaction to avoid clashing with database/transaction terminology in Dart libraries.
@freezed
abstract class PortfolioTransaction with _$PortfolioTransaction {
  const factory PortfolioTransaction({
    required String id,
    required TransactionType type,
    @DateOnlyConverter() required DateTime occurredOn,
    required String currency,
    @NullableDecimalConverter() Decimal? cashIn,
    @NullableDecimalConverter() Decimal? cashOut,
    @NullableDecimalConverter() Decimal? fees,
    String? notes,
    required DateTime createdAt,
    required List<TransactionLine> lines,
    @NullableDecimalConverter() Decimal? realizedGain,
  }) = _PortfolioTransaction;

  factory PortfolioTransaction.fromJson(Map<String, dynamic> json) => _$PortfolioTransactionFromJson(json);
}

@freezed
abstract class CatalogFilters with _$CatalogFilters {
  const factory CatalogFilters({required List<CardSet> sets, required List<String> rarities}) = _CatalogFilters;

  factory CatalogFilters.fromJson(Map<String, dynamic> json) => _$CatalogFiltersFromJson(json);
}

/// Pagination envelope used by list endpoints.
class PageResult<T> {
  const PageResult({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory PageResult.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) item) => PageResult(
    content: (json['content'] as List).map((e) => item(e as Map<String, dynamic>)).toList(),
    page: json['page'] as int,
    size: json['size'] as int,
    totalElements: json['totalElements'] as int,
    totalPages: json['totalPages'] as int,
  );

  final List<T> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  bool get hasMore => page + 1 < totalPages;
}
