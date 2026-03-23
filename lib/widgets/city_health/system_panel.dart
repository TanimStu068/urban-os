import 'package:flutter/material.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/infrastructure/building_model.dart';
import 'package:urban_os/models/infrastructure/road_model.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/widgets/city_health/over_view_panel.dart';
import 'package:urban_os/widgets/city_health/sensor_panel.dart';
import 'package:urban_os/widgets/city_health/infra_panel.dart';
import 'package:urban_os/widgets/city_health/alerts_panel.dart';

class SystemPanel extends StatelessWidget {
  final int tab;
  final List<SensorModel> sensors;
  final List<AlertLog> alerts;
  final List<AutomationRule> rules;
  final List<BuildingModel> buildings;
  final List<RoadModel> roads;
  final double infraHealth, congestion, bldRisk;
  final AnimationController glowCtrl, alertCtrl;

  const SystemPanel({
    super.key,
    required this.tab,
    required this.sensors,
    required this.alerts,
    required this.rules,
    required this.buildings,
    required this.roads,
    required this.infraHealth,
    required this.congestion,
    required this.bldRisk,
    required this.glowCtrl,
    required this.alertCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: switch (tab) {
        0 => OverviewPanel(
          key: const ValueKey(0),
          sensors: sensors,
          alerts: alerts,
          rules: rules,
          glowCtrl: glowCtrl,
        ),
        1 => SensorsPanel(
          key: const ValueKey(1),
          sensors: sensors,
          glowCtrl: glowCtrl,
        ),
        2 => InfraPanel(
          key: const ValueKey(2),
          infraHealth: infraHealth,
          congestion: congestion,
          bldRisk: bldRisk,
          buildings: buildings,
          roads: roads,
        ),
        _ => AlertsPanel(
          key: const ValueKey(3),
          alerts: alerts,
          alertCtrl: alertCtrl,
        ),
      },
    );
  }
}
