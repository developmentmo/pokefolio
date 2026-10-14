import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../domain/models.dart';
import '../format/formatters.dart';
import '../theme/app_theme.dart';

/// Gain/loss with colour and sign. Unknown values read "Onbekend", never zero.
class GainText extends StatelessWidget {
  const GainText(this.amount, {super.key, this.percent, this.style, this.currency = 'EUR'});

  final Decimal? amount;
  final Decimal? percent;
  final TextStyle? style;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final color = amount == null
        ? PokeFolioColors.textSecondary
        : amount! > Decimal.zero
        ? PokeFolioColors.gain
        : amount! < Decimal.zero
        ? PokeFolioColors.loss
        : PokeFolioColors.textSecondary;
    final text = percent == null
        ? Fmt.signedMoney(amount, currency: currency)
        : '${Fmt.signedMoney(amount, currency: currency)} (${Fmt.percent(percent)})';
    return Text(text, style: (style ?? Theme.of(context).textTheme.bodyMedium)?.copyWith(color: color));
  }
}

/// Current market price with its status: unknown, stale or sample data.
class PriceLabel extends StatelessWidget {
  const PriceLabel(this.price, {super.key, this.style, this.showFlags = true});

  final PriceInfo? price;
  final TextStyle? style;
  final bool showFlags;

  @override
  Widget build(BuildContext context) {
    final p = price;
    final base = style ?? Theme.of(context).textTheme.titleMedium;
    if (p == null || !p.isAvailable) {
      return Tooltip(
        message: 'Er is geen marktprijs bekend voor deze kaart',
        child: Text('Prijs onbekend', style: base?.copyWith(color: PokeFolioColors.textSecondary)),
      );
    }
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(Fmt.money(p.market, currency: p.currency), style: base),
        if (showFlags && p.stale)
          const StatusChip(label: 'Verouderd', color: PokeFolioColors.warning, icon: Icons.history),
        if (showFlags && p.sampleData)
          const StatusChip(label: 'Voorbeeld', color: PokeFolioColors.electric, icon: Icons.science_outlined),
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 0.6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 12, color: color), const SizedBox(width: 3)],
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
