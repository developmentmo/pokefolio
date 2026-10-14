import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/charts.dart';
import '../../core/widgets/money.dart';
import '../../core/widgets/states.dart';
import '../../data/queries.dart';
import '../../data/repositories.dart';
import '../../domain/models.dart';

class PortfolioAnalysisScreen extends ConsumerStatefulWidget {
  const PortfolioAnalysisScreen({super.key});

  @override
  ConsumerState<PortfolioAnalysisScreen> createState() => _PortfolioAnalysisScreenState();
}

class _PortfolioAnalysisScreenState extends ConsumerState<PortfolioAnalysisScreen> {
  int _days = 90;

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(portfolioHistoryProvider(_days));
    final dashboard = ref.watch(dashboardProvider);
    final collection = ref.watch(collectionProvider((query: '', sort: CollectionSort.gain)));
    return Scaffold(
      appBar: AppBar(title: const Text('Portfolioanalyse')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          PageBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                dashboard.when(
                  data: (d) => _Summary(summary: d.summary),
                  loading: () => const LoadingView(),
                  error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(dashboardProvider)),
                ),
                SectionTitle(
                  'Waardeontwikkeling',
                  trailing: RangeSelector(
                    value: _days,
                    options: const [30, 90, 180, 365],
                    onChanged: (d) => setState(() => _days = d),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AsyncView(
                      value: history,
                      onRetry: () => ref.invalidate(portfolioHistoryProvider(_days)),
                      data: (h) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (h.sampleData) ...[const SampleDataBanner(), const SizedBox(height: 16)],
                          TimeSeriesChart(
                            height: 280,
                            currency: h.currency,
                            series: [
                              ChartSeries(
                                label: 'Marktwaarde',
                                color: PokeFolioColors.electric,
                                points: [for (final p in h.points) (p.date, p.marketValue)],
                              ),
                              ChartSeries(
                                label: 'Aankoopwaarde',
                                color: PokeFolioColors.violet,
                                dashed: true,
                                points: [for (final p in h.points) (p.date, p.costBasis)],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _PeriodChange(points: h.points),
                          const SizedBox(height: 12),
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: const Text('Hoe wordt dit berekend?'),
                            children: [Text(h.methodology, style: Theme.of(context).textTheme.bodySmall)],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AsyncView(
                  value: collection,
                  onRetry: () => ref.invalidate(collectionProvider),
                  data: (entries) => _Breakdown(entries: entries),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.summary});

  final PortfolioSummary summary;

  @override
  Widget build(BuildContext context) {
    final s = summary;
    final tiles = [
      StatTile(label: 'Marktwaarde', value: Text(Fmt.money(s.marketValue))),
      StatTile(label: 'Aankoopwaarde', value: Text(Fmt.money(s.costBasis))),
      StatTile(
        label: 'Ongerealiseerd',
        value: GainText(s.unrealizedGain),
        footnote: s.unrealizedGainPercent == null ? null : Fmt.percent(s.unrealizedGainPercent),
      ),
      StatTile(label: 'Gerealiseerd', value: GainText(s.realizedGain), footnote: 'uit verkopen'),
      StatTile(
        label: 'Prijsdekking',
        value: Text('${s.pricedCopies}/${s.copies}'),
        footnote: s.unpricedCopies > 0 ? '${s.unpricedCopies} zonder prijs' : 'alle exemplaren geprijsd',
      ),
      StatTile(
        label: 'Prijsgegevens',
        value: Text(s.priceSources.isEmpty ? '—' : s.priceSources.join(', '), style: const TextStyle(fontSize: 14)),
        footnote: s.oldestPriceAt == null ? null : 'oudste prijs ${Fmt.date(s.oldestPriceAt)}',
      ),
    ];
    return TileGrid(minTileWidth: 260, children: tiles);
  }
}

class _PeriodChange extends StatelessWidget {
  const _PeriodChange({required this.points});

  final List<HistoryPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return const SizedBox.shrink();
    final first = points.first.marketValue;
    final last = points.last.marketValue;
    final change = last - first;
    final percent = first == Decimal.zero
        ? null
        : (change * Decimal.fromInt(100) / first).toDecimal(scaleOnInfinitePrecision: 4);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Verandering in deze periode: ', style: Theme.of(context).textTheme.bodyMedium),
        GainText(change, percent: percent),
      ],
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.entries});

  final List<CollectionEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    final bySet = <String, Decimal>{};
    for (final e in entries) {
      if (e.marketValue != null) {
        bySet.update(e.card.set.name, (v) => v + e.marketValue!, ifAbsent: () => e.marketValue!);
      }
    }
    final sets = bySet.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final total = sets.fold(Decimal.zero, (sum, e) => sum + e.value);
    final withGain = entries.where((e) => e.unrealizedGain != null).toList();
    final gainers = withGain.where((e) => e.unrealizedGain! > Decimal.zero).take(5).toList();
    final losers = withGain.where((e) => e.unrealizedGain! < Decimal.zero).toList().reversed.take(5).toList();

    Widget setsCard = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final s in sets)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(s.key)),
                        Text(Fmt.money(s.value)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: total == Decimal.zero ? 0 : (s.value / total).toDouble(),
                        minHeight: 8,
                        backgroundColor: PokeFolioColors.surfaceRaised,
                        color: PokeFolioColors.violet,
                        semanticsLabel: '${s.key} aandeel',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    Widget movers(String title, List<CollectionEntry> list, String empty) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(title),
        Card(
          child: list.isEmpty
              ? Padding(padding: const EdgeInsets.all(16), child: Text(empty))
              : Column(
                  children: [
                    for (final e in list)
                      ListTile(
                        title: Text('${e.card.name} ×${e.copies}'),
                        subtitle: Text(e.card.set.name),
                        trailing: GainText(e.unrealizedGain),
                      ),
                  ],
                ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle('Waarde per set'),
        setsCard,
        LayoutBuilder(
          builder: (context, c) {
            final a = movers('Grootste stijgers', gainers, 'Nog geen kaarten in de winst.');
            final b = movers('Grootste dalers', losers, 'Geen kaarten met verlies.');
            if (c.maxWidth < 800) return Column(children: [a, b]);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: a),
                const SizedBox(width: 16),
                Expanded(child: b),
              ],
            );
          },
        ),
      ],
    );
  }
}
