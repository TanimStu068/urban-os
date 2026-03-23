import 'package:flutter/material.dart';
import 'package:urban_os/models/automation/rule_priority.dart';

class PriorityBadge extends StatelessWidget {
  final RulePriority priority;
  final double blinkT;
  const PriorityBadge(this.priority, this.blinkT, {super.key});
  @override
  Widget build(BuildContext ctx) {
    final col = priority.color;
    final isPulse = priority == RulePriority.critical;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: col.withOpacity(isPulse ? 0.12 + blinkT * 0.05 : 0.08),
        border: Border.all(
          color: col.withOpacity(isPulse ? 0.5 + blinkT * 0.15 : 0.3),
        ),
      ),
      child: Text(
        priority.label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 7,
          letterSpacing: 0.5,
          color: col,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
