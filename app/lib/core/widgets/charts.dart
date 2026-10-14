import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../format/formatters.dart';
import '../theme/app_theme.dart';

class ChartSeries {
  const ChartSeries({required this.label, required this.color, required this.points, this.dashed = false});

  final String label;
  final Color color;
  final List<(DateTime, Decimal)> points;
  final bool dashed;
}

/// Time-series line chart with labelled axes, tooltips and a legend.
class TimeSeriesChart extends StatelessWidget {
  const TimeSeriesChart({
    super.key,
    required this.series,
    this.height = 240,
    this.currency = 'EUR',
    this.compact = false,
  });

  final List<ChartSeries> series;
  final double height;
  final String currency;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final all = series.expand((s) => s.points).toList();
    if (all.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('Nog geen gegevens om te tonen')),
      );
    }
    final minX = all.map((p) => p.$1.millisecondsSinceEpoch).reduce((a, b) => a < b ? a : b).toDouble();
    final maxX = all.map((p) => p.$1.millisecondsSinceEpoch).reduce((a, b) => a > b ? a : b).toDouble();
    var minY = all.map((p) => p.$2.toDouble()).reduce((a, b) => a < b ? a : b);
    var maxY = all.map((p) => p.$2.toDouble()).reduce((a, b) => a > b ? a : b);
    final pad = (maxY - minY).abs() * 0.1 + (maxY == 0 ? 1 : maxY * 0.02);
    minY = (minY - pad).clamp(0, double.infinity);
    maxY = maxY + pad;
    final spanX = (maxX - minX) <= 0 ? 1.0 : maxX - minX;

    final chart = LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => const FlLine(color: PokeFolioColors.outline, strokeWidth: 0.5),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: !compact,
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 64,
              getTitlesWidget: (value, meta) => value == meta.min || value == meta.max
                  ? const SizedBox.shrink()
                  : Text(
                      _compactMoney(value),
                      style: const TextStyle(fontSize: 11, color: PokeFolioColors.textSecondary),
                    ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: spanX / 4,
              getTitlesWidget: (value, meta) => value == meta.min || value == meta.max
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        Fmt.shortDate(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
                        style: const TextStyle(fontSize: 11, color: PokeFolioColors.textSecondary),
                      ),
                    ),
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: !compact,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => PokeFolioColors.surfaceRaised,
            getTooltipItems: (spots) => spots.map((s) {
              final serie = series[s.barIndex];
              final date = Fmt.date(DateTime.fromMillisecondsSinceEpoch(s.x.toInt()));
              return LineTooltipItem(
                '${s.barIndex == 0 ? '$date\n' : ''}${serie.label}: '
                '${Fmt.money(Decimal.parse(s.y.toStringAsFixed(2)), currency: currency)}',
                TextStyle(color: serie.color, fontSize: 12, fontWeight: FontWeight.w600),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          for (final (i, s) in series.indexed)
            LineChartBarData(
              spots: [for (final p in s.points) FlSpot(p.$1.millisecondsSinceEpoch.toDouble(), p.$2.toDouble())],
              color: s.color,
              barWidth: i == 0 ? 2.5 : 1.5,
              isCurved: true,
              curveSmoothness: 0.15,
              preventCurveOverShooting: true,
              dotData: const FlDotData(show: false),
              dashArray: s.dashed ? [6, 4] : null,
              belowBarData: i == 0
                  ? BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [s.color.withValues(alpha: 0.3), s.color.withValues(alpha: 0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    )
                  : BarAreaData(show: false),
            ),
        ],
      ),
    );

    return Semantics(
      label: 'Grafiek: ${series.map((s) => s.label).join(', ')}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height, child: chart),
          if (!compact && series.length > 1) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              children: [
                for (final s in series)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 14, height: 3, color: s.color),
                      const SizedBox(width: 6),
                      Text(s.label, style: const TextStyle(fontSize: 12, color: PokeFolioColors.textSecondary)),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static String _compactMoney(double v) {
    if (v >= 1000000) return '€${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '€${(v / 1000).toStringAsFixed(1)}k';
    return '€${v.toStringAsFixed(v < 10 ? 2 : 0)}';
  }
}

/// Segmented range selector for charts.
class RangeSelector extends StatelessWidget {
  const RangeSelector({super.key, required this.value, required this.onChanged, this.options = const [30, 90, 365]});

  final int value;
  final ValueChanged<int> onChanged;
  final List<int> options;

  static String label(int days) => switch (days) {
    7 => '1W',
    30 => '1M',
    90 => '3M',
    180 => '6M',
    365 => '1J',
    _ => '${days}d',
  };

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      showSelectedIcon: false,
      style: const ButtonStyle(visualDensity: VisualDensity.compact),
      segments: [for (final d in options) ButtonSegment(value: d, label: Text(label(d)))],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
