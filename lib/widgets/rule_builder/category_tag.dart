import 'package:flutter/material.dart';
import 'package:urban_os/models/automation/rule_priority.dart';

class CategoryTag extends StatelessWidget {
  final RuleCategory cat;
  const CategoryTag(this.cat, {super.key});
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: cat.color.withOpacity(0.1),
      border: Border.all(color: cat.color.withOpacity(0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(cat.icon, color: cat.color, size: 10),
        const SizedBox(width: 4),
        Text(
          cat.label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            color: cat.color,
          ),
        ),
      ],
    ),
  );
}
