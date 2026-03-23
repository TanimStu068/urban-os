import 'package:flutter/material.dart';

class LegendDot extends StatelessWidget {
  final String label;
  final Color col;
  const LegendDot(this.label, this.col);
  @override
  Widget build(BuildContext ctx) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: col.withOpacity(0.7),
        ),
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 7,
          color: col.withOpacity(0.6),
        ),
      ),
    ],
  );
}
