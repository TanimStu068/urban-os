import 'package:flutter/material.dart';
import 'package:urban_os/models/automation/rule_priority.dart';

class PriorityTag extends StatelessWidget {
  final RulePriority p;
  const PriorityTag(this.p, {super.key});
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: p.color.withOpacity(0.1),
      border: Border.all(color: p.color.withOpacity(0.3)),
    ),
    child: Text(
      p.label,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 7.5,
        color: p.color,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
