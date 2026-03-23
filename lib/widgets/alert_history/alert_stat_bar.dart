import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/alert_history_data_model.dart';

typedef C = AppColors;

class AlertsStatsBar extends StatelessWidget {
  final AlertStatistics stats;

  const AlertsStatsBar({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: C.bgCard.withOpacity(0.85),
        border: Border.all(color: C.red.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatItem('TOTAL', '${stats.totalAlerts}', C.cyan),
          _StatItem('ACTIVE', '${stats.activeAlerts}', C.orange),
          _StatItem('CRITICAL', '${stats.criticalAlerts}', C.red),
          _StatItem('RESOLVED', '${stats.resolvedToday}', C.green),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: C.mutedLt,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
