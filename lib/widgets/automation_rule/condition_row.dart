import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/rule_condition.dart';

typedef C = AppColors;

class ConditionRow extends StatelessWidget {
  final RuleCondition condition;
  final double glowT;
  const ConditionRow({super.key, required this.condition, required this.glowT});
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: C.amber.withOpacity(0.04),
      border: Border.all(color: C.amber.withOpacity(0.15 + glowT * 0.04)),
    ),
    child: Row(
      children: [
        Icon(Icons.sensors_rounded, color: C.amber.withOpacity(0.6), size: 12),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: condition.sensorId,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8.5,
                    color: C.white,
                  ),
                ),
                TextSpan(
                  text: '  ${condition.operatorType.symbol}  ',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: C.amber,
                  ),
                ),
                TextSpan(
                  text:
                      '${condition.threshold.toStringAsFixed(condition.threshold == condition.threshold.toInt() ? 0 : 1)}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: C.amber,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: C.muted.withOpacity(0.1),
            border: Border.all(color: C.muted.withOpacity(0.2)),
          ),
          child: Text(
            condition.sensorId,
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
