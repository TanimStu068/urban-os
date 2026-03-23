import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_dashboard_data_model.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/screens/automation/automation_rule_list_screen.dart';
import 'package:urban_os/widgets/city_dashboard/section_header.dart';

typedef C = AppColors;

class AutomationStatus extends StatelessWidget {
  final List<AutomationRule> rules;
  final AnimationController glowCtrl;
  const AutomationStatus({
    super.key,
    required this.rules,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final activeCount = rules.where((r) => r.isEnabled).length;
    // Show top 5 rules
    final visible = rules.take(5).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.gBdr),
        color: C.bgCard.withOpacity(.85),
      ),
      child: Column(
        children: [
          SectionHeader(
            title: 'AUTOMATION ENGINE',
            sub: '$activeCount rules active',
            icon: Icons.auto_fix_high_rounded,
            color: C.green,
            trailing: null,
          ),

          if (visible.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'No automation rules configured',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: C.muted,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visible.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: C.gBdr),
              itemBuilder: (_, i) {
                final rule = visible[i];
                final active = rule.isEnabled;
                final color = ruleColor(rule, i);
                return AnimatedBuilder(
                  animation: glowCtrl,
                  builder: (_, __) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: active
                                ? color.withOpacity(.5 + glowCtrl.value * .5)
                                : C.muted,
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color: color.withOpacity(
                                        .5 * glowCtrl.value,
                                      ),
                                      blurRadius: 6,
                                    ),
                                  ]
                                : [],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            rule.description!,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              color: active ? C.white : C.muted,
                              letterSpacing: .3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: active
                                ? color.withOpacity(.1)
                                : C.muted.withOpacity(.1),
                            border: Border.all(
                              color: active
                                  ? color.withOpacity(.35)
                                  : C.muted.withOpacity(.2),
                            ),
                          ),
                          child: Text(
                            active ? 'ACTIVE' : 'PAUSED',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              letterSpacing: 1.5,
                              color: active ? color : C.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AutomationRuleListScreen(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 38,
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: C.gBdr),
                color: C.gBg,
              ),
              child: const Center(
                child: Text(
                  'MANAGE AUTOMATION RULES →',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    letterSpacing: 2,
                    color: C.mutedLt,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
