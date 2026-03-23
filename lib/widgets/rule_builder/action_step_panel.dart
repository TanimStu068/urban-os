import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/automation_rule_builder_data_model.dart';
import 'package:urban_os/providers/automation/automation_provider.dart';
import 'package:urban_os/widgets/rule_builder/action_editor.dart';
import 'package:urban_os/widgets/rule_builder/add_button.dart';
import 'package:urban_os/widgets/rule_builder/step_header.dart';

typedef C = AppColors;

class ActionsStepPanel extends StatefulWidget {
  final AnimationController glowCtrl;
  final List<DraftAction> initialActions;

  const ActionsStepPanel({
    super.key,
    required this.glowCtrl,
    this.initialActions = const [],
  });

  @override
  State<ActionsStepPanel> createState() => _ActionsStepPanelState();
}

class _ActionsStepPanelState extends State<ActionsStepPanel> {
  late List<DraftAction> _actions;

  @override
  void initState() {
    super.initState();
    _actions = List<DraftAction>.from(
      widget.initialActions.isNotEmpty
          ? widget.initialActions
          : [DraftAction(id: _uid())],
    );
  }

  String _uid() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepHeader(
          step: BuilderStep.actions,
          subtitle:
              'Choose actuators and commands to execute when conditions are met.',
        ),
        const SizedBox(height: 20),
        Consumer<AutomationProvider>(
          builder: (_, provider, __) {
            final actuators = provider.actuators;
            final actuatorIds = actuators.isNotEmpty
                ? actuators.map((a) => a.id).toList()
                : actuatorOptions;

            return Column(
              children: [
                ..._actions.asMap().entries.map((e) {
                  final idx = e.key;
                  final action = e.value;
                  return Column(
                    children: [
                      ActionEditor(
                        action: action,
                        index: idx,
                        actuatorOptions: actuatorIds,
                        glowT: widget.glowCtrl.value,
                        onChanged: () => setState(() {}),
                        onRemove: _actions.length > 1
                            ? () => setState(() => _actions.removeAt(idx))
                            : null,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
                AddButton(
                  label: 'ADD ACTION',
                  icon: Icons.add_circle_outline_rounded,
                  color: C.green,
                  onTap: () =>
                      setState(() => _actions.add(DraftAction(id: _uid()))),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
