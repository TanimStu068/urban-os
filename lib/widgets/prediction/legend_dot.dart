import 'package:flutter/material.dart';

class LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const LegendDot(this.color, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 3, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
