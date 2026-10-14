import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters.dart';
import '../../core/widgets/card_art.dart';
import '../../core/widgets/money.dart';
import '../../core/widgets/states.dart';
import '../../data/providers.dart';
import '../../data/queries.dart';
import '../../domain/enums.dart';
import '../../domain/inputs.dart';
import '../../domain/models.dart';
import '../common/form_fields.dart';

/// Adds copies of a card ([cardId]) or edits an existing copy ([holdingId]).
class HoldingFormScreen extends ConsumerWidget {
  const HoldingFormScreen({super.key, this.cardId, this.holdingId}) : assert((cardId == null) != (holdingId == null));

  final String? cardId;
  final String? holdingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (holdingId != null) {
      final holding = ref.watch(holdingProvider(holdingId!));
      return Scaffold(
        appBar: AppBar(title: const Text('Exemplaar bewerken')),
        body: AsyncView(
          value: holding,
          onRetry: () => ref.invalidate(holdingProvider(holdingId!)),
          data: (h) => _HoldingForm(card: h.card, existing: h),
        ),
      );
    }
    final card = ref.watch(cardProvider(cardId!));
    return Scaffold(
      appBar: AppBar(title: const Text('Kaart toevoegen')),
      body: AsyncView(
        value: card,
        onRetry: () => ref.invalidate(cardProvider(cardId!)),
        data: (c) => _HoldingForm(card: c),
      ),
    );
  }
}

class _HoldingForm extends ConsumerStatefulWidget {
  const _HoldingForm({required this.card, this.existing});

  final PokemonCard card;
  final Holding? existing;

  @override
  ConsumerState<_HoldingForm> createState() => _HoldingFormState();
}

class _HoldingFormState extends ConsumerState<_HoldingForm> {
  final _form = GlobalKey<FormState>();
  late CardCondition _condition = widget.existing?.condition ?? CardCondition.nearMint;
  late CardLanguage _language = widget.existing?.language ?? CardLanguage.en;
  late CardVariant _variant = widget.existing?.variant ?? CardVariant.normal;
  late DateTime? _purchaseDate =
      widget.existing?.purchaseDate ?? (widget.existing == null ? DateUtils.dateOnly(DateTime.now()) : null);
  late final _price = TextEditingController(text: widget.existing?.purchasePrice?.toString() ?? '');
  late final _notes = TextEditingController(text: widget.existing?.notes ?? '');
  int _quantity = 1;
  bool _busy = false;

  bool get _editing => widget.existing != null;

  @override
  void dispose() {
    _price.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final input = HoldingInput(
      condition: _condition,
      language: _language,
      variant: _variant,
      purchasePrice: parseMoneyInput(_price.text),
      purchaseDate: _purchaseDate,
      notes: _notes.text,
    );
    try {
      final repo = ref.read(portfolioRepositoryProvider);
      if (_editing) {
        await repo.updateHolding(widget.existing!.id, input);
      } else {
        await repo.addHoldings(widget.card.id, _quantity, input);
      }
      ref.invalidatePortfolio();
      if (!mounted) return;
      showMessage(context, _editing ? 'Exemplaar bijgewerkt' : '$_quantity× ${widget.card.name} toegevoegd');
      context.pop();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.card;
    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          PageBody(
            maxWidth: 640,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CardArt(card: c, width: 72),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name, style: Theme.of(context).textTheme.titleLarge),
                          Text('${c.set.name} · ${c.displayNumber} · ${c.rarity ?? ''}'),
                          const SizedBox(height: 4),
                          PriceLabel(c.price, style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (!_editing) ...[
                  Row(
                    children: [
                      const Expanded(child: Text('Aantal exemplaren')),
                      IconButton(
                        tooltip: 'Minder',
                        onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$_quantity', key: const Key('quantity'), style: Theme.of(context).textTheme.titleLarge),
                      IconButton(
                        tooltip: 'Meer',
                        onPressed: _quantity < 100 ? () => setState(() => _quantity++) : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                EnumDropdown<CardCondition>(
                  label: 'Conditie',
                  value: _condition,
                  values: CardCondition.values,
                  itemLabel: (v) => v.label,
                  onChanged: (v) => setState(() => _condition = v),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: EnumDropdown<CardLanguage>(
                        label: 'Taal',
                        value: _language,
                        values: CardLanguage.values,
                        itemLabel: (v) => v.label,
                        onChanged: (v) => setState(() => _language = v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: EnumDropdown<CardVariant>(
                        label: 'Variant',
                        value: _variant,
                        values: CardVariant.values,
                        itemLabel: (v) => v.label,
                        onChanged: (v) => setState(() => _variant = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                MoneyField(
                  controller: _price,
                  label: _editing ? 'Aankoopprijs' : 'Aankoopprijs per exemplaar',
                  helper: 'Laat leeg als je het niet meer weet',
                ),
                const SizedBox(height: 16),
                DateField(
                  label: 'Aankoopdatum',
                  value: _purchaseDate,
                  allowClear: true,
                  onChanged: (d) => setState(() => _purchaseDate = d),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notes,
                  decoration: const InputDecoration(labelText: 'Notities (optioneel)'),
                  maxLines: 3,
                  maxLength: 2000,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  key: const Key('holding-save'),
                  onPressed: _busy ? null : _save,
                  icon: const Icon(Icons.check),
                  label: Text(_editing ? 'Opslaan' : 'Toevoegen aan collectie'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
