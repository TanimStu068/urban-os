import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_health_data_model.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/widgets/city_health/card.dart';
import 'package:urban_os/widgets/city_health/card_header.dart';
import 'package:urban_os/widgets/city_health/over_view_state.dart';

typedef C = AppColors;

class OverviewPanel extends StatelessWidget {
  final List<SensorModel> sensors;
  final List<AlertLog> alerts;
  final List<AutomationRule> rules;
  final AnimationController glowCtrl;
  const OverviewPanel({
    super.key,
    required this.sensors,
    required this.alerts,
    required this.rules,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final critSensors = sensors
        .where(
          (s) =>
              (s.type == SensorType.fireAlarm && s.val == 1) ||
              (s.type == SensorType.powerConsumption && s.val > 400),
        )
        .toList();
    final sensorsByType = <SensorType, List<SensorModel>>{};
    for (final s in sensors) {
      sensorsByType.putIfAbsent(s.type, () => []).add(s);
    }
    return CardWidget(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            title: 'SYSTEM OVERVIEW',
            icon: Icons.analytics_rounded,
            color: C.teal,
          ),

          // Critical sensor warnings
          if (critSensors.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: C.red.withOpacity(.06),
                border: Border.all(color: C.red.withOpacity(.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_rounded, color: C.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${critSensors.length} sensor(s) in critical state',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        color: C.red,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Sensor type breakdown
          ...sensorsByType.entries.take(6).map((e) {
            final avg =
                e.value.map((s) => s.val).fold(0.0, (a, b) => a + b) /
                e.value.length;
            final color = e.value.first.statusColor;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(
                    e.key.name.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      letterSpacing: 1.5,
                      color: color.withOpacity(.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Stack(
                        children: [
                          Container(height: 3, color: color.withOpacity(.1)),
                          FractionallySizedBox(
                            widthFactor: (avg / 500).clamp(0, 1),
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [color.withOpacity(.5), color],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '×${e.value.length}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: color,
                    ),
                  ),
                ],
              ),
            );
          }),

          Divider(height: 20, color: C.gBdr),

          // Automation status summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OverviewStat(
                value: '${rules.where((r) => r.isEnabled).length}',
                label: 'ACTIVE RULES',
                color: C.teal,
              ),
              OverviewStat(
                value: '${rules.where((r) => !r.isEnabled).length}',
                label: 'PAUSED RULES',
                color: C.muted,
              ),
              OverviewStat(
                value: '${alerts.where((a) => a.isActive).length}',
                label: 'OPEN ALERTS',
                color: C.amber,
              ),
              OverviewStat(
                value: '${alerts.where((a) => !a.isActive).length}',
                label: 'RESOLVED',
                color: C.teal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
