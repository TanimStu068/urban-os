import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/developer_panel_data_model.dart';

typedef C = AppColors;

class HealthBar extends StatelessWidget {
  final SystemHealthStatus healthStatus;
  final int errorCount;
  final int totalLogs;

  const HealthBar({
    super.key,
    required this.healthStatus,
    required this.errorCount,
    required this.totalLogs,
  });

  @override
  Widget build(BuildContext context) {
    final double healthValue = _calculateHealth();

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: C.bgCard.withOpacity(0.85),
        border: Border.all(color: C.cyan.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SYSTEM HEALTH',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: C.cyan,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                healthStatus.label,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  color: healthStatus.color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: healthValue,
                    minHeight: 6,
                    backgroundColor: C.red.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(healthStatus.color),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Percentage badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: healthStatus.color.withOpacity(0.15),
                ),
                child: Text(
                  '${(healthValue * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: healthStatus.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateHealth() {
    if (totalLogs == 0) return 1.0; // avoid division by zero
    return (1 - (errorCount / totalLogs * 0.4)).clamp(0, 1);
  }
}
