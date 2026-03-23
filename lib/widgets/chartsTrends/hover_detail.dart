import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/charts_trends_datamodel.dart';

typedef C = AppColors;

class HoverDetailWidget extends StatelessWidget {
  final List<SeriesData> activeSeries;
  final int? hoverBucket;
  final TrendPeriod period;

  const HoverDetailWidget({
    super.key,
    required this.activeSeries,
    required this.hoverBucket,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    if (hoverBucket == null) return const SizedBox(height: 8);
    final b = hoverBucket!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: C.bgCard2,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: C.cyan.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BUCKET $b  ·  ${period.index < 2 ? 'HOUR' : 'DAY'} DETAIL',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: C.cyan,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: activeSeries.map((s) {
                final val = b < s.points.length ? s.points[b].value : 0.0;
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: s.metric.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            s.metric.label,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: s.metric.color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        val.toInt().toString(),
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 14,
                          color: s.metric.color,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
