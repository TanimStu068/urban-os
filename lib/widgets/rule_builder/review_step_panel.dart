import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/automation_rule_builder_data_model.dart';
import 'package:urban_os/models/automation/rule_action.dart';
import 'package:urban_os/models/automation/rule_condition.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/widgets/rule_builder/category_tag.dart';
import 'package:urban_os/widgets/rule_builder/panel.dart';
import 'package:urban_os/widgets/rule_builder/priority_tag.dart';
import 'package:urban_os/widgets/rule_builder/review_row.dart';
import 'package:urban_os/widgets/rule_builder/review_section.dart';
import 'package:urban_os/widgets/rule_builder/step_header.dart';

typedef C = AppColors;

class ReviewStepPanel extends StatelessWidget {
  final AnimationController glowCtrl;

  final String name;
  final String district;
  final String description;
  final RuleCategory category;
  final RulePriority priority;
  final double cooldownSeconds;
  final bool scheduleEnabled;
  final bool oneShot;
  final String conditionLogic;
  final List<RuleCondition> conditions;
  final List<RuleAction> actions;

  const ReviewStepPanel({
    super.key,
    required this.glowCtrl,
    required this.name,
    required this.district,
    required this.description,
    required this.category,
    required this.priority,
    required this.cooldownSeconds,
    required this.scheduleEnabled,
    required this.oneShot,
    required this.conditionLogic,
    required this.conditions,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepHeader(
          step: BuilderStep.review,
          subtitle: 'Review all settings before saving.',
        ),
        const SizedBox(height: 20),

        // Summary card
        AnimatedBuilder(
          animation: glowCtrl,
          builder: (_, __) => Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  category.color.withOpacity(0.06),
                  C.bgCard.withOpacity(0.8),
                ],
              ),
              border: Border.all(
                color: category.color.withOpacity(0.25 + glowCtrl.value * 0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: category.color.withOpacity(0.1),
                    border: Border.all(color: category.color.withOpacity(0.3)),
                  ),
                  child: Icon(category.icon, color: category.color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: C.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          PriorityTag(priority),
                          const SizedBox(width: 6),
                          CategoryTag(category),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        district,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: C.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        if (description.isNotEmpty) ...[
          ReviewSection('DESCRIPTION', C.mutedLt, [description]),
          const SizedBox(height: 12),
        ],

        Panel(
          title: 'CONDITIONS (${conditions.length})  ·  $conditionLogic',
          icon: Icons.sensors_rounded,
          color: C.amber,
          child: Column(
            children: conditions.asMap().entries.map((e) {
              final c = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.amber.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${c.sensorId}  ${c.operatorType.symbol}  ${c.threshold.toStringAsFixed(c.threshold == c.threshold.toInt() ? 0 : 1)}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          color: C.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: c.isRequired
                            ? C.amber.withOpacity(0.08)
                            : C.muted.withOpacity(0.05),
                      ),
                      child: Text(
                        c.isRequired ? 'REQUIRED' : 'OPTIONAL',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          color: c.isRequired ? C.amber : C.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        Panel(
          title: 'ACTIONS (${actions.length})',
          icon: Icons.settings_remote_rounded,
          color: C.green,
          child: Column(
            children: actions.map((a) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.green.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${a.actuatorId ?? '—'}  →  ${a.type.displayName}${a.targetValue != null ? ' (${a.targetValue!.toStringAsFixed(0)}%)' : ''}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          color: C.white,
                        ),
                      ),
                    ),
                    if (!a.isEnabled)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: C.muted.withOpacity(0.1),
                        ),
                        child: const Text(
                          'DISABLED',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7,
                            color: C.muted,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        Panel(
          title: 'EXECUTION SETTINGS',
          icon: Icons.tune_rounded,
          color: C.violet,
          child: Column(
            children: [
              ReviewRow('PRIORITY', priority.label, priority.color),
              ReviewRow('DISTRICT', district, C.mutedLt),
              ReviewRow('COOLDOWN', '${cooldownSeconds}s', C.amber),
              ReviewRow(
                'SCHEDULE',
                scheduleEnabled ? 'ENABLED' : 'ALWAYS',
                scheduleEnabled ? C.sky : C.muted,
              ),
              ReviewRow(
                'ONE-SHOT',
                oneShot ? 'YES' : 'NO',
                oneShot ? C.violet : C.muted,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
