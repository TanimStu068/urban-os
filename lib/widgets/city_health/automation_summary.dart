import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/widgets/city_health/empty_state.dart';
import 'package:urban_os/widgets/city_health/auto_state.dart';
import 'package:urban_os/widgets/city_health/card.dart';
import 'package:urban_os/widgets/city_health/card_header.dart';

typedef C = AppColors;

class AutomationSummary extends StatelessWidget {
  final List<AutomationRule> rules;
  final List events;
  final AnimationController glowCtrl;
  const AutomationSummary({
    super.key,
    required this.rules,
    required this.events,
    required this.glowCtrl,
  });

  Color _ruleColor(AutomationRule r) {
    switch (r.priority.name.toLowerCase()) {
      case 'critical':
        return C.red;
      case 'high':
        return C.amber;
      case 'medium':
        return C.cyan;
      default:
        return C.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = rules.where((r) => r.isEnabled).toList();
    final paused = rules.where((r) => !r.isEnabled).toList();
    final visible = [...active, ...paused].take(6).toList();

    return CardWidget(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            title: 'AUTOMATION ENGINE',
            icon: Icons.auto_fix_high_rounded,
            color: C.green,
          ),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AutoStat(
                value: '${active.length}',
                label: 'ACTIVE',
                color: C.teal,
              ),
              AutoStat(
                value: '${paused.length}',
                label: 'PAUSED',
                color: C.muted,
              ),
              AutoStat(value: '${rules.length}', label: 'TOTAL', color: C.cyan),
              AutoStat(
                value:
                    '${rules.where((r) => r.priority.name.toLowerCase() == "critical").length}',
                label: 'CRITICAL',
                color: C.red,
              ),
            ],
          ),

          Divider(height: 18, color: C.gBdr),

          if (visible.isEmpty)
            EmptyState(
              icon: Icons.settings_rounded,
              message: 'No rules configured',
            )
          else
            ...visible.map((rule) {
              final col = _ruleColor(rule);
              return AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: col.withOpacity(.04),
                    border: Border.all(
                      color: rule.isEnabled
                          ? col.withOpacity(.15 + glowCtrl.value * .07)
                          : C.gBdr,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: rule.isEnabled
                              ? col.withOpacity(.5 + glowCtrl.value * .5)
                              : C.muted.withOpacity(.3),
                          boxShadow: rule.isEnabled
                              ? [
                                  BoxShadow(
                                    color: col.withOpacity(.4 * glowCtrl.value),
                                    blurRadius: 5,
                                  ),
                                ]
                              : [],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rule.description!,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9,
                                color: rule.isEnabled ? C.white : C.muted,
                                letterSpacing: .3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              rule.priority.name.toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 7,
                                letterSpacing: 1.5,
                                color: col.withOpacity(.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: rule.isEnabled
                              ? col.withOpacity(.1)
                              : C.muted.withOpacity(.08),
                          border: Border.all(
                            color: rule.isEnabled
                                ? col.withOpacity(.3)
                                : C.muted.withOpacity(.2),
                          ),
                        ),
                        child: Text(
                          rule.isEnabled ? 'ACTIVE' : 'PAUSED',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 6,
                            letterSpacing: 1.5,
                            color: rule.isEnabled ? col : C.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
