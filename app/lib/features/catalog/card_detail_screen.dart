import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/card_art.dart';
import '../../core/widgets/charts.dart';
import '../../core/widgets/money.dart';
import '../../core/widgets/states.dart';
import '../../data/providers.dart';
import '../../data/queries.dart';
import '../../domain/enums.dart';
import '../../domain/inputs.dart';
import '../../domain/models.dart';

class CardDetailScreen extends ConsumerStatefulWidget {
  const CardDetailScreen({super.key, required this.cardId});

  final String cardId;

  @override
  ConsumerState<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends ConsumerState<CardDetailScreen> {
  int _days = 90;

  @override
  Widget build(BuildContext context) {
    final card = ref.watch(cardProvider(widget.cardId));
    return Scaffold(
      appBar: AppBar(title: Text(card.value?.name ?? 'Kaartdetails')),
      floatingActionButton: card.hasValue
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/cards/${widget.cardId}/add'),
              icon: const Icon(Icons.add),
              label: const Text('Aan collectie toevoegen'),
            )
          : null,
      body: AsyncView(
        value: card,
        onRetry: () => ref.invalidate(cardProvider(widget.cardId)),
        data: (c) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
          children: [
            PageBody(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 800;
                  final art = Center(
                    child: CardArt(card: c, width: wide ? 280 : 200, large: true),
                  );
                  final info = _CardInfo(card: c);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (wide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            art,
                            const SizedBox(width: 32),
                            Expanded(child: info),
                          ],
                        )
                      else ...[
                        art,
                        const SizedBox(height: 20),
                        info,
                      ],
                      SectionTitle(
                        'Prijsontwikkeling',
                        trailing: RangeSelector(value: _days, onChanged: (d) => setState(() => _days = d)),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ref
                              .watch(priceHistoryProvider((cardId: c.id, days: _days)))
                              .when(
                                data: (h) => h.points.isEmpty
                                    ? const SizedBox(
                                        height: 160,
                                        child: Center(child: Text('Geen prijshistorie beschikbaar')),
                                      )
                                    : TimeSeriesChart(
                                        currency: h.currency,
                                        series: [
                                          ChartSeries(
                                            label: 'Marktprijs',
                                            color: PokeFolioColors.electric,
                                            points: [for (final p in h.points) (p.observedAt, p.market)],
                                          ),
                                        ],
                                      ),
                                loading: () => const SizedBox(height: 240, child: LoadingView()),
                                error: (e, _) => ErrorView(message: e.toString()),
                              ),
                        ),
                      ),
                      SectionTitle('Jouw exemplaren'),
                      _CopiesSection(cardId: c.id),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  const _CardInfo({required this.card});

  final PokemonCard card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = card.price;
    Widget fact(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(color: PokeFolioColors.textSecondary)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(card.name, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text('${card.set.name} · ${card.displayNumber}', style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        fact('Set', '${card.set.name}${card.set.series != null ? ' (${card.set.series})' : ''}'),
        fact('Uitgebracht', Fmt.date(card.set.releaseDate)),
        fact('Kaartnummer', card.displayNumber),
        fact('Zeldzaamheid', card.rarity ?? '—'),
        fact('Type', card.pokemonType ?? '—'),
        fact('Provider-ID', '${card.provider}:${card.externalId}'),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Marktprijs', style: theme.textTheme.labelLarge?.copyWith(color: PokeFolioColors.textSecondary)),
                const SizedBox(height: 6),
                PriceLabel(p, style: theme.textTheme.headlineSmall),
                if (p != null && p.isAvailable) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Laag ${Fmt.money(p.low, currency: p.currency)} · Hoog ${Fmt.money(p.high, currency: p.currency)}',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bron: ${p.source} · ${p.currency} · laatste update ${Fmt.dateTime(p.observedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: PokeFolioColors.textSecondary),
                  ),
                  if (p.stale)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'Let op: deze prijs is verouderd. De laatst bekende prijs wordt getoond.',
                        style: TextStyle(color: PokeFolioColors.warning),
                      ),
                    ),
                  if (p.sampleData) const Padding(padding: EdgeInsets.only(top: 10), child: SampleDataBanner()),
                ] else
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text('Er is geen marktprijs beschikbaar. Deze kaart telt niet mee in je portfoliowaarde.'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CopiesSection extends ConsumerWidget {
  const _CopiesSection({required this.cardId});

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copies = ref.watch(cardHoldingsProvider(cardId));
    return AsyncView(
      value: copies,
      onRetry: () => ref.invalidate(cardHoldingsProvider(cardId)),
      data: (list) => list.isEmpty
          ? const Card(
              child: Padding(padding: EdgeInsets.all(20), child: Text('Je hebt nog geen exemplaren van deze kaart.')),
            )
          : Card(
              child: Column(children: [for (final h in list) _CopyTile(holding: h)]),
            ),
    );
  }
}

class _CopyTile extends ConsumerWidget {
  const _CopyTile({required this.holding});

  final Holding holding;

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exemplaar verwijderen?'),
        content: const Text(
          'Gebruik dit alleen voor een exemplaar dat per ongeluk is toegevoegd. '
          'De registratie blijft zichtbaar in je transactiehistorie als correctie.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuleren')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Verwijderen')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref
          .read(transactionRepositoryProvider)
          .correct(GiftInput(holdingIds: [holding.id], date: DateTime.now(), notes: 'Per ongeluk geregistreerd'));
      ref.invalidatePortfolio();
      if (context.mounted) showMessage(context, 'Exemplaar verwijderd');
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = holding;
    final active = h.status == HoldingStatus.active;
    final theme = Theme.of(context);
    return ListTile(
      title: Text('${h.condition.label} · ${h.language.label} · ${h.variant.label}'),
      subtitle: Text(
        [
          'Aankoop ${Fmt.money(h.purchasePrice)}${h.purchaseDate != null ? ' op ${Fmt.date(h.purchaseDate)}' : ''}',
          if (!active) '${h.status.label} op ${Fmt.date(h.disposedOn)}',
          if (h.notes != null && h.notes!.isNotEmpty) h.notes!,
        ].join('\n'),
      ),
      isThreeLine: true,
      trailing: active
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(Fmt.money(h.marketValue), style: theme.textTheme.titleSmall),
                    GainText(h.unrealizedGain, style: theme.textTheme.bodySmall),
                  ],
                ),
                PopupMenuButton<String>(
                  tooltip: 'Acties',
                  onSelected: (action) => switch (action) {
                    'edit' => context.push('/holdings/${h.id}/edit'),
                    'sell' => context.push('/sell?holdings=${h.id}&mode=sale'),
                    'gift' => context.push('/sell?holdings=${h.id}&mode=gift'),
                    'trade' => context.push('/trade?holdings=${h.id}'),
                    _ => _remove(context, ref),
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Bewerken')),
                    PopupMenuItem(value: 'sell', child: Text('Verkopen')),
                    PopupMenuItem(value: 'gift', child: Text('Weggeven')),
                    PopupMenuItem(value: 'trade', child: Text('Ruilen')),
                    PopupMenuItem(value: 'remove', child: Text('Verwijderen (correctie)')),
                  ],
                ),
              ],
            )
          : Chip(label: Text(h.status.label)),
    );
  }
}
