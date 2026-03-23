import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/automation/rule_priority.dart';

typedef C = AppColors;

class RuleBuilderHeader extends StatelessWidget {
  final AutomationRule? existingRule;
  final String name;
  final RuleCategory category;
  final VoidCallback onBack;

  const RuleBuilderHeader({
    super.key,
    this.existingRule,
    required this.name,
    required this.category,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: C.gBdr)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: C.bgCard2,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: C.gBdr),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: C.mutedLt,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existingRule != null
                      ? 'EDIT RULE  ·  ${existingRule!.id}'
                      : 'AUTOMATION RULE BUILDER',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    color: C.mutedLt,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name.isEmpty ? 'Untitled Rule' : name,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: C.white,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: category.color.withOpacity(0.1),
              border: Border.all(color: category.color.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(category.icon, color: category.color, size: 12),
                const SizedBox(width: 5),
                Text(
                  category.label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    color: category.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
