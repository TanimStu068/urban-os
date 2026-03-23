import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String label;
  final Color col;
  const TagChip(this.label, this.col);

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
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 6.5,
        letterSpacing: 0.8,
        color: col,
      ),
    ),
  );
}
