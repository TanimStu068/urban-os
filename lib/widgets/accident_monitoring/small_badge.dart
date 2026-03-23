import 'package:flutter/material.dart';

class SmallBadge extends StatelessWidget {
  final String label;
  final Color col;
  const SmallBadge(this.label, this.col, {super.key});
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      color: col.withOpacity(0.1),
      border: Border.all(color: col.withOpacity(0.3)),
    ),
    child: Text(
      label,
      style: TextStyle(fontFamily: 'monospace', fontSize: 6.5, color: col),
    ),
  );
}
