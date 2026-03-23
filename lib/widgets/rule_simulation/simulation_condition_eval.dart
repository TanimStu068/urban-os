import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/rule_simulation/condition_eval_row.dart';
import 'package:urban_os/widgets/rule_simulation/sim_panel.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';

typedef C = AppColors;

class SimulationConditionEval extends StatelessWidget {
  final AutomationRule? selectedRule;
  final bool condMet;
  final List<bool> condResults;
  final List<SimSensor> sensors;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;

  const SimulationConditionEval({
    super.key,
    required this.selectedRule,
    required this.condMet,
    required this.condResults,
    required this.sensors,
    required this.glowCtrl,
    required this.blinkCtrl,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedRule == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: Listenable.merge([glowCtrl, blinkCtrl]),
      builder: (_, __) => SimPanel(
        title: 'CONDITION EVALUATION',
        icon: Icons.rule_rounded,
        color: condMet ? C.green : C.mutedLt,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Overall result
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: condMet
                    ? C.green.withOpacity(0.08 + glowCtrl.value * 0.04)
                    : C.bgCard2.withOpacity(0.5),
                border: Border.all(
                  color: condMet
                      ? C.green.withOpacity(0.35 + glowCtrl.value * 0.1)
                      : C.gBdr,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: condMet
                          ? C.green.withOpacity(0.7 + blinkCtrl.value * 0.3)
                          : C.muted,
                      boxShadow: condMet
                          ? [
                              BoxShadow(
                                color: C.green.withOpacity(
                                  0.5 + blinkCtrl.value * 0.2,
                                ),
                                blurRadius: 8,
                              ),
                            ]
                          : [],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    condMet
                        ? 'CONDITIONS MET — RULE WILL FIRE'
                        : 'CONDITIONS NOT MET',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: condMet ? C.green : C.mutedLt,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color:
                          (selectedRule!.conditionLogic == 'AND'
                                  ? C.amber
                                  : C.violet)
                              .withOpacity(0.1),
                      border: Border.all(
                        color:
                            (selectedRule!.conditionLogic == 'AND'
                                    ? C.amber
                                    : C.violet)
                                .withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      selectedRule!.conditionLogic,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: selectedRule!.conditionLogic == 'AND'
                            ? C.amber
                            : C.violet,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            /// Condition rows
            ...List.generate(selectedRule!.conditions.length, (i) {
              final cond = selectedRule!.conditions[i];
              final met = i < condResults.length ? condResults[i] : false;
              final sensorVal = i < sensors.length ? sensors[i].value : 0.0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: CondEvalRow(
                  condition: cond,
                  currentValue: sensorVal,
                  met: met,
                  glowT: glowCtrl.value,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
