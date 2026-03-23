import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String text;
  final Color color;
  const SectionHeader(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 14, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 8.5,
            color: color,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
