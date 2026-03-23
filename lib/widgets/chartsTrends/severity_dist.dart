import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/widgets/chartsTrends/donut_painter.dart';

typedef C = AppColors;

class SeverityDistributionWidget extends StatelessWidget {
  final LogProvider logProvider;

  const SeverityDistributionWidget({super.key, required this.logProvider});

  @override
  Widget build(BuildContext context) {
    // Compute counts
    final counts = <RulePriority, int>{};
    for (final p in RulePriority.values) counts[p] = 0;
    for (final a in logProvider.alerts) {
      counts[a.severity] = (counts[a.severity] ?? 0) + 1;
    }
    if (counts.values.every((v) => v == 0)) {
      // Demo fallback
      counts[RulePriority.critical] = 3;
      counts[RulePriority.high] = 8;
      counts[RulePriority.medium] = 15;
      counts[RulePriority.low] = 22;
    }

    final total = counts.values.fold(0, (a, b) => a + b);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: C.gBdr),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ALERT SEVERITY DISTRIBUTION',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: C.mutedLt,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 130,
              child: CustomPaint(
                painter: DonutPainter(
                  counts.entries
                      .map(
                        (e) => Slice(e.key.color, e.value / total, e.key.label),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: counts.entries.map((e) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: e.key.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${e.key.label}  ${e.value}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7.5,
                        color: e.key.color,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
