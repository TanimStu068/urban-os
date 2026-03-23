import 'package:flutter/material.dart';

class StatusPill extends StatelessWidget {
  final String label;
  final Color col;
  final double blinkT;
  const StatusPill(this.label, this.col, this.blinkT, {super.key});

  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: col.withOpacity(0.08 + blinkT * 0.04),
      border: Border.all(color: col.withOpacity(0.35 + blinkT * 0.15)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: col.withOpacity(0.6 + blinkT * 0.4),
            boxShadow: [
              BoxShadow(color: col.withOpacity(0.5 * blinkT), blurRadius: 5),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            letterSpacing: 1,
            color: col,
          ),
        ),
      ],
    ),
  );
}
