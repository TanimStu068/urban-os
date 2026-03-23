import 'package:flutter/material.dart';

class AnalysisSectionHeader extends StatelessWidget {
  final String text;
  final Color color;
  const AnalysisSectionHeader(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 3,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 9,
          color: color,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
