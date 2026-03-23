import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/rule_simulation/sim_panel.dart';
import 'package:urban_os/widgets/rule_simulation/actuator_card.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';

typedef C = AppColors;

class SimulationActuatorPanel extends StatelessWidget {
  final List<SimActuator> actuators;
  final bool ruleFired;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;

  const SimulationActuatorPanel({
    super.key,
    required this.actuators,
    required this.ruleFired,
    required this.glowCtrl,
    required this.blinkCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SimPanel(
      title: 'ACTUATOR STATES',
      icon: Icons.settings_remote_rounded,
      color: ruleFired ? C.violet : C.mutedLt,
      badge: ruleFired ? 'ACTIVE' : 'STANDBY',
      badgeColor: ruleFired ? C.violet : C.muted,
      child: AnimatedBuilder(
        animation: Listenable.merge([glowCtrl, blinkCtrl]),
        builder: (_, __) => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: actuators
              .map(
                (a) => ActuatorCard(
                  actuator: a,
                  glowT: glowCtrl.value,
                  blinkT: blinkCtrl.value,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
