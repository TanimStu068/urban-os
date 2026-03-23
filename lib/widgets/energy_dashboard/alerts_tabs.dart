import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';
import 'package:urban_os/widgets/energy_dashboard/alert_detail_row.dart';
import 'package:urban_os/widgets/energy_dashboard/alert_kpi.dart';

typedef C = AppColors;

class AlertsTab extends StatefulWidget {
  final List<EnergyAlert> alerts;
  final int unackAlerts;
  final AnimationController blinkController;

  const AlertsTab({
    super.key,
    required this.alerts,
    required this.unackAlerts,
    required this.blinkController,
  });

  @override
  State<AlertsTab> createState() => _AlertsTabState();
}

class _AlertsTabState extends State<AlertsTab> {
  void _ackAll() {
    setState(() {
      for (final a in widget.alerts) {
        a.acknowledged = true;
      }
    });
  }

  void _ackOne(EnergyAlert alert) {
    setState(() {
      alert.acknowledged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final alerts = widget.alerts;
    final unack = widget.unackAlerts;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔴 KPI Row
          Row(
            children: [
              Expanded(
                child: AlertKpi(
                  'CRITICAL',
                  '${alerts.where((a) => a.level == AlertLevel.critical).length}',
                  C.red,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AlertKpi(
                  'WARNING',
                  '${alerts.where((a) => a.level == AlertLevel.warning).length}',
                  C.amber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AlertKpi(
                  'INFO',
                  '${alerts.where((a) => a.level == AlertLevel.info).length}',
                  C.cyan,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AlertKpi('UNACK', '$unack', unack > 0 ? C.red : C.green),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ✅ ACK ALL
          if (unack > 0) ...[
            GestureDetector(
              onTap: _ackAll,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: C.amber.withOpacity(0.08),
                  border: Border.all(color: C.amber.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.done_all_rounded, color: C.amber, size: 14),
                    SizedBox(width: 8),
                    Text(
                      'ACKNOWLEDGE ALL ALERTS',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9.5,
                        color: C.amber,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          /// 🔔 ALERT LIST
          Panel(
            title: 'ALL ALERTS',
            icon: Icons.notifications_rounded,
            color: C.red,
            child: Column(
              children: alerts
                  .map(
                    (a) => AnimatedBuilder(
                      animation: widget.blinkController,
                      builder: (_, __) => AlertDetailRow(
                        alert: a,
                        blinkT: widget.blinkController.value,
                        onAck: () => _ackOne(a),
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
