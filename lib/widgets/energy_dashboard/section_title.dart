import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final Color color;
  const SectionTitle(this.text, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => Row(
    children: [
      Container(
        width: 3,
        height: 14,
        margin: const EdgeInsets.only(right: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: color,
          boxShadow: [BoxShadow(color: color, blurRadius: 5)],
        ),
      ),
      Text(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 1.5,
        ),
      ),
    ],
  );
}
