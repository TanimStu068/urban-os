import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/emergency_control_data_model.dart';

typedef C = AppColors;

class CriticalAlertCard extends StatelessWidget {
  final List<EmergencyAlert> alerts;
  final AnimationController glowCtrl;

  const CriticalAlertCard({
    super.key,
    required this.alerts,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    // Filter critical alerts that are not completed
    final critical = alerts
        .where(
          (a) =>
              a.severity == AlertSeverity.critical &&
              a.status != DispatchStatus.completed,
        )
        .toList();

    if (critical.isEmpty) return const SizedBox.shrink();

    final alert = critical.first;

    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) => Container(
        margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [C.red.withOpacity(0.15), C.orange.withOpacity(0.05)],
          ),
          border: Border.all(
            color: C.red.withOpacity(0.4 + glowCtrl.value * 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: C.red.withOpacity(0.2 + glowCtrl.value * 0.15),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(alert.type.icon, color: C.red, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.title.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: C.red,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    alert.location,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: C.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: C.red.withOpacity(0.2),
                border: Border.all(color: C.red.withOpacity(0.4)),
              ),
              child: Text(
                alert.eta,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: C.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
