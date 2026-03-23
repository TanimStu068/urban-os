import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/energy_dashboard/alert_row.dart';
import 'package:urban_os/widgets/energy_dashboard/panel.dart';
import 'package:urban_os/widgets/energy_dashboard/alert_kpi.dart';
import 'package:urban_os/widgets/environment_dashboard/akpi.dart';

typedef C = AppColors;

class AlertsTab extends StatelessWidget {
  final List alerts;
  final int unackAlerts;
  final Animation<double> blinkAnimation;

  final VoidCallback onAcknowledgeAll;
  final Function(dynamic alert) onAcknowledge;

  const AlertsTab({
    super.key,
    required this.alerts,
    required this.unackAlerts,
    required this.blinkAnimation,
    required this.onAcknowledgeAll,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    final critical = alerts
        .where((a) => a.severity == C.red && !a.acknowledged)
        .length;

    final warning = alerts
        .where((a) => a.severity == C.amber && !a.acknowledged)
        .length;

    final info = alerts
        .where((a) => a.severity == C.yellow && !a.acknowledged)
        .length;

    final resolved = alerts.where((a) => a.acknowledged).length;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: [
          /// KPI ROW
          Row(
            children: [
              Expanded(child: AlertKpi('CRITICAL', '$critical', C.red)),
              const SizedBox(width: 8),
              Expanded(
                child: AKpi(
                  label: 'WARNING',
                  value: '$warning',
                  color: C.amber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AKpi(label: 'INFO', value: '$info', color: C.yellow),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AKpi(
                  label: 'RESOLVED',
                  value: '$resolved',
                  color: C.teal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// ACKNOWLEDGE ALL
          if (unackAlerts > 0) ...[
            GestureDetector(
              onTap: onAcknowledgeAll,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: C.teal.withOpacity(0.07),
                  border: Border.all(color: C.teal.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.done_all_rounded, color: C.teal, size: 14),
                    SizedBox(width: 8),
                    Text(
                      'ACKNOWLEDGE ALL ALERTS',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9.5,
                        color: C.teal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          /// ALERT LIST
          Panel(
            title: 'ENVIRONMENTAL ALERTS',
            icon: Icons.notifications_active_rounded,
            color: C.teal,
            child: Column(
              children: alerts
                  .map(
                    (a) => AnimatedBuilder(
                      animation: blinkAnimation,
                      builder: (_, __) => AlertRow(
                        alert: a,
                        blinkT: blinkAnimation.value,
                        onAck: () => onAcknowledge(a),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
