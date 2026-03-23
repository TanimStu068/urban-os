import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/automation_rule_builder_data_model.dart';
import 'package:urban_os/widgets/rule_builder/add_button.dart';
import 'package:urban_os/widgets/rule_builder/condition_editor.dart';
import 'package:urban_os/widgets/rule_builder/step_header.dart';

typedef C = AppColors;

class ConditionsStepPanel extends StatefulWidget {
  final AnimationController glowCtrl;
  final String initialLogic;
  final List<DraftCondition> initialConditions;

  const ConditionsStepPanel({
    super.key,
    required this.glowCtrl,
    this.initialLogic = 'AND',
    this.initialConditions = const [],
  });

  @override
  State<ConditionsStepPanel> createState() => _ConditionsStepPanelState();
}

class _ConditionsStepPanelState extends State<ConditionsStepPanel> {
  late List<DraftCondition> _conditions;
  late String _conditionLogic;

  @override
  void initState() {
    super.initState();
    _conditionLogic = widget.initialLogic;
    _conditions = List<DraftCondition>.from(
      widget.initialConditions.isNotEmpty
          ? widget.initialConditions
          : [DraftCondition(id: _uid())],
    );
  }

  String _uid() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepHeader(
          step: BuilderStep.conditions,
          subtitle:
              'Define sensor conditions. Rule fires when conditions are ${_conditionLogic == 'AND' ? 'ALL' : 'ANY'} met.',
        ),
        const SizedBox(height: 16),

        // Logic badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: (_conditionLogic == 'AND' ? C.amber : C.violet).withOpacity(
              0.08,
            ),
            border: Border.all(
              color: (_conditionLogic == 'AND' ? C.amber : C.violet)
                  .withOpacity(0.25),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: _conditionLogic == 'AND' ? C.amber : C.violet,
                size: 12,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Logic: $_conditionLogic — ${_conditionLogic == 'AND' ? 'All conditions must be satisfied' : 'At least one condition must be satisfied'}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8.5,
                    color: _conditionLogic == 'AND' ? C.amber : C.violet,
                  ),
                ),
              ),
            ],
          ),
        ),

        ..._conditions.asMap().entries.map((e) {
          final idx = e.key;
          final cond = e.value;
          return Column(
            children: [
              ConditionEditor(
                condition: cond,
                index: idx,
                sensorOptions: sensorOptions,
                glowT: widget.glowCtrl.value,
                onChanged: () => setState(() {}),
                onRemove: _conditions.length > 1
                    ? () => setState(() => _conditions.removeAt(idx))
                    : null,
              ),
              if (idx < _conditions.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: (_conditionLogic == 'AND' ? C.amber : C.violet)
                              .withOpacity(0.1),
                          border: Border.all(
                            color:
                                (_conditionLogic == 'AND' ? C.amber : C.violet)
                                    .withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _conditionLogic,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: _conditionLogic == 'AND'
                                ? C.amber
                                : C.violet,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(height: 10),
            ],
          );
        }).toList(),

        AddButton(
          label: 'ADD CONDITION',
          icon: Icons.add_circle_outline_rounded,
          color: C.amber,
          onTap: () =>
              setState(() => _conditions.add(DraftCondition(id: _uid()))),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
