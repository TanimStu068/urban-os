import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/emergency_control_data_model.dart';
import 'package:urban_os/widgets/emergency_control/alert_card.dart'; // your alert model import

class AlertList extends StatelessWidget {
  final ScrollController scrollCtrl;
  final List<EmergencyAlert> filteredAlerts;
  final Set<String> expandedAlerts;
  final Function(String) onToggleExpanded;
  final AnimationController glowCtrl;

  const AlertList({
    Key? key,
    required this.scrollCtrl,
    required this.filteredAlerts,
    required this.expandedAlerts,
    required this.onToggleExpanded,
    required this.glowCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: filteredAlerts
            .map(
              (alert) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AlertCard(
                  alert: alert,
                  isExpanded: expandedAlerts.contains(alert.id),
                  onTap: () => onToggleExpanded(alert.id),
                  glowCtrl: glowCtrl,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
