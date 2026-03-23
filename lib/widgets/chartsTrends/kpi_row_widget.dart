import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/charts_trends_datamodel.dart';

typedef C = AppColors;

class KpiRowWidget extends StatelessWidget {
  final List<SeriesData> activeSeries;
  final Animation<double> glowAnimation;

  const KpiRowWidget({
    super.key,
    required this.activeSeries,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: activeSeries.asMap().entries.map((entry) {
          final index = entry.key;
          final series = entry.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == activeSeries.length - 1 ? 0 : 6,
              ),
              child: KpiCard(series: series, glowAnimation: glowAnimation),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class KpiCard extends StatelessWidget {
  final SeriesData series;
  final Animation<double> glowAnimation;

  const KpiCard({super.key, required this.series, required this.glowAnimation});

  @override
  Widget build(BuildContext context) {
    final trend = series.trend;
    final isUp = trend >= 0;

    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: series.metric.color.withOpacity(
              0.2 + glowAnimation.value * 0.05,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(series.metric.icon, color: series.metric.color, size: 11),
                const SizedBox(width: 4),
                Text(
                  series.metric.label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: series.metric.color,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              series.sum.toInt().toString(),
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 16,
                color: series.metric.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isUp
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: isUp ? C.red : C.green,
                  size: 10,
                ),
                const SizedBox(width: 3),
                Text(
                  '${trend.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    color: isUp ? C.red : C.green,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'avg ${series.avg.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.mutedLt,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
