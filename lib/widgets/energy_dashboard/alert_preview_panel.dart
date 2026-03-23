import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/energy_dashboard/alert_row.dart';
import 'package:urban_os/widgets/energy_dashboard/panel.dart';

typedef C = AppColors;

class AlertPreviewPanel extends StatelessWidget {
  final List<EnergyAlert> alerts;
  final int unackAlerts;
  final Animation<double> blinkAnimation;
  final void Function(EnergyAlert) onAck;

  const AlertPreviewPanel({
    super.key,
    required this.alerts,
    required this.unackAlerts,
    required this.blinkAnimation,
    required this.onAck,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'RECENT ALERTS',
      icon: Icons.notifications_active_rounded,
      color: C.red,
      badge: '$unackAlerts UNACK',
      badgeColor: unackAlerts > 0 ? C.red : C.muted,
      child: Column(
        children: alerts.take(3).map((a) {
          return AnimatedBuilder(
            animation: blinkAnimation,
            builder: (_, __) => AlertRow(
              alert: a,
              blinkT: blinkAnimation.value,
              onAck: () => onAck(a),
            ),
          );
        }).toList(),
      ),
    );
  }
}
