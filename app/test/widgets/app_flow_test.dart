import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pokefolio/app.dart';
import 'package:pokefolio/data/mock/mock_backend.dart';
import 'package:pokefolio/data/providers.dart';

Future<void> _pumpApp(WidgetTester tester, MockBackend backend, {Size size = const Size(1280, 900)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [useMockDataProvider.overrideWithValue(true), mockBackendProvider.overrideWithValue(backend)],
      child: const PokeFolioApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _login(WidgetTester tester, String email, String password) async {
  await tester.enterText(find.byKey(const Key('login-email')), email);
  await tester.enterText(find.byKey(const Key('login-password')), password);
  await tester.tap(find.byKey(const Key('login-submit')));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('nl_NL'));

  testWidgets('login screen shows PokeFolio branding and validates input', (tester) async {
    await _pumpApp(tester, MockBackend());
    expect(find.text('Welkom terug'), findsOneWidget);
    expect(find.bySemanticsLabel('PokeFolio'), findsWidgets);

    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pump();
    expect(find.text('Vul je e-mailadres in'), findsOneWidget);
  });

  testWidgets('wrong password shows an error', (tester) async {
    await _pumpApp(tester, MockBackend());
    await _login(tester, MockBackend.demoEmail, 'wrong-password');
    expect(find.text('Onjuist e-mailadres of wachtwoord.'), findsOneWidget);
  });

  testWidgets('demo user sees the dashboard with portfolio value and sample-data warning', (tester) async {
    await _pumpApp(tester, MockBackend());
    await _login(tester, MockBackend.demoEmail, MockBackend.demoPassword);

    expect(find.text('Actuele portfoliowaarde'), findsOneWidget);
    expect(find.byKey(const Key('portfolio-value')), findsOneWidget);
    expect(find.textContaining('voorbeeldgegevens'), findsWidgets);
    expect(find.text('Waardevolste kaarten'), findsOneWidget);
  });

  testWidgets('new user can search a card and add copies to the collection', (tester) async {
    final backend = MockBackend(seedDemoData: false);
    await _pumpApp(tester, backend);
    await tester.tap(find.text('Registreren'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('register-name')), 'Misty');
    await tester.enterText(find.byKey(const Key('register-email')), 'misty@example.com');
    await tester.enterText(find.byKey(const Key('register-password')), 'starmie-forever');
    await tester.enterText(find.byKey(const Key('register-confirm')), 'starmie-forever');
    await tester.tap(find.byKey(const Key('register-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Welkom bij PokeFolio'), findsOneWidget);

    await tester.tap(find.text('Kaarten zoeken').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('card-search-field')), 'Umbreon VMAX');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Umbreon VMAX').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aan collectie toevoegen'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Meer'));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.byKey(const Key('holding-save')));
    await tester.pumpAndSettle();

    expect(backend.summary().copies, 2);
    expect(find.text('Jouw exemplaren'), findsOneWidget);
  });

  for (final (name, size) in [('phone', Size(390, 844)), ('tablet', Size(900, 1100)), ('desktop', Size(1440, 900))]) {
    testWidgets('all main screens render without layout errors on $name', (tester) async {
      await _pumpApp(tester, MockBackend(), size: size);
      await _login(tester, MockBackend.demoEmail, MockBackend.demoPassword);
      for (final tab in ['Collectie', 'Zoeken', 'Analyse', 'Transacties', 'Profiel', 'Dashboard']) {
        final destination = find.text(tab);
        if (destination.evaluate().isEmpty) {
          // phone bar only labels the selected destination; tap by icon position instead
          await tester.tap(find.byTooltip(tab).first);
        } else {
          await tester.tap(destination.last);
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$tab on $name');
      }
      // card detail, add form, sale and trade screens
      await tester.tap(
        find.text('Zoeken').evaluate().isEmpty ? find.byTooltip('Zoeken').first : find.text('Zoeken').last,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, 'Charizard').first);
      await tester.pumpAndSettle();
      expect(find.text('Prijsontwikkeling'), findsOneWidget);
      await tester.tap(find.text('Aan collectie toevoegen'));
      await tester.pumpAndSettle();
      expect(find.text('Conditie'), findsOneWidget);
      expect(tester.takeException(), isNull);
      // sale and trade forms
      for (final (action, title) in [('Verkoop', 'Verkoop registreren'), ('Ruil', 'Ruil registreren')]) {
        final router = GoRouter.of(tester.element(find.text('Conditie')));
        router.go('/transactions');
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(TextButton, action));
        await tester.pumpAndSettle();
        expect(find.text(title), findsOneWidget);
        expect(tester.takeException(), isNull, reason: '$title on $name');
        router.go('/cards/card-base1-4/add');
        await tester.pumpAndSettle();
      }
    });
  }
}
