import 'package:flutter/material.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/widgets/rule_simulation/sim_panel.dart';

class RuleSelectorPanel extends StatelessWidget {
  final List<AutomationRule> rules;
  final AutomationRule? selectedRule;
  final Animation<double> glowAnimation;
  final ValueChanged<AutomationRule> onRuleSelected;

  const RuleSelectorPanel({
    super.key,
    required this.rules,
    required this.selectedRule,
    required this.glowAnimation,
    required this.onRuleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SimPanel(
      title: 'SELECT RULE',
      icon: Icons.account_tree_rounded,
      color: C.violet,
      child: rules.isEmpty
          ? const Text(
              'No rules loaded. Initialize the automation engine.',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                color: C.muted,
              ),
            )
          : SizedBox(
              height: 56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: rules.length,
                itemBuilder: (_, i) {
                  final rule = rules[i];
                  final isSel = selectedRule?.id == rule.id;
                  return GestureDetector(
                    onTap: () => onRuleSelected(rule),
                    child: AnimatedBuilder(
                      animation: glowAnimation,
                      builder: (_, __) => AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isSel
                              ? rule.category!.color.withOpacity(0.12)
                              : C.bgCard2.withOpacity(0.5),
                          border: Border.all(
                            color: isSel
                                ? rule.category!.color.withOpacity(
                                    0.45 + glowAnimation.value * 0.1,
                                  )
                                : C.gBdr,
                            width: isSel ? 1.3 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              rule.category!.icon,
                              color: rule.category!.color,
                              size: 13,
                            ),
                            const SizedBox(width: 7),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  rule.id,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 7,
                                    color: rule.category!.color,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  rule.name,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 8.5,
                                    fontWeight: isSel
                                        ? FontWeight.w800
                                        : FontWeight.normal,
                                    color: isSel ? C.white : C.mutedLt,
                                  ),
                                ),
                              ],
                            ),
                            if (isSel) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: rule.category!.color,
                                  boxShadow: [
                                    BoxShadow(
                                      color: rule.category!.color,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
