import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/card_art.dart';
import '../../core/widgets/money.dart';
import '../../core/widgets/states.dart';
import '../../data/queries.dart';
import '../../data/repositories.dart';
import '../../domain/models.dart';

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  final _search = TextEditingController();
  String _query = '';
  CollectionSort _sort = CollectionSort.value;
  bool _grid = true;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(collectionProvider((query: _query, sort: _sort)));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mijn collectie'),
        actions: [
          IconButton(
            tooltip: _grid ? 'Lijstweergave' : 'Rasterweergave',
            onPressed: () => setState(() => _grid = !_grid),
            icon: Icon(_grid ? Icons.view_list_outlined : Icons.grid_view_outlined),
          ),
          PopupMenuButton<CollectionSort>(
            tooltip: 'Sorteren',
            icon: const Icon(Icons.sort),
            initialValue: _sort,
            onSelected: (s) => setState(() => _sort = s),
            itemBuilder: (_) => [for (final s in CollectionSort.values) PopupMenuItem(value: s, child: Text(s.label))],
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/search'),
        icon: const Icon(Icons.add),
        label: const Text('Toevoegen'),
      ),
      body: PageBody(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: 'Zoek in je collectie op naam, set of nummer',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Wissen',
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                            _search.clear();
                            _query = '';
                          }),
                        ),
                ),
                onSubmitted: (v) => setState(() => _query = v.trim()),
                onChanged: (v) {
                  if (v.isEmpty) setState(() => _query = '');
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.invalidatePortfolio(),
                child: AsyncView(
                  value: result,
                  onRetry: () => ref.invalidate(collectionProvider),
                  data: (page) {
                    if (page.content.isEmpty) {
                      return _query.isEmpty
                          ? EmptyView(
                              icon: Icons.style_outlined,
                              title: 'Je collectie is leeg',
                              message: 'Zoek kaarten en voeg exemplaren toe met conditie, taal en aankoopprijs.',
                              action: FilledButton(
                                onPressed: () => context.go('/search'),
                                child: const Text('Kaarten zoeken'),
                              ),
                            )
                          : const EmptyView(icon: Icons.search_off, title: 'Geen kaarten gevonden');
                    }
                    return _grid ? _Grid(entries: page.content) : _List(entries: page.content);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.entries});

  final List<CollectionEntry> entries;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.52,
      ),
      itemCount: entries.length,
      itemBuilder: (context, i) => _GridItem(entry: entries[i]),
    );
  }
}

class _GridItem extends StatelessWidget {
  const _GridItem({required this.entry});

  final CollectionEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push('/cards/${entry.card.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, c) => Stack(
              children: [
                CardArt(card: entry.card, width: c.maxWidth),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                    child: Text('×${entry.copies}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(entry.card.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
          Text(
            '${entry.card.set.name} · ${entry.card.displayNumber}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: PokeFolioColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(Fmt.money(entry.marketValue), style: theme.textTheme.titleSmall),
          GainText(entry.unrealizedGain, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.entries});

  final List<CollectionEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 96),
      itemCount: entries.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final e = entries[i];
        return ListTile(
          onTap: () => context.push('/cards/${e.card.id}'),
          leading: CardArt(card: e.card, width: 44),
          title: Text('${e.card.name}  ×${e.copies}'),
          subtitle: Text('${e.card.set.name} · ${e.card.displayNumber} · aankoop ${Fmt.money(e.costBasis)}'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Fmt.money(e.marketValue), style: Theme.of(context).textTheme.titleSmall),
              GainText(e.unrealizedGain, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        );
      },
    );
  }
}
