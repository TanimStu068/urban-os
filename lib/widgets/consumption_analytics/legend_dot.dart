import 'package:flutter/material.dart';

class LegendDot extends StatelessWidget {
  final String label;
  final Color color;
  const LegendDot(this.label, this.color, {super.key});
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
