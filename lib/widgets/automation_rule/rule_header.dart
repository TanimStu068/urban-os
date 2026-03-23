import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/widgets/automation_rule/priority_badge.dart';
import 'package:urban_os/widgets/automation_rule/status_badge.dart';

typedef C = AppColors;

class RuleHeader extends StatelessWidget {
  final AutomationRule rule;
  final Color col;
  final Color statCol;
  final bool isAlert;
  final bool isExpanded;
  final double blinkT;
  final VoidCallback onToggle;

  const RuleHeader({
    super.key,
    required this.rule,
    required this.col,
    required this.statCol,
    required this.isAlert,
    required this.isExpanded,
    required this.blinkT,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 11, 10, 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3.5,
            height: 46,
            margin: const EdgeInsets.only(right: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: col,
              boxShadow: [BoxShadow(color: col, blurRadius: 6)],
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: rule.category!.color.withOpacity(0.1),
              border: Border.all(color: rule.category!.color.withOpacity(0.35)),
            ),
            child: Icon(
              rule.category!.icon,
              color: rule.category!.color,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      rule.id,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        color: rule.category!.color,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 7),
                    PriorityBadge(rule.priority, blinkT),
                    const SizedBox(width: 5),
                    StatusBadge(rule.status, blinkT, isCompact: true),
                    if (rule.isSystem) ...[
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: C.cyan.withOpacity(0.08),
                          border: Border.all(color: C.cyan.withOpacity(0.25)),
                        ),
                        child: const Text(
                          'SYS',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 6.5,
                            color: C.cyan,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  rule.name,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: C.white,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: C.muted,
                      size: 10,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      rule.district,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7.5,
                        color: C.muted,
                      ),
                    ),
                    if (rule.lastTriggered != null) ...[
                      const SizedBox(width: 10),
                      Icon(
                        Icons.flash_on_rounded,
                        color: statCol.withOpacity(0.7),
                        size: 10,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        rule.lastTriggered!,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7.5,
                          color: statCol.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onToggle,
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: rule.isEnabled
                        ? C.green.withOpacity(0.18)
                        : C.bgCard2,
                    border: Border.all(
                      color: rule.isEnabled
                          ? C.green.withOpacity(0.55)
                          : C.muted.withOpacity(0.3),
                    ),
                  ),
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        left: rule.isEnabled ? 20 : 2,
                        top: 3,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: rule.isEnabled ? C.green : C.mutedLt,
                            boxShadow: rule.isEnabled
                                ? [
                                    BoxShadow(
                                      color: C.green.withOpacity(0.5),
                                      blurRadius: 5,
                                    ),
                                  ]
                                : [],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${rule.triggerCount}×',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  color: C.mutedLt,
                ),
              ),
              const SizedBox(height: 6),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: C.mutedLt,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
