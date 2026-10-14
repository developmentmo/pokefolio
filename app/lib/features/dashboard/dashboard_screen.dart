import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/charts.dart';
import '../../core/widgets/money.dart';
import '../../core/widgets/states.dart';
import '../../data/queries.dart';
import '../../domain/models.dart';
import '../auth/auth_controller.dart';
import '../common/holding_tiles.dart';
import '../transactions/transaction_details.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    final name = ref.watch(authControllerProvider).value?.displayName;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidatePortfolio(),
        child: AsyncView(
          value: dashboard,
          onRetry: () => ref.invalidate(dashboardProvider),
          data: (d) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              PageBody(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        if (MediaQuery.sizeOf(context).width < 700) ...[
                          const Expanded(
                            child: Align(alignment: Alignment.centerLeft, child: PokeFolioWordmark(fontSize: 20)),
                          ),
                          IconButton.filledTonal(
                            tooltip: 'Kaart toevoegen',
                            onPressed: () => context.go('/search'),
                            icon: const Icon(Icons.add),
                          ),
                        ] else ...[
                          Expanded(
                            child: Text(
                              name == null ? 'Dashboard' : 'Hoi $name',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => context.go('/search'),
                            icon: const Icon(Icons.add),
                            label: const Text('Kaart toevoegen'),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (d.summary.isEmpty) _EmptyDashboard() else _DashboardContent(dashboard: d),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: EmptyView(
        icon: Icons.style_outlined,
        title: 'Welkom bij PokeFolio',
        message:
            'Je collectie is nog leeg. Zoek een kaart en voeg je eerste exemplaar toe om je portfoliowaarde '
            'te volgen.',
        action: FilledButton.icon(
          onPressed: () => context.go('/search'),
          icon: const Icon(Icons.search),
          label: const Text('Kaarten zoeken'),
        ),
      ),
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  const _DashboardContent({required this.dashboard});

  final Dashboard dashboard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = dashboard.summary;
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final history = ref.watch(portfolioHistoryProvider(30));
    final hero = _HeroValue(summary: s, history: history);
    final stats = _StatGrid(summary: s);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (s.warnings.isNotEmpty) ...[_Warnings(summary: s), const SizedBox(height: 16)],
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: hero),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: stats),
            ],
          )
        else ...[
          hero,
          const SizedBox(height: 16),
          stats,
        ],
        LayoutBuilder(
          builder: (context, c) {
            final lists = [
              _ListCard(
                title: 'Waardevolste kaarten',
                empty: 'Nog geen kaarten met een bekende prijs.',
                children: [for (final h in dashboard.mostValuable) HoldingTile(holding: h)],
              ),
              _ListCard(
                title: 'Recent toegevoegd',
                empty: 'Nog niets toegevoegd.',
                children: [for (final h in dashboard.recentlyAdded) HoldingTile(holding: h)],
              ),
              _ListCard(
                title: 'Recente transacties',
                empty: 'Nog geen transacties.',
                action: TextButton(onPressed: () => context.go('/transactions'), child: const Text('Alles')),
                children: [
                  for (final t in dashboard.recentTransactions)
                    TransactionTile(transaction: t, onTap: () => showTransactionDetails(context, t)),
                ],
              ),
            ];
            if (c.maxWidth >= 1000) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, l) in lists.indexed) ...[if (i > 0) const SizedBox(width: 16), Expanded(child: l)],
                ],
              );
            }
            return Column(children: lists);
          },
        ),
      ],
    );
  }
}

class _HeroValue extends StatelessWidget {
  const _HeroValue({required this.summary, required this.history});

  final PortfolioSummary summary;
  final AsyncValue<PortfolioHistory> history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actuele portfoliowaarde',
              style: theme.textTheme.labelLarge?.copyWith(color: PokeFolioColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Text(
              Fmt.money(summary.marketValue, currency: summary.currency),
              key: const Key('portfolio-value'),
              style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                GainText(
                  summary.unrealizedGain,
                  percent: summary.unrealizedGainPercent,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  'ongerealiseerd',
                  style: theme.textTheme.bodySmall?.copyWith(color: PokeFolioColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            history.when(
              data: (h) => TimeSeriesChart(
                compact: true,
                height: 120,
                series: [
                  ChartSeries(
                    label: 'Waarde',
                    color: PokeFolioColors.electric,
                    points: [for (final p in h.points) (p.date, p.marketValue)],
                  ),
                ],
              ),
              loading: () => const SizedBox(height: 120, child: LoadingView()),
              error: (e, _) => SizedBox(height: 120, child: Center(child: Text(e.toString()))),
            ),
            const SizedBox(height: 8),
            Text(
              'Laatste 30 dagen · Prijzen: ${summary.priceSources.isEmpty ? 'geen' : summary.priceSources.join(', ')}'
              '${summary.latestPriceAt != null ? ' · bijgewerkt ${Fmt.dateTime(summary.latestPriceAt)}' : ''}',
              style: theme.textTheme.bodySmall?.copyWith(color: PokeFolioColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.summary});

  final PortfolioSummary summary;

  @override
  Widget build(BuildContext context) {
    final s = summary;
    final tiles = [
      StatTile(
        label: 'Aankoopwaarde',
        icon: Icons.account_balance_wallet_outlined,
        value: Text(Fmt.money(s.costBasis, currency: s.currency)),
        footnote: s.copiesWithoutCost > 0 ? '${s.copiesWithoutCost} zonder aankoopprijs' : null,
      ),
      StatTile(
        label: 'Ongerealiseerd',
        icon: Icons.trending_up,
        value: GainText(s.unrealizedGain, currency: s.currency),
        footnote: s.unrealizedGainPercent == null ? null : Fmt.percent(s.unrealizedGainPercent),
      ),
      StatTile(
        label: 'Gerealiseerd',
        icon: Icons.sell_outlined,
        value: GainText(s.realizedGain, currency: s.currency),
        footnote: 'uit verkopen',
      ),
      StatTile(
        label: 'Kaarten / exemplaren',
        icon: Icons.style_outlined,
        value: Text('${s.distinctCards} / ${s.copies}'),
        footnote: s.unpricedCopies > 0 ? '${s.unpricedCopies} zonder prijs' : null,
      ),
    ];
    return TileGrid(minTileWidth: 170, children: tiles);
  }
}

class _Warnings extends StatelessWidget {
  const _Warnings({required this.summary});

  final PortfolioSummary summary;

  @override
  Widget build(BuildContext context) {
    final s = summary;
    final messages = <(IconData, Color, String)>[
      if (s.warnings.contains('SAMPLE_PRICES'))
        (
          Icons.science_outlined,
          PokeFolioColors.electric,
          'Prijzen zijn voorbeeldgegevens, geen actuele marktprijzen.',
        ),
      if (s.warnings.contains('UNPRICED_COPIES'))
        (
          Icons.help_outline,
          PokeFolioColors.textSecondary,
          '${s.unpricedCopies} ${s.unpricedCopies == 1 ? 'exemplaar heeft' : 'exemplaren hebben'} geen bekende prijs en ${s.unpricedCopies == 1 ? 'telt' : 'tellen'} niet mee in de waarde.',
        ),
      if (s.warnings.contains('STALE_PRICES'))
        (
          Icons.history,
          PokeFolioColors.warning,
          '${s.stalePricedCopies} ${s.stalePricedCopies == 1 ? 'exemplaar is' : 'exemplaren zijn'} gewaardeerd met een verouderde prijs (oudste: ${Fmt.date(s.oldestPriceAt)}).',
        ),
    ];
    return Column(
      children: [
        for (final m in messages)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: m.$2.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: m.$2.withValues(alpha: 0.4), width: 0.6),
              ),
              child: Row(
                children: [
                  Icon(m.$1, color: m.$2, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(m.$3, style: Theme.of(context).textTheme.bodySmall)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({required this.title, required this.children, required this.empty, this.action});

  final String title;
  final List<Widget> children;
  final String empty;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(title, trailing: action),
        Card(
          child: children.isEmpty
              ? Padding(padding: const EdgeInsets.all(20), child: Text(empty))
              : Column(children: children),
        ),
      ],
    );
  }
}
