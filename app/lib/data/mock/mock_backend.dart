import 'dart:math' as math;

import 'package:decimal/decimal.dart';

import '../../core/network/api_exception.dart';
import '../../domain/enums.dart';
import '../../domain/inputs.dart';
import '../../domain/models.dart';
import '../../domain/portfolio_math.dart';
import '../repositories.dart';
import 'mock_catalog.dart';

class _MockUser {
  _MockUser(this.id, this.email, this.password, this.displayName, this.createdAt);

  final String id;
  final String email;
  String password;
  String displayName;
  final DateTime createdAt;
}

class _MockHolding {
  _MockHolding({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.attributes,
    required this.acquiredOn,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String cardId;
  HoldingInput attributes;
  DateTime acquiredOn;
  HoldingStatus status = HoldingStatus.active;
  DateTime? disposedOn;
  final DateTime createdAt;
}

class _MockLine {
  const _MockLine(this.holdingId, this.direction, this.amount);

  final String holdingId;
  final LineDirection direction;
  final Decimal? amount;
}

class _MockTransaction {
  _MockTransaction(
    this.id,
    this.userId,
    this.type,
    this.date,
    this.createdAt, {
    this.cashIn,
    this.cashOut,
    this.fees,
    this.notes,
  });

  final String id;
  final String userId;
  final TransactionType type;
  final DateTime date;
  final DateTime createdAt;
  final Decimal? cashIn;
  final Decimal? cashOut;
  final Decimal? fees;
  final String? notes;
  final lines = <_MockLine>[];
}

/// In-memory stand-in for the PokeFolio backend so the app runs fully offline with sample data.
/// Business rules mirror the backend: per-user isolation, atomic trades, unknown prices never valued at zero.
class MockBackend {
  MockBackend({DateTime Function()? clock, bool seedDemoData = true}) : _clock = clock ?? DateTime.now {
    if (seedDemoData) _seedDemo();
  }

  static const demoEmail = 'demo@pokefolio.app';
  static const demoPassword = 'pokefolio-demo';

  final DateTime Function() _clock;
  final _random = math.Random();
  final _users = <String, _MockUser>{};
  final _holdings = <String, _MockHolding>{};
  final _transactions = <String, _MockTransaction>{};
  final _resetTokens = <String, String>{};
  String? currentUserId;
  String? lastResetToken;

  DateTime get _today {
    final now = _clock();
    return DateTime(now.year, now.month, now.day);
  }

  String _id(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(1 << 32).toRadixString(16)}';

  // ---------------------------------------------------------------- auth

  Account _account(_MockUser u) =>
      Account(id: u.id, email: u.email, displayName: u.displayName, preferredCurrency: 'EUR', createdAt: u.createdAt);

  AuthSession _session(_MockUser u) {
    currentUserId = u.id;
    return AuthSession(
      accessToken: 'mock-${u.id}',
      refreshToken: 'mock-refresh',
      expiresInSeconds: 900,
      account: _account(u),
    );
  }

  AuthSession register(String email, String password, String displayName) {
    final normalized = email.trim().toLowerCase();
    if (_users.values.any((u) => u.email == normalized)) {
      throw const ApiException('Er bestaat al een account met dit e-mailadres.', statusCode: 409);
    }
    if (password.length < 10) {
      throw const ApiException(
        'Controleer de ingevulde gegevens.',
        statusCode: 400,
        fieldErrors: {'password': 'must be between 10 and 128 characters'},
      );
    }
    final user = _MockUser(_id('user'), normalized, password, displayName.trim(), _clock());
    _users[user.id] = user;
    return _session(user);
  }

  AuthSession login(String email, String password) {
    final normalized = email.trim().toLowerCase();
    final user = _users.values.where((u) => u.email == normalized && u.password == password).firstOrNull;
    if (user == null) throw const ApiException('Onjuist e-mailadres of wachtwoord.', statusCode: 401);
    return _session(user);
  }

  void logout() => currentUserId = null;

  _MockUser get _user {
    final user = _users[currentUserId];
    if (user == null) throw const ApiException('Je sessie is verlopen. Log opnieuw in.', statusCode: 401);
    return user;
  }

  Account account() => _account(_user);

  void requestPasswordReset(String email) {
    final user = _users.values.where((u) => u.email == email.trim().toLowerCase()).firstOrNull;
    if (user == null) return;
    final token = 'reset-${_random.nextInt(1 << 32)}';
    _resetTokens[token] = user.id;
    lastResetToken = token;
  }

  void resetPassword(String token, String newPassword) {
    final userId = _resetTokens.remove(token);
    if (userId == null) throw const ApiException('Ongeldige of verlopen herstelcode.', statusCode: 401);
    _users[userId]!.password = newPassword;
  }

  Account updateAccount(String? displayName) {
    if (displayName != null && displayName.trim().isNotEmpty) _user.displayName = displayName.trim();
    return account();
  }

  void changePassword(String current, String next) {
    if (_user.password != current) throw const ApiException('Huidig wachtwoord is onjuist.', statusCode: 401);
    _user.password = next;
  }

  void deleteAccount(String password) {
    final user = _user;
    if (user.password != password) throw const ApiException('Wachtwoord is onjuist.', statusCode: 401);
    _holdings.removeWhere((_, h) => h.userId == user.id);
    _transactions.removeWhere((_, t) => t.userId == user.id);
    _users.remove(user.id);
    currentUserId = null;
  }

  // ---------------------------------------------------------------- catalog & prices

  PriceInfo priceInfo(String externalId) {
    final today = _today;
    for (var back = 0; back <= 30; back++) {
      final day = today.subtract(Duration(days: back));
      final price = MockCatalog.priceOn(externalId, day, today);
      if (price != null) {
        final observed = DateTime.utc(day.year, day.month, day.day, 12);
        return PriceInfo(
          status: PriceStatus.available,
          market: price,
          low: (price * Decimal.parse('0.85')).round(scale: 2),
          high: (price * Decimal.parse('1.20')).round(scale: 2),
          currency: 'EUR',
          source: MockCatalog.source,
          observedAt: observed,
          stale: _clock().difference(observed) > const Duration(hours: 48),
          sampleData: true,
        );
      }
    }
    return const PriceInfo(status: PriceStatus.unknown, currency: 'EUR');
  }

  PokemonCard card(String id) {
    final card = MockCatalog.cards.where((c) => c.id == id).firstOrNull;
    if (card == null) throw const ApiException('Niet gevonden.', statusCode: 404);
    return card.copyWith(price: priceInfo(card.externalId));
  }

  PageResult<PokemonCard> searchCards(String? query, String? setId, String? rarity, CardSort sort, int page, int size) {
    final q = query?.trim().toLowerCase();
    final matches = MockCatalog.cards.where((c) {
      if (setId != null && c.set.id != setId) return false;
      if (rarity != null && c.rarity != rarity) return false;
      if (q == null || q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) || c.set.name.toLowerCase().contains(q) || c.number.toLowerCase() == q;
    }).toList();
    matches.sort(switch (sort) {
      CardSort.name => (a, b) => a.name.compareTo(b.name),
      CardSort.number => (a, b) => a.number.compareTo(b.number),
      CardSort.newest => (a, b) => b.set.releaseDate!.compareTo(a.set.releaseDate!),
    });
    return _page(matches.map((c) => c.copyWith(price: priceInfo(c.externalId))).toList(), page, size);
  }

  CatalogFilters filters() => CatalogFilters(
    sets: [...MockCatalog.sets]..sort((a, b) => b.releaseDate!.compareTo(a.releaseDate!)),
    rarities: MockCatalog.cards.map((c) => c.rarity!).toSet().toList()..sort(),
  );

  PriceHistory priceHistory(String cardId, int days) {
    final c = card(cardId);
    final today = _today;
    final points = <PricePoint>[];
    for (var i = days; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final price = MockCatalog.priceOn(c.externalId, day, today);
      if (price != null) {
        points.add(
          PricePoint(
            observedAt: DateTime.utc(day.year, day.month, day.day, 12),
            market: price,
            source: MockCatalog.source,
            sampleData: true,
          ),
        );
      }
    }
    return PriceHistory(cardId: cardId, currency: 'EUR', points: points);
  }

  // ---------------------------------------------------------------- holdings

  Holding _holding(_MockHolding h) {
    final c = card(h.cardId);
    final active = h.status == HoldingStatus.active;
    final market = active && c.price!.isAvailable ? c.price!.market : null;
    final cost = h.attributes.purchasePrice;
    return Holding(
      id: h.id,
      card: c,
      condition: h.attributes.condition,
      language: h.attributes.language,
      variant: h.attributes.variant,
      purchasePrice: cost,
      purchaseCurrency: 'EUR',
      purchaseDate: h.attributes.purchaseDate,
      acquiredOn: h.acquiredOn,
      notes: h.attributes.notes,
      status: h.status,
      disposedOn: h.disposedOn,
      marketValue: market,
      unrealizedGain: market != null && cost != null ? market - cost : null,
      createdAt: h.createdAt,
    );
  }

  Iterable<_MockHolding> _mine({HoldingStatus? status}) =>
      _holdings.values.where((h) => h.userId == _user.id && (status == null || h.status == status));

  Holding holding(String id) {
    final h = _holdings[id];
    if (h == null || h.userId != _user.id) throw const ApiException('Niet gevonden.', statusCode: 404);
    return _holding(h);
  }

  PageResult<Holding> holdings(HoldingStatus status, String? cardId, int page, int size) {
    final list = _mine(status: status).where((h) => cardId == null || h.cardId == cardId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _page(list.map(_holding).toList(), page, size);
  }

  List<Holding> addHoldings(String cardId, int quantity, HoldingInput input) {
    card(cardId);
    final userId = _user.id;
    final date = _dateOnly(input.purchaseDate ?? _today);
    final tx = _MockTransaction(
      _id('tx'),
      userId,
      TransactionType.purchase,
      date,
      _clock(),
      cashOut: input.purchasePrice == null ? null : input.purchasePrice! * Decimal.fromInt(quantity),
      notes: input.notes,
    );
    final created = <Holding>[];
    for (var i = 0; i < quantity; i++) {
      final h = _MockHolding(
        id: _id('holding'),
        userId: userId,
        cardId: cardId,
        attributes: input,
        acquiredOn: date,
        createdAt: _clock(),
      );
      _holdings[h.id] = h;
      tx.lines.add(_MockLine(h.id, LineDirection.incoming, input.purchasePrice));
      created.add(_holding(h));
    }
    _transactions[tx.id] = tx;
    return created;
  }

  Holding updateHolding(String id, HoldingInput input) {
    final h = _holdings[id];
    if (h == null || h.userId != _user.id) throw const ApiException('Niet gevonden.', statusCode: 404);
    if (h.status != HoldingStatus.active) {
      throw const ApiException('Alleen exemplaren in je collectie kunnen worden bewerkt.', statusCode: 409);
    }
    h.attributes = input;
    return _holding(h);
  }

  PageResult<CollectionEntry> collection(String? query, CollectionSort sort, int page, int size) {
    final byCard = <String, List<Holding>>{};
    for (final h in _mine(status: HoldingStatus.active)) {
      byCard.putIfAbsent(h.cardId, () => []).add(_holding(h));
    }
    final q = query?.trim().toLowerCase();
    final entries = <CollectionEntry>[];
    for (final copies in byCard.values) {
      final c = copies.first.card;
      if (q != null &&
          q.isNotEmpty &&
          !c.name.toLowerCase().contains(q) &&
          !c.set.name.toLowerCase().contains(q) &&
          c.number.toLowerCase() != q) {
        continue;
      }
      final totals = computeTotals(
        copies
            .map((h) => ValuedCopy(cardId: c.id, purchasePrice: h.purchasePrice, marketPrice: h.marketValue))
            .toList(),
      );
      copies.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      entries.add(
        CollectionEntry(
          card: c,
          copies: copies.length,
          marketValue: totals.pricedCopies == 0 ? null : totals.marketValue,
          costBasis: totals.costBasis,
          copiesWithoutCost: totals.copiesWithoutCost,
          unrealizedGain: totals.unrealizedGain,
          lastAddedAt: copies.first.createdAt,
          holdings: copies,
        ),
      );
    }
    int byName(CollectionEntry a, CollectionEntry b) => a.card.name.compareTo(b.card.name);
    int nullsLastDesc(Decimal? a, Decimal? b) => a == null ? (b == null ? 0 : 1) : (b == null ? -1 : b.compareTo(a));
    entries.sort(switch (sort) {
      CollectionSort.value => (a, b) => nullsLastDesc(a.marketValue, b.marketValue),
      CollectionSort.gain => (a, b) => nullsLastDesc(a.unrealizedGain, b.unrealizedGain),
      CollectionSort.name => byName,
      CollectionSort.recent => (a, b) => b.lastAddedAt!.compareTo(a.lastAddedAt!),
      CollectionSort.copies => (a, b) => b.copies.compareTo(a.copies),
    });
    return _page(entries, page, size);
  }

  // ---------------------------------------------------------------- portfolio

  PortfolioSummary summary() {
    final active = _mine(status: HoldingStatus.active).map(_holding).toList();
    final totals = computeTotals(
      active
          .map((h) => ValuedCopy(cardId: h.card.id, purchasePrice: h.purchasePrice, marketPrice: h.marketValue))
          .toList(),
    );
    final prices = active.map((h) => h.card.price!).where((p) => p.isAvailable).toList();
    final stale = active.where((h) => h.card.price!.isAvailable && h.card.price!.stale).length;
    Decimal? realized;
    for (final tx in _transactions.values.where((t) => t.userId == _user.id && t.type == TransactionType.sale)) {
      for (final line in tx.lines) {
        final cost = _holdings[line.holdingId]?.attributes.purchasePrice;
        if (cost != null && line.amount != null) realized = (realized ?? Decimal.zero) + line.amount! - cost;
      }
    }
    final observed = prices.map((p) => p.observedAt!).toList()..sort();
    return PortfolioSummary(
      currency: 'EUR',
      marketValue: totals.marketValue,
      costBasis: totals.costBasis,
      unrealizedGain: totals.unrealizedGain,
      unrealizedGainPercent: totals.unrealizedGainPercent,
      realizedGain: realized,
      distinctCards: totals.distinctCards,
      copies: totals.copies,
      pricedCopies: totals.pricedCopies,
      unpricedCopies: totals.unpricedCopies,
      copiesWithoutCost: totals.copiesWithoutCost,
      stalePricedCopies: stale,
      priceSources: prices.isEmpty ? const [] : const [MockCatalog.source],
      sampleData: prices.isNotEmpty,
      oldestPriceAt: observed.firstOrNull,
      latestPriceAt: observed.lastOrNull,
      warnings: [
        if (prices.isNotEmpty) 'SAMPLE_PRICES',
        if (totals.unpricedCopies > 0) 'UNPRICED_COPIES',
        if (stale > 0) 'STALE_PRICES',
        if (totals.copiesWithoutCost > 0) 'MISSING_PURCHASE_PRICES',
      ],
    );
  }

  Dashboard dashboard() {
    final active = _mine(status: HoldingStatus.active).map(_holding).toList();
    final recent = [...active]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final valuable = active.where((h) => h.marketValue != null).toList()
      ..sort((a, b) => b.marketValue!.compareTo(a.marketValue!));
    return Dashboard(
      summary: summary(),
      recentlyAdded: recent.take(5).toList(),
      mostValuable: valuable.take(5).toList(),
      recentTransactions: transactions(null, 0, 5).content,
    );
  }

  PortfolioHistory history(int days) {
    final today = _today;
    final mine = _mine().toList();
    final points = <HistoryPoint>[];
    for (var i = days - 1; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      var value = Decimal.zero;
      var cost = Decimal.zero;
      var copies = 0;
      var unpriced = 0;
      for (final h in mine) {
        final held = !h.acquiredOn.isAfter(day) && (h.disposedOn == null || h.disposedOn!.isAfter(day));
        if (!held) continue;
        copies++;
        final externalId = MockCatalog.cards.firstWhere((c) => c.id == h.cardId).externalId;
        Decimal? price;
        for (var back = 0; back <= 30 && price == null; back++) {
          price = MockCatalog.priceOn(externalId, day.subtract(Duration(days: back)), today);
        }
        if (price == null) {
          unpriced++;
        } else {
          value += price;
        }
        if (h.attributes.purchasePrice != null) cost += h.attributes.purchasePrice!;
      }
      points.add(
        HistoryPoint(date: day, marketValue: value, costBasis: cost, copies: copies, unpricedCopies: unpriced),
      );
    }
    return PortfolioHistory(
      currency: 'EUR',
      sampleData: true,
      methodology:
          'Per dag worden de exemplaren geteld die je aan het eind van die dag bezat, gewaardeerd tegen '
          'de laatst bekende marktprijs op of vóór die dag. Exemplaren zonder prijs tellen niet mee in de waarde.',
      points: points,
    );
  }

  // ---------------------------------------------------------------- transactions

  PortfolioTransaction _transaction(_MockTransaction tx) {
    Decimal? realized;
    final lines = tx.lines.map((l) {
      final h = _holdings[l.holdingId]!;
      final c = MockCatalog.cards.firstWhere((c) => c.id == h.cardId);
      final cost = h.attributes.purchasePrice;
      if (tx.type == TransactionType.sale && cost != null && l.amount != null) {
        realized = (realized ?? Decimal.zero) + l.amount! - cost;
      }
      return TransactionLine(
        holdingId: h.id,
        direction: l.direction,
        allocatedAmount: l.amount,
        card: CardRef(id: c.id, name: c.name, number: c.number, setName: c.set.name, rarity: c.rarity),
        condition: h.attributes.condition,
        language: h.attributes.language,
        variant: h.attributes.variant,
        purchasePrice: cost,
      );
    }).toList()..sort((a, b) => b.direction.index.compareTo(a.direction.index));
    return PortfolioTransaction(
      id: tx.id,
      type: tx.type,
      occurredOn: tx.date,
      currency: 'EUR',
      cashIn: tx.cashIn,
      cashOut: tx.cashOut,
      fees: tx.fees,
      notes: tx.notes,
      createdAt: tx.createdAt,
      lines: lines,
      realizedGain: realized,
    );
  }

  PageResult<PortfolioTransaction> transactions(TransactionType? type, int page, int size) {
    final list = _transactions.values.where((t) => t.userId == _user.id && (type == null || t.type == type)).toList()
      ..sort((a, b) {
        final byDate = b.date.compareTo(a.date);
        return byDate != 0 ? byDate : b.createdAt.compareTo(a.createdAt);
      });
    return _page(list.map(_transaction).toList(), page, size);
  }

  PortfolioTransaction transaction(String id) {
    final tx = _transactions[id];
    if (tx == null || tx.userId != _user.id) throw const ApiException('Niet gevonden.', statusCode: 404);
    return _transaction(tx);
  }

  /// Validates every selected copy before anything changes, so a failing request never applies partially.
  List<_MockHolding> _activeCopies(List<String> ids, DateTime dateTime) {
    final date = _dateOnly(dateTime);
    if (ids.toSet().length != ids.length) {
      throw const ApiException('Hetzelfde exemplaar is meerdere keren geselecteerd.', statusCode: 400);
    }
    if (date.isAfter(_today)) throw const ApiException('De datum mag niet in de toekomst liggen.', statusCode: 400);
    return ids.map((id) {
      final h = _holdings[id];
      if (h == null || h.userId != _user.id) throw const ApiException('Niet gevonden.', statusCode: 404);
      if (h.status != HoldingStatus.active) {
        throw const ApiException('Een geselecteerd exemplaar zit niet meer in je collectie.', statusCode: 409);
      }
      if (date.isBefore(h.acquiredOn)) {
        throw const ApiException('De datum ligt vóór de aankoopdatum van een exemplaar.', statusCode: 400);
      }
      return h;
    }).toList();
  }

  PortfolioTransaction sell(SaleInput input) {
    final copies = _activeCopies(input.holdingIds, input.date);
    final tx = _MockTransaction(
      _id('tx'),
      _user.id,
      TransactionType.sale,
      input.date,
      _clock(),
      cashIn: input.proceeds,
      fees: input.fees,
      notes: input.notes,
    );
    final shares = allocate(input.proceeds - (input.fees ?? Decimal.zero), copies.length);
    for (var i = 0; i < copies.length; i++) {
      copies[i]
        ..status = HoldingStatus.sold
        ..disposedOn = _dateOnly(input.date);
      tx.lines.add(_MockLine(copies[i].id, LineDirection.outgoing, shares[i]));
    }
    _transactions[tx.id] = tx;
    return _transaction(tx);
  }

  PortfolioTransaction gift(GiftInput input, {bool correction = false}) {
    final copies = _activeCopies(input.holdingIds, input.date);
    final tx = _MockTransaction(
      _id('tx'),
      _user.id,
      correction ? TransactionType.correction : TransactionType.gift,
      input.date,
      _clock(),
      notes: input.notes,
    );
    for (final h in copies) {
      h
        ..status = correction ? HoldingStatus.removed : HoldingStatus.givenAway
        ..disposedOn = _dateOnly(input.date);
      tx.lines.add(_MockLine(h.id, LineDirection.outgoing, null));
    }
    _transactions[tx.id] = tx;
    return _transaction(tx);
  }

  PortfolioTransaction trade(TradeInput input) {
    if ((input.cashReceived ?? Decimal.zero) > Decimal.zero && (input.cashPaid ?? Decimal.zero) > Decimal.zero) {
      throw const ApiException('Kies bijbetaling ontvangen óf betaald, niet beide.', statusCode: 400);
    }
    final given = _activeCopies(input.givenHoldingIds, input.date);
    for (final r in input.received) {
      card(r.cardId); // validate before changing anything
    }
    final userId = _user.id;
    final tx = _MockTransaction(
      _id('tx'),
      userId,
      TransactionType.trade,
      input.date,
      _clock(),
      cashIn: input.cashReceived,
      cashOut: input.cashPaid,
      notes: input.notes,
    );
    for (final h in given) {
      h
        ..status = HoldingStatus.tradedAway
        ..disposedOn = _dateOnly(input.date);
      tx.lines.add(_MockLine(h.id, LineDirection.outgoing, null));
    }
    for (final r in input.received) {
      for (var i = 0; i < r.quantity; i++) {
        final h = _MockHolding(
          id: _id('holding'),
          userId: userId,
          cardId: r.cardId,
          attributes: HoldingInput(
            condition: r.condition,
            language: r.language,
            variant: r.variant,
            purchasePrice: r.value,
            purchaseDate: input.date,
            notes: r.notes,
          ),
          acquiredOn: _dateOnly(input.date),
          createdAt: _clock(),
        );
        _holdings[h.id] = h;
        tx.lines.add(_MockLine(h.id, LineDirection.incoming, r.value));
      }
    }
    _transactions[tx.id] = tx;
    return _transaction(tx);
  }

  // ---------------------------------------------------------------- helpers

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  PageResult<T> _page<T>(List<T> all, int page, int size) {
    final from = math.min(page * size, all.length);
    final to = math.min(from + size, all.length);
    return PageResult(
      content: all.sublist(from, to),
      page: page,
      size: size,
      totalElements: all.length,
      totalPages: size == 0 ? 0 : (all.length / size).ceil(),
    );
  }

  void _seedDemo() {
    register(demoEmail, demoPassword, 'Demo Trainer');
    final today = _today;
    HoldingInput attrs(
      CardCondition c,
      CardVariant v,
      String? price,
      int daysAgo, [
      CardLanguage l = CardLanguage.en,
    ]) => HoldingInput(
      condition: c,
      language: l,
      variant: v,
      purchasePrice: price == null ? null : Decimal.parse(price),
      purchaseDate: today.subtract(Duration(days: daysAgo)),
    );
    addHoldings('card-base1-4', 1, attrs(CardCondition.excellent, CardVariant.unlimited, '350.00', 300));
    addHoldings('card-swsh7-215', 1, attrs(CardCondition.nearMint, CardVariant.holo, '980.00', 210));
    addHoldings('card-sv3pt5-199', 2, attrs(CardCondition.mint, CardVariant.holo, '110.00', 120));
    addHoldings('card-sv3pt5-025', 4, attrs(CardCondition.nearMint, CardVariant.normal, '0.50', 90));
    addHoldings('card-neo2-13', 1, attrs(CardCondition.good, CardVariant.holo, '60.00', 80));
    addHoldings('card-sv8pt5-161', 1, attrs(CardCondition.mint, CardVariant.holo, null, 40, CardLanguage.ja));
    addHoldings('card-swsh8-271', 1, attrs(CardCondition.nearMint, CardVariant.holo, '300.00', 60));
    final pikachus = holdings(HoldingStatus.active, 'card-sv3pt5-025', 0, 10).content;
    sell(
      SaleInput(
        holdingIds: [pikachus.first.id],
        date: today.subtract(const Duration(days: 20)),
        proceeds: Decimal.parse('1.50'),
        fees: Decimal.parse('0.20'),
        notes: 'Cardmarket',
      ),
    );
    logout();
  }
}
