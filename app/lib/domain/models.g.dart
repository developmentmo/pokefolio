// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  preferredCurrency: json['preferredCurrency'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'displayName': instance.displayName,
  'preferredCurrency': instance.preferredCurrency,
  'createdAt': instance.createdAt.toIso8601String(),
};

_AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => _AuthSession(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  expiresInSeconds: (json['expiresInSeconds'] as num).toInt(),
  account: Account.fromJson(json['account'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthSessionToJson(_AuthSession instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'expiresInSeconds': instance.expiresInSeconds,
  'account': instance.account,
};

_CardSet _$CardSetFromJson(Map<String, dynamic> json) => _CardSet(
  id: json['id'] as String,
  externalId: json['externalId'] as String,
  name: json['name'] as String,
  series: json['series'] as String?,
  releaseDate: const NullableDateOnlyConverter().fromJson(json['releaseDate'] as String?),
  totalCards: (json['totalCards'] as num?)?.toInt(),
);

Map<String, dynamic> _$CardSetToJson(_CardSet instance) => <String, dynamic>{
  'id': instance.id,
  'externalId': instance.externalId,
  'name': instance.name,
  'series': instance.series,
  'releaseDate': const NullableDateOnlyConverter().toJson(instance.releaseDate),
  'totalCards': instance.totalCards,
};

_PriceInfo _$PriceInfoFromJson(Map<String, dynamic> json) => _PriceInfo(
  status: $enumDecode(_$PriceStatusEnumMap, json['status']),
  market: const NullableDecimalConverter().fromJson(json['market']),
  low: const NullableDecimalConverter().fromJson(json['low']),
  high: const NullableDecimalConverter().fromJson(json['high']),
  currency: json['currency'] as String,
  source: json['source'] as String?,
  observedAt: json['observedAt'] == null ? null : DateTime.parse(json['observedAt'] as String),
  stale: json['stale'] as bool? ?? false,
  sampleData: json['sampleData'] as bool? ?? false,
);

Map<String, dynamic> _$PriceInfoToJson(_PriceInfo instance) => <String, dynamic>{
  'status': _$PriceStatusEnumMap[instance.status]!,
  'market': const NullableDecimalConverter().toJson(instance.market),
  'low': const NullableDecimalConverter().toJson(instance.low),
  'high': const NullableDecimalConverter().toJson(instance.high),
  'currency': instance.currency,
  'source': instance.source,
  'observedAt': instance.observedAt?.toIso8601String(),
  'stale': instance.stale,
  'sampleData': instance.sampleData,
};

const _$PriceStatusEnumMap = {PriceStatus.available: 'AVAILABLE', PriceStatus.unknown: 'UNKNOWN'};

_PokemonCard _$PokemonCardFromJson(Map<String, dynamic> json) => _PokemonCard(
  id: json['id'] as String,
  externalId: json['externalId'] as String,
  provider: json['provider'] as String,
  name: json['name'] as String,
  number: json['number'] as String,
  rarity: json['rarity'] as String?,
  supertype: json['supertype'] as String?,
  pokemonType: json['pokemonType'] as String?,
  imageUrl: json['imageUrl'] as String?,
  imageUrlLarge: json['imageUrlLarge'] as String?,
  set: CardSet.fromJson(json['set'] as Map<String, dynamic>),
  price: json['price'] == null ? null : PriceInfo.fromJson(json['price'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PokemonCardToJson(_PokemonCard instance) => <String, dynamic>{
  'id': instance.id,
  'externalId': instance.externalId,
  'provider': instance.provider,
  'name': instance.name,
  'number': instance.number,
  'rarity': instance.rarity,
  'supertype': instance.supertype,
  'pokemonType': instance.pokemonType,
  'imageUrl': instance.imageUrl,
  'imageUrlLarge': instance.imageUrlLarge,
  'set': instance.set,
  'price': instance.price,
};

_Holding _$HoldingFromJson(Map<String, dynamic> json) => _Holding(
  id: json['id'] as String,
  card: PokemonCard.fromJson(json['card'] as Map<String, dynamic>),
  condition: $enumDecode(_$CardConditionEnumMap, json['condition']),
  language: $enumDecode(_$CardLanguageEnumMap, json['language']),
  variant: $enumDecode(_$CardVariantEnumMap, json['variant']),
  purchasePrice: const NullableDecimalConverter().fromJson(json['purchasePrice']),
  purchaseCurrency: json['purchaseCurrency'] as String,
  purchaseDate: const NullableDateOnlyConverter().fromJson(json['purchaseDate'] as String?),
  acquiredOn: const DateOnlyConverter().fromJson(json['acquiredOn'] as String),
  notes: json['notes'] as String?,
  status: $enumDecode(_$HoldingStatusEnumMap, json['status']),
  disposedOn: const NullableDateOnlyConverter().fromJson(json['disposedOn'] as String?),
  marketValue: const NullableDecimalConverter().fromJson(json['marketValue']),
  unrealizedGain: const NullableDecimalConverter().fromJson(json['unrealizedGain']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$HoldingToJson(_Holding instance) => <String, dynamic>{
  'id': instance.id,
  'card': instance.card,
  'condition': _$CardConditionEnumMap[instance.condition]!,
  'language': _$CardLanguageEnumMap[instance.language]!,
  'variant': _$CardVariantEnumMap[instance.variant]!,
  'purchasePrice': const NullableDecimalConverter().toJson(instance.purchasePrice),
  'purchaseCurrency': instance.purchaseCurrency,
  'purchaseDate': const NullableDateOnlyConverter().toJson(instance.purchaseDate),
  'acquiredOn': const DateOnlyConverter().toJson(instance.acquiredOn),
  'notes': instance.notes,
  'status': _$HoldingStatusEnumMap[instance.status]!,
  'disposedOn': const NullableDateOnlyConverter().toJson(instance.disposedOn),
  'marketValue': const NullableDecimalConverter().toJson(instance.marketValue),
  'unrealizedGain': const NullableDecimalConverter().toJson(instance.unrealizedGain),
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$CardConditionEnumMap = {
  CardCondition.mint: 'MINT',
  CardCondition.nearMint: 'NEAR_MINT',
  CardCondition.excellent: 'EXCELLENT',
  CardCondition.good: 'GOOD',
  CardCondition.lightPlayed: 'LIGHT_PLAYED',
  CardCondition.played: 'PLAYED',
  CardCondition.poor: 'POOR',
};

const _$CardLanguageEnumMap = {
  CardLanguage.en: 'EN',
  CardLanguage.nl: 'NL',
  CardLanguage.de: 'DE',
  CardLanguage.fr: 'FR',
  CardLanguage.it: 'IT',
  CardLanguage.es: 'ES',
  CardLanguage.pt: 'PT',
  CardLanguage.ja: 'JA',
  CardLanguage.ko: 'KO',
  CardLanguage.zh: 'ZH',
};

const _$CardVariantEnumMap = {
  CardVariant.normal: 'NORMAL',
  CardVariant.holo: 'HOLO',
  CardVariant.reverseHolo: 'REVERSE_HOLO',
  CardVariant.firstEdition: 'FIRST_EDITION',
  CardVariant.shadowless: 'SHADOWLESS',
  CardVariant.unlimited: 'UNLIMITED',
  CardVariant.promo: 'PROMO',
  CardVariant.stamped: 'STAMPED',
};

const _$HoldingStatusEnumMap = {
  HoldingStatus.active: 'ACTIVE',
  HoldingStatus.sold: 'SOLD',
  HoldingStatus.givenAway: 'GIVEN_AWAY',
  HoldingStatus.tradedAway: 'TRADED_AWAY',
  HoldingStatus.removed: 'REMOVED',
};

_CollectionEntry _$CollectionEntryFromJson(Map<String, dynamic> json) => _CollectionEntry(
  card: PokemonCard.fromJson(json['card'] as Map<String, dynamic>),
  copies: (json['copies'] as num).toInt(),
  marketValue: const NullableDecimalConverter().fromJson(json['marketValue']),
  costBasis: const DecimalConverter().fromJson(json['costBasis'] as Object),
  copiesWithoutCost: (json['copiesWithoutCost'] as num).toInt(),
  unrealizedGain: const NullableDecimalConverter().fromJson(json['unrealizedGain']),
  lastAddedAt: json['lastAddedAt'] == null ? null : DateTime.parse(json['lastAddedAt'] as String),
  holdings: (json['holdings'] as List<dynamic>).map((e) => Holding.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$CollectionEntryToJson(_CollectionEntry instance) => <String, dynamic>{
  'card': instance.card,
  'copies': instance.copies,
  'marketValue': const NullableDecimalConverter().toJson(instance.marketValue),
  'costBasis': const DecimalConverter().toJson(instance.costBasis),
  'copiesWithoutCost': instance.copiesWithoutCost,
  'unrealizedGain': const NullableDecimalConverter().toJson(instance.unrealizedGain),
  'lastAddedAt': instance.lastAddedAt?.toIso8601String(),
  'holdings': instance.holdings,
};

_PortfolioSummary _$PortfolioSummaryFromJson(Map<String, dynamic> json) => _PortfolioSummary(
  currency: json['currency'] as String,
  marketValue: const DecimalConverter().fromJson(json['marketValue'] as Object),
  costBasis: const DecimalConverter().fromJson(json['costBasis'] as Object),
  unrealizedGain: const NullableDecimalConverter().fromJson(json['unrealizedGain']),
  unrealizedGainPercent: const NullableDecimalConverter().fromJson(json['unrealizedGainPercent']),
  realizedGain: const NullableDecimalConverter().fromJson(json['realizedGain']),
  distinctCards: (json['distinctCards'] as num).toInt(),
  copies: (json['copies'] as num).toInt(),
  pricedCopies: (json['pricedCopies'] as num).toInt(),
  unpricedCopies: (json['unpricedCopies'] as num).toInt(),
  copiesWithoutCost: (json['copiesWithoutCost'] as num).toInt(),
  stalePricedCopies: (json['stalePricedCopies'] as num).toInt(),
  priceSources: (json['priceSources'] as List<dynamic>).map((e) => e as String).toList(),
  sampleData: json['sampleData'] as bool,
  oldestPriceAt: json['oldestPriceAt'] == null ? null : DateTime.parse(json['oldestPriceAt'] as String),
  latestPriceAt: json['latestPriceAt'] == null ? null : DateTime.parse(json['latestPriceAt'] as String),
  warnings: (json['warnings'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$PortfolioSummaryToJson(_PortfolioSummary instance) => <String, dynamic>{
  'currency': instance.currency,
  'marketValue': const DecimalConverter().toJson(instance.marketValue),
  'costBasis': const DecimalConverter().toJson(instance.costBasis),
  'unrealizedGain': const NullableDecimalConverter().toJson(instance.unrealizedGain),
  'unrealizedGainPercent': const NullableDecimalConverter().toJson(instance.unrealizedGainPercent),
  'realizedGain': const NullableDecimalConverter().toJson(instance.realizedGain),
  'distinctCards': instance.distinctCards,
  'copies': instance.copies,
  'pricedCopies': instance.pricedCopies,
  'unpricedCopies': instance.unpricedCopies,
  'copiesWithoutCost': instance.copiesWithoutCost,
  'stalePricedCopies': instance.stalePricedCopies,
  'priceSources': instance.priceSources,
  'sampleData': instance.sampleData,
  'oldestPriceAt': instance.oldestPriceAt?.toIso8601String(),
  'latestPriceAt': instance.latestPriceAt?.toIso8601String(),
  'warnings': instance.warnings,
};

_Dashboard _$DashboardFromJson(Map<String, dynamic> json) => _Dashboard(
  summary: PortfolioSummary.fromJson(json['summary'] as Map<String, dynamic>),
  recentlyAdded: (json['recentlyAdded'] as List<dynamic>)
      .map((e) => Holding.fromJson(e as Map<String, dynamic>))
      .toList(),
  mostValuable: (json['mostValuable'] as List<dynamic>)
      .map((e) => Holding.fromJson(e as Map<String, dynamic>))
      .toList(),
  recentTransactions: (json['recentTransactions'] as List<dynamic>)
      .map((e) => PortfolioTransaction.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DashboardToJson(_Dashboard instance) => <String, dynamic>{
  'summary': instance.summary,
  'recentlyAdded': instance.recentlyAdded,
  'mostValuable': instance.mostValuable,
  'recentTransactions': instance.recentTransactions,
};

_HistoryPoint _$HistoryPointFromJson(Map<String, dynamic> json) => _HistoryPoint(
  date: const DateOnlyConverter().fromJson(json['date'] as String),
  marketValue: const DecimalConverter().fromJson(json['marketValue'] as Object),
  costBasis: const DecimalConverter().fromJson(json['costBasis'] as Object),
  copies: (json['copies'] as num).toInt(),
  unpricedCopies: (json['unpricedCopies'] as num).toInt(),
);

Map<String, dynamic> _$HistoryPointToJson(_HistoryPoint instance) => <String, dynamic>{
  'date': const DateOnlyConverter().toJson(instance.date),
  'marketValue': const DecimalConverter().toJson(instance.marketValue),
  'costBasis': const DecimalConverter().toJson(instance.costBasis),
  'copies': instance.copies,
  'unpricedCopies': instance.unpricedCopies,
};

_PortfolioHistory _$PortfolioHistoryFromJson(Map<String, dynamic> json) => _PortfolioHistory(
  currency: json['currency'] as String,
  sampleData: json['sampleData'] as bool,
  methodology: json['methodology'] as String,
  points: (json['points'] as List<dynamic>).map((e) => HistoryPoint.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$PortfolioHistoryToJson(_PortfolioHistory instance) => <String, dynamic>{
  'currency': instance.currency,
  'sampleData': instance.sampleData,
  'methodology': instance.methodology,
  'points': instance.points,
};

_PricePoint _$PricePointFromJson(Map<String, dynamic> json) => _PricePoint(
  observedAt: DateTime.parse(json['observedAt'] as String),
  market: const DecimalConverter().fromJson(json['market'] as Object),
  low: const NullableDecimalConverter().fromJson(json['low']),
  high: const NullableDecimalConverter().fromJson(json['high']),
  source: json['source'] as String,
  sampleData: json['sampleData'] as bool,
);

Map<String, dynamic> _$PricePointToJson(_PricePoint instance) => <String, dynamic>{
  'observedAt': instance.observedAt.toIso8601String(),
  'market': const DecimalConverter().toJson(instance.market),
  'low': const NullableDecimalConverter().toJson(instance.low),
  'high': const NullableDecimalConverter().toJson(instance.high),
  'source': instance.source,
  'sampleData': instance.sampleData,
};

_PriceHistory _$PriceHistoryFromJson(Map<String, dynamic> json) => _PriceHistory(
  cardId: json['cardId'] as String,
  currency: json['currency'] as String,
  points: (json['points'] as List<dynamic>).map((e) => PricePoint.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$PriceHistoryToJson(_PriceHistory instance) => <String, dynamic>{
  'cardId': instance.cardId,
  'currency': instance.currency,
  'points': instance.points,
};

_CardRef _$CardRefFromJson(Map<String, dynamic> json) => _CardRef(
  id: json['id'] as String,
  name: json['name'] as String,
  number: json['number'] as String,
  setName: json['setName'] as String,
  rarity: json['rarity'] as String?,
);

Map<String, dynamic> _$CardRefToJson(_CardRef instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'number': instance.number,
  'setName': instance.setName,
  'rarity': instance.rarity,
};

_TransactionLine _$TransactionLineFromJson(Map<String, dynamic> json) => _TransactionLine(
  holdingId: json['holdingId'] as String,
  direction: $enumDecode(_$LineDirectionEnumMap, json['direction']),
  allocatedAmount: const NullableDecimalConverter().fromJson(json['allocatedAmount']),
  card: CardRef.fromJson(json['card'] as Map<String, dynamic>),
  condition: $enumDecode(_$CardConditionEnumMap, json['condition']),
  language: $enumDecode(_$CardLanguageEnumMap, json['language']),
  variant: $enumDecode(_$CardVariantEnumMap, json['variant']),
  purchasePrice: const NullableDecimalConverter().fromJson(json['purchasePrice']),
);

Map<String, dynamic> _$TransactionLineToJson(_TransactionLine instance) => <String, dynamic>{
  'holdingId': instance.holdingId,
  'direction': _$LineDirectionEnumMap[instance.direction]!,
  'allocatedAmount': const NullableDecimalConverter().toJson(instance.allocatedAmount),
  'card': instance.card,
  'condition': _$CardConditionEnumMap[instance.condition]!,
  'language': _$CardLanguageEnumMap[instance.language]!,
  'variant': _$CardVariantEnumMap[instance.variant]!,
  'purchasePrice': const NullableDecimalConverter().toJson(instance.purchasePrice),
};

const _$LineDirectionEnumMap = {LineDirection.incoming: 'IN', LineDirection.outgoing: 'OUT'};

_PortfolioTransaction _$PortfolioTransactionFromJson(Map<String, dynamic> json) => _PortfolioTransaction(
  id: json['id'] as String,
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  occurredOn: const DateOnlyConverter().fromJson(json['occurredOn'] as String),
  currency: json['currency'] as String,
  cashIn: const NullableDecimalConverter().fromJson(json['cashIn']),
  cashOut: const NullableDecimalConverter().fromJson(json['cashOut']),
  fees: const NullableDecimalConverter().fromJson(json['fees']),
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lines: (json['lines'] as List<dynamic>).map((e) => TransactionLine.fromJson(e as Map<String, dynamic>)).toList(),
  realizedGain: const NullableDecimalConverter().fromJson(json['realizedGain']),
);

Map<String, dynamic> _$PortfolioTransactionToJson(_PortfolioTransaction instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'occurredOn': const DateOnlyConverter().toJson(instance.occurredOn),
  'currency': instance.currency,
  'cashIn': const NullableDecimalConverter().toJson(instance.cashIn),
  'cashOut': const NullableDecimalConverter().toJson(instance.cashOut),
  'fees': const NullableDecimalConverter().toJson(instance.fees),
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'lines': instance.lines,
  'realizedGain': const NullableDecimalConverter().toJson(instance.realizedGain),
};

const _$TransactionTypeEnumMap = {
  TransactionType.purchase: 'PURCHASE',
  TransactionType.sale: 'SALE',
  TransactionType.gift: 'GIFT',
  TransactionType.trade: 'TRADE',
  TransactionType.correction: 'CORRECTION',
};

_CatalogFilters _$CatalogFiltersFromJson(Map<String, dynamic> json) => _CatalogFilters(
  sets: (json['sets'] as List<dynamic>).map((e) => CardSet.fromJson(e as Map<String, dynamic>)).toList(),
  rarities: (json['rarities'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$CatalogFiltersToJson(_CatalogFilters instance) => <String, dynamic>{
  'sets': instance.sets,
  'rarities': instance.rarities,
};
