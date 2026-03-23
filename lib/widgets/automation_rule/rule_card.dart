import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/widgets/automation_rule/rule_expanded_body.dart';
import 'package:urban_os/widgets/automation_rule/rule_header.dart';

typedef C = AppColors;

class RuleCard extends StatelessWidget {
  final AutomationRule rule;
  final bool isExpanded;
  final double glowT, blinkT, pulseT;
  final VoidCallback onTap,
      onToggle,
      onDelete,
      onDuplicate,
      onTest,
      onEdit,
      onExecute,
      onSimulate;

  const RuleCard({
    super.key,
    required this.rule,
    required this.isExpanded,
    required this.glowT,
    required this.blinkT,
    required this.pulseT,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
    required this.onDuplicate,
    required this.onTest,
    required this.onEdit,
    required this.onExecute,
    required this.onSimulate,
  });

  @override
  Widget build(BuildContext ctx) {
    final col = rule.priority.color;
    final statCol = rule.status.color;
    final isAlert =
        rule.status == RuleStatus.triggered || rule.status == RuleStatus.error;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.bgCard.withOpacity(0.92),
          border: Border.all(
            color: isExpanded
                ? col.withOpacity(0.4 + glowT * 0.1)
                : isAlert
                ? statCol.withOpacity(0.2 + blinkT * 0.1)
                : C.gBdr,
            width: isExpanded ? 1.3 : 1,
          ),
          boxShadow: isExpanded
              ? [BoxShadow(color: col.withOpacity(0.08), blurRadius: 20)]
              : isAlert
              ? [
                  BoxShadow(
                    color: statCol.withOpacity(0.04 + blinkT * 0.02),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            RuleHeader(
              rule: rule,
              col: col,
              statCol: statCol,
              isAlert: isAlert,
              isExpanded: isExpanded,
              blinkT: blinkT,
              onToggle: onToggle,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? RuleExpandedBody(
                      rule: rule,
                      glowT: glowT,
                      onEdit: onEdit,
                      onTest: onTest,
                      onSimulate: onSimulate,
                      onDuplicate: onDuplicate,
                      onExecute: onExecute,
                      onDelete: onDelete,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
