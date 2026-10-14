import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters.dart';
import '../../core/widgets/states.dart';
import '../../data/providers.dart';
import '../../data/queries.dart';
import '../../domain/inputs.dart';
import '../common/form_fields.dart';
import 'copy_selector.dart';

enum SaleMode { sale, gift }

/// Registers a sale (date, copies, proceeds, fees, notes) or a gift (date, copies, notes).
class SaleScreen extends ConsumerStatefulWidget {
  const SaleScreen({super.key, this.preselected = const [], this.mode = SaleMode.sale});

  final List<String> preselected;
  final SaleMode mode;

  @override
  ConsumerState<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends ConsumerState<SaleScreen> {
  final _form = GlobalKey<FormState>();
  late Set<String> _selected = widget.preselected.toSet();
  late SaleMode _mode = widget.mode;
  DateTime _date = DateUtils.dateOnly(DateTime.now());
  final _proceeds = TextEditingController();
  final _fees = TextEditingController();
  final _notes = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _proceeds.dispose();
    _fees.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (_selected.isEmpty) {
      showError(context, 'Selecteer minimaal één exemplaar.');
      return;
    }
    final proceeds = parseMoneyInput(_proceeds.text) ?? Decimal.zero;
    final fees = parseMoneyInput(_fees.text);
    if (_mode == SaleMode.sale && fees != null && fees > proceeds) {
      showError(context, 'De kosten zijn hoger dan de opbrengst.');
    }
    setState(() => _busy = true);
    try {
      final repo = ref.read(transactionRepositoryProvider);
      final notes = _notes.text.trim().isEmpty ? null : _notes.text.trim();
      if (_mode == SaleMode.sale) {
        await repo.sell(
          SaleInput(holdingIds: _selected.toList(), date: _date, proceeds: proceeds, fees: fees, notes: notes),
        );
      } else {
        await repo.gift(GiftInput(holdingIds: _selected.toList(), date: _date, notes: notes));
      }
      ref.invalidatePortfolio();
      if (!mounted) return;
      showMessage(context, _mode == SaleMode.sale ? 'Verkoop geregistreerd' : 'Gift geregistreerd');
      context.canPop() ? context.pop() : context.go('/transactions');
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sale = _mode == SaleMode.sale;
    return Scaffold(
      appBar: AppBar(title: Text(sale ? 'Verkoop registreren' : 'Weggeven registreren')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            PageBody(
              maxWidth: 720,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<SaleMode>(
                    segments: const [
                      ButtonSegment(value: SaleMode.sale, icon: Icon(Icons.sell_outlined), label: Text('Verkopen')),
                      ButtonSegment(value: SaleMode.gift, icon: Icon(Icons.card_giftcard), label: Text('Weggeven')),
                    ],
                    selected: {_mode},
                    onSelectionChanged: (s) => setState(() => _mode = s.first),
                  ),
                  const SectionTitle('Exemplaren'),
                  CopySelector(selected: _selected, onChanged: (s) => setState(() => _selected = s)),
                  const SectionTitle('Details'),
                  DateField(label: 'Datum', value: _date, onChanged: (d) => setState(() => _date = d ?? _date)),
                  if (sale) ...[
                    const SizedBox(height: 16),
                    MoneyField(
                      controller: _proceeds,
                      label:
                          'Verkoopbedrag (totaal voor ${_selected.length} ${_selected.length == 1 ? 'exemplaar' : 'exemplaren'})',
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    MoneyField(controller: _fees, label: 'Kosten (verzending, platform)', helper: 'Optioneel'),
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notes,
                    decoration: InputDecoration(
                      labelText: sale ? 'Notities (bijv. koper of platform)' : 'Notities (bijv. aan wie)',
                    ),
                    maxLines: 2,
                    maxLength: 2000,
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    key: const Key('sale-submit'),
                    onPressed: _busy ? null : _submit,
                    icon: const Icon(Icons.check),
                    label: Text(sale ? 'Verkoop opslaan' : 'Gift opslaan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
