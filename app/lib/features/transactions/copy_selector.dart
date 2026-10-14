import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/card_art.dart';
import '../../core/widgets/states.dart';
import '../../data/queries.dart';
import '../../domain/models.dart';

/// Multi-select of the copies currently in the collection, grouped per card, with a filter.
class CopySelector extends ConsumerStatefulWidget {
  const CopySelector({super.key, required this.selected, required this.onChanged});

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  ConsumerState<CopySelector> createState() => _CopySelectorState();
}

class _CopySelectorState extends ConsumerState<CopySelector> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final holdings = ref.watch(activeHoldingsProvider);
    return AsyncView(
      value: holdings,
      onRetry: () => ref.invalidate(activeHoldingsProvider),
      data: (list) {
        if (list.isEmpty) {
          return const Card(
            child: Padding(padding: EdgeInsets.all(20), child: Text('Je collectie is leeg.')),
          );
        }
        final q = _filter.toLowerCase();
        final visible =
            list
                .where(
                  (h) =>
                      q.isEmpty || h.card.name.toLowerCase().contains(q) || h.card.set.name.toLowerCase().contains(q),
                )
                .toList()
              ..sort((a, b) {
                final selA = widget.selected.contains(a.id) ? 0 : 1;
                final selB = widget.selected.contains(b.id) ? 0 : 1;
                return selA != selB ? selA - selB : a.card.name.compareTo(b.card.name);
              });
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Filter op naam of set', prefixIcon: Icon(Icons.filter_list)),
              onChanged: (v) => setState(() => _filter = v.trim()),
            ),
            const SizedBox(height: 8),
            Card(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: ListView(shrinkWrap: true, children: [for (final h in visible) _tile(h)]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '${widget.selected.length} geselecteerd',
                style: const TextStyle(color: PokeFolioColors.textSecondary),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _tile(Holding h) {
    final selected = widget.selected.contains(h.id);
    return CheckboxListTile(
      value: selected,
      onChanged: (v) {
        final next = {...widget.selected};
        v == true ? next.add(h.id) : next.remove(h.id);
        widget.onChanged(next);
      },
      secondary: CardArt(card: h.card, width: 32),
      title: Text(
        '${h.card.name} · ${h.card.set.name} ${h.card.displayNumber}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${h.condition.label} · ${h.language.label} · ${h.variant.label} · '
        'waarde ${Fmt.money(h.marketValue)} · aankoop ${Fmt.money(h.purchasePrice)}',
      ),
    );
  }
}
