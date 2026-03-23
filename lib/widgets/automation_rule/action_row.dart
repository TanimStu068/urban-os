import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/rule_action.dart';

typedef C = AppColors;

class ActionRow extends StatelessWidget {
  final RuleAction action;
  final double glowT;
  const ActionRow({super.key, required this.action, required this.glowT});
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: C.green.withOpacity(0.04),
      border: Border.all(color: C.green.withOpacity(0.15 + glowT * 0.04)),
    ),
    child: Row(
      children: [
        Icon(
          Icons.settings_remote_rounded,
          color: C.green.withOpacity(0.6),
          size: 12,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: action.actuatorId ?? '',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8.5,
                    color: C.white,
                  ),
                ),
                const TextSpan(
                  text: '  →  ',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    color: C.mutedLt,
                  ),
                ),
                TextSpan(
                  text: action.type.displayName,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    color: C.green,
                  ),
                ),
                if (action.targetValue != null)
                  TextSpan(
                    text: '  (${action.targetValue!.toStringAsFixed(0)}%)',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: C.teal,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (action.actuatorId != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: C.muted.withOpacity(0.1),
              border: Border.all(color: C.muted.withOpacity(0.2)),
            ),
            child: Text(
              action.actuatorId!,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 6.5,
                color: C.mutedLt,
              ),
            ),
          ),
      ],
    ),
  );
}
