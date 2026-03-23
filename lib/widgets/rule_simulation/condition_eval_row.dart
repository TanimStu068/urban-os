import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/rule_condition.dart';

typedef C = AppColors;

class CondEvalRow extends StatelessWidget {
  final RuleCondition condition;
  final double currentValue, glowT;
  final bool met;
  const CondEvalRow({
    super.key,
    required this.condition,
    required this.currentValue,
    required this.met,
    required this.glowT,
  });

  @override
  Widget build(BuildContext ctx) {
    final col = met ? C.green : C.mutedLt;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: met
            ? C.green.withOpacity(0.04 + glowT * 0.02)
            : C.bgCard2.withOpacity(0.4),
        border: Border.all(
          color: col.withOpacity(met ? 0.2 + glowT * 0.06 : 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: col.withOpacity(0.15),
              border: Border.all(color: col.withOpacity(0.4)),
            ),
            child: Icon(
              met ? Icons.check_rounded : Icons.close_rounded,
              color: col,
              size: 10,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  condition.sensorId,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8.5,
                    color: C.white,
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: currentValue.toStringAsFixed(
                          currentValue < 10 ? 2 : 1,
                        ),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: col,
                        ),
                      ),
                      TextSpan(
                        text: '  ${condition.operatorType.symbol}  ',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: C.mutedLt,
                        ),
                      ),
                      TextSpan(
                        text: condition.threshold.toStringAsFixed(
                          condition.threshold == condition.threshold.toInt()
                              ? 0
                              : 1,
                        ),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: C.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                met ? 'IN RANGE' : 'OUT',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: col,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Δ ${(currentValue - condition.threshold).abs().toStringAsFixed(1)}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: C.mutedLt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
