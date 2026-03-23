import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/widgets/automation_rule/action_row.dart';
import 'package:urban_os/widgets/automation_rule/card_btn.dart';
import 'package:urban_os/widgets/automation_rule/condition_row.dart';
import 'package:urban_os/widgets/automation_rule/ifthen_level.dart';
import 'package:urban_os/widgets/automation_rule/meta_row.dart';
import 'package:urban_os/widgets/automation_rule/spark_bar_painter.dart';

typedef C = AppColors;

class RuleExpandedBody extends StatelessWidget {
  final AutomationRule rule;
  final double glowT;
  final VoidCallback onEdit;
  final VoidCallback onTest;
  final VoidCallback onSimulate;
  final VoidCallback onDuplicate;
  final VoidCallback onExecute;
  final VoidCallback onDelete;

  const RuleExpandedBody({
    super.key,
    required this.rule,
    required this.glowT,
    required this.onEdit,
    required this.onTest,
    required this.onSimulate,
    required this.onDuplicate,
    required this.onExecute,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: C.gBdr)),
        color: C.bgCard2.withOpacity(0.3),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rule.description != null && rule.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                rule.description!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8.5,
                  color: C.mutedLt,
                  height: 1.5,
                ),
              ),
            ),
          const SizedBox(height: 12),

          // IF block
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IfThenLabel('IF', C.amber, Icons.help_outline_rounded),
                const SizedBox(height: 7),
                ...List.generate(rule.conditions.length, (i) {
                  final cond = rule.conditions[i];
                  return Column(
                    children: [
                      ConditionRow(condition: cond, glowT: glowT),
                      if (i < rule.conditions.length - 1) ...[
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: C.amber.withOpacity(0.08),
                                border: Border.all(
                                  color: C.amber.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                rule.conditionLogic.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 8,
                                  color: C.amber,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // THEN block
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IfThenLabel('THEN', C.green, Icons.play_arrow_rounded),
                const SizedBox(height: 7),
                ...rule.actions.map(
                  (a) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: ActionRow(action: a, glowT: glowT),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Spark + meta
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '7-DAY TRIGGER HISTORY',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          letterSpacing: 1.5,
                          color: C.muted,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 42,
                        child: CustomPaint(
                          painter: SparkBarPainter(
                            data: rule.triggerHistory
                                .map((e) => e.toDouble())
                                .toList(),
                            color: rule.priority.color,
                            glowT: glowT,
                          ),
                          size: const Size(double.infinity, 42),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (rule.createdBy != null)
                      MetaRow('CREATED BY', rule.createdBy!),
                    if (rule.lastModified != null)
                      MetaRow('MODIFIED', rule.lastModified!),
                    MetaRow('PRIORITY', rule.priority.label),
                    MetaRow(
                      'CONDITIONS',
                      '${rule.conditions.length}  ${rule.conditionLogic.toUpperCase()}',
                    ),
                    MetaRow('ACTIONS', '${rule.actions.length}'),
                    if (rule.cooldownPeriod != null)
                      MetaRow('COOLDOWN', '${rule.cooldownPeriod!.inSeconds}s'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    CardBtn('EDIT', Icons.edit_rounded, C.cyan, onEdit),
                    const SizedBox(width: 6),
                    CardBtn('TEST', Icons.science_rounded, C.violet, onTest),
                    const SizedBox(width: 6),
                    CardBtn(
                      'SIMULATE',
                      Icons.play_circle_outline_rounded,
                      C.sky,
                      onSimulate,
                    ),
                    const SizedBox(width: 6),
                    CardBtn('CLONE', Icons.copy_rounded, C.teal, onDuplicate),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    CardBtn('EXECUTE', Icons.bolt_rounded, C.amber, onExecute),
                    const SizedBox(width: 6),
                    CardBtn(
                      'DELETE',
                      Icons.delete_outline_rounded,
                      C.red,
                      onDelete,
                      enabled: !rule.isSystem,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
