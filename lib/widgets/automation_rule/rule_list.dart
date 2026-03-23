import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/widgets/automation_rule/rule_card.dart';

typedef C = AppColors;

class RuleListView extends StatelessWidget {
  final List<AutomationRule> rules;
  final String? expandedId;
  final ScrollController scrollController;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;
  final AnimationController pulseCtrl;

  // Callbacks
  final void Function(AutomationRule) onToggle;
  final void Function(AutomationRule) onDelete;
  final void Function(AutomationRule) onDuplicate;
  final void Function(AutomationRule) onTest;
  final void Function(AutomationRule) onExecute;
  final void Function(AutomationRule) onEdit;
  final void Function(AutomationRule) onSimulate;
  final void Function(String?) onExpandChange;

  const RuleListView({
    super.key,
    required this.rules,
    required this.expandedId,
    required this.scrollController,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.pulseCtrl,
    required this.onToggle,
    required this.onDelete,
    required this.onDuplicate,
    required this.onTest,
    required this.onExecute,
    required this.onEdit,
    required this.onSimulate,
    required this.onExpandChange,
  });

  @override
  Widget build(BuildContext context) {
    if (rules.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, color: C.muted, size: 36),
            const SizedBox(height: 10),
            const Text(
              'No rules match filters',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: C.muted,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: rules.length,
      itemBuilder: (ctx, i) => AnimatedBuilder(
        animation: Listenable.merge([glowCtrl, blinkCtrl, pulseCtrl]),
        builder: (_, __) => RuleCard(
          rule: rules[i],
          isExpanded: rules[i].id == expandedId,
          glowT: glowCtrl.value,
          blinkT: blinkCtrl.value,
          pulseT: pulseCtrl.value,
          onTap: () =>
              onExpandChange(rules[i].id == expandedId ? null : rules[i].id),
          onToggle: () => onToggle(rules[i]),
          onDelete: () => onDelete(rules[i]),
          onDuplicate: () => onDuplicate(rules[i]),
          onTest: () => onTest(rules[i]),
          onExecute: () => onExecute(rules[i]),
          onEdit: () => onEdit(rules[i]),
          onSimulate: () => onSimulate(rules[i]),
        ),
      ),
    );
  }
}
