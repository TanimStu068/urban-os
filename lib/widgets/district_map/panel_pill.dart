import 'package:flutter/material.dart';

class PanelPill extends StatelessWidget {
  final String label;
  final Color color;
  const PanelPill(this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(
      label,
      style: TextStyle(fontFamily: 'monospace', fontSize: 7.5, color: color),
    ),
  );
}
