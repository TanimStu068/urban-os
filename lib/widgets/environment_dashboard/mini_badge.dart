import 'package:flutter/material.dart';

class MiniBadge extends StatelessWidget {
  final String text;
  final Color color;
  const MiniBadge(this.text, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: color.withOpacity(0.1),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 7,
        color: color,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
