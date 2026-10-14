import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/widgets/app_shell.dart';
import 'core/widgets/brand.dart';
import 'features/analysis/portfolio_analysis_screen.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/catalog/card_detail_screen.dart';
import 'features/catalog/card_search_screen.dart';
import 'features/collection/collection_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/holdings/holding_form_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/transactions/sale_screen.dart';
import 'features/transactions/trade_screen.dart';
import 'features/transactions/transaction_history_screen.dart';

const _publicRoutes = {'/login', '/register', '/forgot-password'};

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ValueNotifier<AsyncValue<Object?>>(const AsyncLoading());
  ref.listen(authControllerProvider, (_, next) => authState.value = next, fireImmediately: true);
  ref.onDispose(authState.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authState,
    redirect: (context, state) {
      final auth = authState.value;
      final path = state.matchedLocation;
      if (auth.isLoading && !auth.hasValue) return path == '/splash' ? null : '/splash';
      final signedIn = auth.value != null;
      final isPublic = _publicRoutes.contains(path);
      if (!signedIn) return isPublic ? null : '/login';
      if (isPublic || path == '/splash') return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const _SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(path: '/forgot-password', builder: (_, _) => const ForgotPasswordScreen()),
      ShellRoute(
        builder: (context, state, child) => AppShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (_, _) => const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: '/collection',
            pageBuilder: (_, _) => const NoTransitionPage(child: CollectionScreen()),
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (_, _) => const NoTransitionPage(child: CardSearchScreen()),
          ),
          GoRoute(
            path: '/analysis',
            pageBuilder: (_, _) => const NoTransitionPage(child: PortfolioAnalysisScreen()),
          ),
          GoRoute(
            path: '/transactions',
            pageBuilder: (_, _) => const NoTransitionPage(child: TransactionHistoryScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (_, _) => const NoTransitionPage(child: ProfileScreen()),
          ),
          GoRoute(
            path: '/cards/:id',
            builder: (_, state) => CardDetailScreen(cardId: state.pathParameters['id']!),
            routes: [
              GoRoute(
                path: 'add',
                builder: (_, state) => HoldingFormScreen(cardId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/holdings/:id/edit',
            builder: (_, state) => HoldingFormScreen(holdingId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/sell',
            builder: (_, state) => SaleScreen(
              preselected: _ids(state.uri.queryParameters['holdings']),
              mode: SaleMode.values.byName(state.uri.queryParameters['mode'] ?? 'sale'),
            ),
          ),
          GoRoute(
            path: '/trade',
            builder: (_, state) => TradeScreen(preselected: _ids(state.uri.queryParameters['holdings'])),
          ),
        ],
      ),
    ],
    debugLogDiagnostics: kDebugMode,
  );
});

List<String> _ids(String? csv) => csv == null || csv.isEmpty ? const [] : csv.split(',');

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: PokeFolioWordmark(fontSize: 32)));
}
