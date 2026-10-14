import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/card_art.dart';
import '../../core/widgets/money.dart';
import '../../core/widgets/states.dart';
import '../../data/queries.dart';
import '../../data/repositories.dart';
import '../../domain/models.dart';

/// Catalog search by name, set or card number with set/rarity filters, sorting and pagination.
/// When [onPick] is set the screen acts as a picker (used when registering a trade).
class CardSearchScreen extends ConsumerStatefulWidget {
  const CardSearchScreen({super.key, this.onPick});

  final ValueChanged<PokemonCard>? onPick;

  @override
  ConsumerState<CardSearchScreen> createState() => _CardSearchScreenState();
}

class _CardSearchScreenState extends ConsumerState<CardSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';
  String? _setId;
  String? _rarity;
  CardSort _sort = CardSort.name;
  int _page = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _query = value.trim();
          _page = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(
      cardSearchProvider((query: _query, setId: _setId, rarity: _rarity, sort: _sort, page: _page)),
    );
    final filters = ref.watch(catalogFiltersProvider);
    return Scaffold(
      appBar: AppBar(title: Text(widget.onPick == null ? 'Kaarten zoeken' : 'Kies een ontvangen kaart')),
      body: PageBody(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: TextField(
                key: const Key('card-search-field'),
                controller: _controller,
                autofocus: widget.onPick != null,
                decoration: const InputDecoration(
                  hintText: 'Naam, set of kaartnummer (bijv. Charizard, Evolving Skies, 215)',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _onChanged,
                onSubmitted: (v) => setState(() {
                  _query = v.trim();
                  _page = 0;
                }),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _Dropdown<String?>(
                    label: 'Set',
                    value: _setId,
                    items: {null: 'Alle sets', for (final s in filters.value?.sets ?? const <CardSet>[]) s.id: s.name},
                    onChanged: (v) => setState(() {
                      _setId = v;
                      _page = 0;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _Dropdown<String?>(
                    label: 'Zeldzaamheid',
                    value: _rarity,
                    items: {
                      null: 'Alle zeldzaamheden',
                      for (final r in filters.value?.rarities ?? const <String>[]) r: r,
                    },
                    onChanged: (v) => setState(() {
                      _rarity = v;
                      _page = 0;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _Dropdown<CardSort>(
                    label: 'Sorteren',
                    value: _sort,
                    items: const {CardSort.name: 'Naam', CardSort.number: 'Nummer', CardSort.newest: 'Nieuwste set'},
                    onChanged: (v) => setState(() {
                      _sort = v;
                      _page = 0;
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AsyncView(
                value: result,
                onRetry: () => ref.invalidate(cardSearchProvider),
                data: (page) {
                  if (page.content.isEmpty) {
                    return const EmptyView(
                      icon: Icons.search_off,
                      title: 'Geen kaarten gevonden',
                      message: 'Probeer een andere naam, set of kaartnummer.',
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
                    children: [
                      if (page.content.any((c) => c.price?.sampleData ?? false))
                        const Padding(padding: EdgeInsets.all(8), child: SampleDataBanner()),
                      for (final card in page.content)
                        ListTile(
                          onTap: () => widget.onPick != null ? widget.onPick!(card) : context.push('/cards/${card.id}'),
                          leading: CardArt(card: card, width: 44),
                          title: Text(card.name),
                          subtitle: Text(
                            '${card.set.name} · ${card.displayNumber} · ${card.rarity ?? ''}',
                            style: const TextStyle(color: PokeFolioColors.textSecondary),
                          ),
                          trailing: SizedBox(
                            width: 140,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: PriceLabel(
                                card.price,
                                showFlags: false,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          ),
                        ),
                      if (page.totalPages > 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: 'Vorige pagina',
                              onPressed: _page > 0 ? () => setState(() => _page--) : null,
                              icon: const Icon(Icons.chevron_left),
                            ),
                            Text('Pagina ${page.page + 1} van ${page.totalPages} · ${page.totalElements} kaarten'),
                            IconButton(
                              tooltip: 'Volgende pagina',
                              onPressed: page.hasMore ? () => setState(() => _page++) : null,
                              icon: const Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
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

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({required this.label, required this.value, required this.items, required this.onChanged});

  final String label;
  final T value;
  final Map<T, String> items;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      tooltip: label,
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (_) => [for (final e in items.entries) PopupMenuItem(value: e.key, child: Text(e.value))],
      child: Chip(avatar: const Icon(Icons.filter_list, size: 16), label: Text('$label: ${items[value] ?? '—'}')),
    );
  }
}
