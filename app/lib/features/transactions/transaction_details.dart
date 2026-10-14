import 'package:flutter/material.dart';

import '../../core/format/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/money.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../common/holding_tiles.dart';

Future<void> showTransactionDetails(BuildContext context, PortfolioTransaction t) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: PokeFolioColors.surface,
    constraints: const BoxConstraints(maxWidth: 640),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (context, controller) => TransactionDetails(transaction: t, controller: controller),
    ),
  );
}

class TransactionDetails extends StatelessWidget {
  const TransactionDetails({super.key, required this.transaction, this.controller});

  final PortfolioTransaction transaction;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final theme = Theme.of(context);
    final out = t.lines.where((l) => l.direction == LineDirection.outgoing).toList();
    final inc = t.lines.where((l) => l.direction == LineDirection.incoming).toList();
    Widget row(String label, Widget value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: PokeFolioColors.textSecondary)),
          ),
          value,
        ],
      ),
    );
    Widget lines(String title, List<TransactionLine> list) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        for (final l in list)
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text('${l.card.name} · ${l.card.setName} ${l.card.number}'),
            subtitle: Text(
              '${l.condition.label} · ${l.language.label} · ${l.variant.label}'
              '${l.purchasePrice != null ? ' · aankoop ${Fmt.money(l.purchasePrice)}' : ''}',
            ),
            trailing: l.allocatedAmount == null ? null : Text(Fmt.money(l.allocatedAmount, currency: t.currency)),
          ),
      ],
    );
    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Row(
          children: [
            Icon(TransactionTile.icon(t.type), color: TransactionTile.color(t.type)),
            const SizedBox(width: 10),
            Text(t.type.label, style: theme.textTheme.headlineSmall),
          ],
        ),
        const SizedBox(height: 12),
        row('Datum', Text(Fmt.date(t.occurredOn))),
        if (t.cashIn != null)
          row(
            t.type == TransactionType.trade ? 'Bijbetaling ontvangen' : 'Opbrengst',
            Text(Fmt.money(t.cashIn, currency: t.currency)),
          ),
        if (t.cashOut != null)
          row(
            t.type == TransactionType.trade ? 'Bijbetaling betaald' : 'Betaald',
            Text(Fmt.money(t.cashOut, currency: t.currency)),
          ),
        if (t.fees != null) row('Kosten', Text(Fmt.money(t.fees, currency: t.currency))),
        if (t.type == TransactionType.sale) row('Gerealiseerde winst', GainText(t.realizedGain, currency: t.currency)),
        if (t.notes != null && t.notes!.isNotEmpty) row('Notities', Flexible(child: Text(t.notes!))),
        if (out.isNotEmpty) lines(t.type == TransactionType.trade ? 'Afgegeven' : 'Exemplaren', out),
        if (inc.isNotEmpty) lines(t.type == TransactionType.trade ? 'Ontvangen' : 'Exemplaren', inc),
      ],
    );
  }
}
