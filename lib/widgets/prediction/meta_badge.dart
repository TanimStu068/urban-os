import 'package:flutter/material.dart';

class MetaBadge extends StatelessWidget {
  final String text;
  final Color color;
  const MetaBadge(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 7.5,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
