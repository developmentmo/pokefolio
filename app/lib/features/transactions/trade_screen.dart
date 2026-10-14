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
import '../catalog/card_search_screen.dart';
import '../common/form_fields.dart';
import 'copy_selector.dart';

class _Received {
  _Received(this.card);

  final PokemonCard card;
  int quantity = 1;
  CardCondition condition = CardCondition.nearMint;
  CardLanguage language = CardLanguage.en;
  CardVariant variant = CardVariant.normal;
  final value = TextEditingController();
}

enum _Cash { none, received, paid }

/// Registers a trade: several copies given, several cards received, optional cash, saved atomically.
class TradeScreen extends ConsumerStatefulWidget {
  const TradeScreen({super.key, this.preselected = const []});

  final List<String> preselected;

  @override
  ConsumerState<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends ConsumerState<TradeScreen> {
  final _form = GlobalKey<FormState>();
  late Set<String> _given = widget.preselected.toSet();
  final _received = <_Received>[];
  DateTime _date = DateUtils.dateOnly(DateTime.now());
  _Cash _cash = _Cash.none;
  final _cashAmount = TextEditingController();
  final _notes = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _cashAmount.dispose();
    _notes.dispose();
    for (final r in _received) {
      r.value.dispose();
    }
    super.dispose();
  }

  Future<void> _addReceived() async {
    final card = await Navigator.of(context).push<PokemonCard>(
      MaterialPageRoute(builder: (context) => CardSearchScreen(onPick: (c) => Navigator.of(context).pop(c))),
    );
    if (card != null) setState(() => _received.add(_Received(card)));
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (_given.isEmpty || _received.isEmpty) {
      showError(context, 'Selecteer minimaal één afgegeven exemplaar en één ontvangen kaart.');
      return;
    }
    final cash = parseMoneyInput(_cashAmount.text);
    setState(() => _busy = true);
    try {
      await ref
          .read(transactionRepositoryProvider)
          .trade(
            TradeInput(
              givenHoldingIds: _given.toList(),
              received: [
                for (final r in _received)
                  ReceivedCardInput(
                    cardId: r.card.id,
                    quantity: r.quantity,
                    condition: r.condition,
                    language: r.language,
                    variant: r.variant,
                    value: parseMoneyInput(r.value.text),
                  ),
              ],
              date: _date,
              cashReceived: _cash == _Cash.received ? cash : null,
              cashPaid: _cash == _Cash.paid ? cash : null,
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
            ),
          );
      ref.invalidatePortfolio();
      if (!mounted) return;
      showMessage(context, 'Ruil geregistreerd');
      context.canPop() ? context.pop() : context.go('/transactions');
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruil registreren')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            PageBody(
              maxWidth: 820,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Een ruil wordt in één keer opgeslagen: mislukt een onderdeel, dan verandert er niets aan je collectie.',
                  ),
                  const SectionTitle('Afgegeven exemplaren'),
                  CopySelector(selected: _given, onChanged: (s) => setState(() => _given = s)),
                  SectionTitle(
                    'Ontvangen kaarten',
                    trailing: TextButton.icon(
                      onPressed: _addReceived,
                      icon: const Icon(Icons.add),
                      label: const Text('Kaart kiezen'),
                    ),
                  ),
                  if (_received.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('Nog geen ontvangen kaarten. Kies de kaarten die je terugkrijgt.'),
                      ),
                    ),
                  for (final (i, r) in _received.indexed) _receivedCard(i, r),
                  const SectionTitle('Details'),
                  DateField(label: 'Datum', value: _date, onChanged: (d) => setState(() => _date = d ?? _date)),
                  const SizedBox(height: 16),
                  SegmentedButton<_Cash>(
                    segments: const [
                      ButtonSegment(value: _Cash.none, label: Text('Geen bijbetaling')),
                      ButtonSegment(value: _Cash.received, label: Text('Ik ontving geld')),
                      ButtonSegment(value: _Cash.paid, label: Text('Ik betaalde bij')),
                    ],
                    selected: {_cash},
                    onSelectionChanged: (s) => setState(() => _cash = s.first),
                  ),
                  if (_cash != _Cash.none) ...[
                    const SizedBox(height: 16),
                    MoneyField(controller: _cashAmount, label: 'Bijbetaling', required: true),
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notes,
                    decoration: const InputDecoration(labelText: 'Notities (bijv. met wie)'),
                    maxLines: 2,
                    maxLength: 2000,
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    key: const Key('trade-submit'),
                    onPressed: _busy ? null : _submit,
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Ruil opslaan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receivedCard(int index, _Received r) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CardArt(card: r.card, width: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.card.name, style: Theme.of(context).textTheme.titleMedium),
                        Text('${r.card.set.name} · ${r.card.displayNumber}'),
                        PriceLabel(r.card.price, showFlags: false, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Minder',
                    onPressed: r.quantity > 1 ? () => setState(() => r.quantity--) : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('${r.quantity}×'),
                  IconButton(
                    tooltip: 'Meer',
                    onPressed: r.quantity < 100 ? () => setState(() => r.quantity++) : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  IconButton(
                    tooltip: 'Verwijderen',
                    onPressed: () => setState(() => _received.removeAt(index).value.dispose()),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 180,
                    child: EnumDropdown<CardCondition>(
                      label: 'Conditie',
                      value: r.condition,
                      values: CardCondition.values,
                      itemLabel: (v) => v.label,
                      onChanged: (v) => setState(() => r.condition = v),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: EnumDropdown<CardLanguage>(
                      label: 'Taal',
                      value: r.language,
                      values: CardLanguage.values,
                      itemLabel: (v) => v.label,
                      onChanged: (v) => setState(() => r.language = v),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: EnumDropdown<CardVariant>(
                      label: 'Variant',
                      value: r.variant,
                      values: CardVariant.values,
                      itemLabel: (v) => v.label,
                      onChanged: (v) => setState(() => r.variant = v),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: MoneyField(
                      controller: r.value,
                      label: 'Waarde per stuk',
                      helper: r.card.price?.isAvailable == true
                          ? 'Markt: ${Fmt.money(r.card.price!.market)}'
                          : 'Wordt je aankoopwaarde',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
