import 'package:flutter/material.dart';

class LegDot extends StatelessWidget {
  final String label;
  final Color color;
  const LegDot(this.label, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
      const SizedBox(width: 5),
      Text(
        label,
        style: TextStyle(fontFamily: 'monospace', fontSize: 7, color: color),
      ),
    ],
  );
}
