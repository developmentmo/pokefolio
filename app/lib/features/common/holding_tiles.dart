import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/card_art.dart';
import '../../core/widgets/money.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';

/// A copy in a list: art, card, attributes, value and gain.
class HoldingTile extends StatelessWidget {
  const HoldingTile({super.key, required this.holding, this.trailing, this.onTap});

  final Holding holding;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final h = holding;
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap ?? () => context.push('/cards/${h.card.id}'),
      leading: CardArt(card: h.card, width: 40),
      title: Text(h.card.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${h.card.set.name} · ${h.card.displayNumber} · ${h.condition.label} · ${h.language.label}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(color: PokeFolioColors.textSecondary),
      ),
      trailing:
          trailing ??
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                h.status == HoldingStatus.active ? Fmt.money(h.marketValue) : h.status.label,
                style: theme.textTheme.titleSmall,
              ),
              if (h.status == HoldingStatus.active) GainText(h.unrealizedGain, style: theme.textTheme.bodySmall),
            ],
          ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.onTap});

  final PortfolioTransaction transaction;
  final VoidCallback? onTap;

  static IconData icon(TransactionType t) => switch (t) {
    TransactionType.purchase => Icons.add_shopping_cart,
    TransactionType.sale => Icons.sell_outlined,
    TransactionType.gift => Icons.card_giftcard,
    TransactionType.trade => Icons.swap_horiz,
    TransactionType.correction => Icons.edit_note,
  };

  static Color color(TransactionType t) => switch (t) {
    TransactionType.purchase => PokeFolioColors.electric,
    TransactionType.sale => PokeFolioColors.gain,
    TransactionType.gift => PokeFolioColors.warning,
    TransactionType.trade => PokeFolioColors.violet,
    TransactionType.correction => PokeFolioColors.textSecondary,
  };

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final out = t.lines.where((l) => l.direction == LineDirection.outgoing).length;
    final inc = t.lines.where((l) => l.direction == LineDirection.incoming).length;
    final names = t.lines.map((l) => l.card.name).toSet().take(3).join(', ');
    final amount = t.cashIn ?? t.cashOut;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color(t.type).withValues(alpha: 0.15),
        child: Icon(icon(t.type), color: color(t.type), size: 20),
      ),
      title: Text(
        '${t.type.label} · ${switch (t.type) {
          TransactionType.trade => '$out af, $inc ontvangen',
          TransactionType.purchase => '$inc ${inc == 1 ? 'exemplaar' : 'exemplaren'}',
          _ => '$out ${out == 1 ? 'exemplaar' : 'exemplaren'}',
        }}',
      ),
      subtitle: Text('${Fmt.date(t.occurredOn)} · $names', maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: amount == null
          ? null
          : Text(
              '${t.cashIn != null ? '+' : '−'}${Fmt.money(amount, currency: t.currency)}',
              style: TextStyle(
                color: t.cashIn != null ? PokeFolioColors.gain : PokeFolioColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
