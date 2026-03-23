import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/rule_simulation/sensor_input_row.dart';
import 'package:urban_os/widgets/rule_simulation/sim_panel.dart';

typedef C = AppColors;

class SensorPanel extends StatelessWidget {
  final List sensors;
  final List<bool> condResults;
  final bool condMet;
  final double glowT;
  final double blinkT;

  final Function(int index, double value) onValueChanged;
  final Function(int index) onOverrideToggled;

  const SensorPanel({
    super.key,
    required this.sensors,
    required this.condResults,
    required this.condMet,
    required this.glowT,
    required this.blinkT,
    required this.onValueChanged,
    required this.onOverrideToggled,
  });

  @override
  Widget build(BuildContext context) {
    return SimPanel(
      title: 'SENSOR INPUTS',
      icon: Icons.sensors_rounded,
      color: C.amber,
      badge:
          '${condResults.where((r) => r).length} / ${condResults.length} MET',
      badgeColor: condMet ? C.green : C.muted,
      child: Column(
        children: List.generate(sensors.length, (i) {
          final s = sensors[i];
          final condMetLocal = i < condResults.length ? condResults[i] : false;

          return SensorInputRow(
            sensor: s,
            condMet: condMetLocal,
            glowT: glowT,
            blinkT: blinkT,
            onValueChanged: (v) => onValueChanged(i, v),
            onOverrideToggled: () => onOverrideToggled(i),
          );
        }),
      ),
    );
  }
}
