import 'package:flutter/material.dart';

class SignalSummaryChip extends StatelessWidget {
  final String count, label;
  final Color col;
  final double glowT;
  const SignalSummaryChip(this.count, this.label, this.col, this.glowT);
  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: col.withOpacity(.08 + glowT * .04),
        border: Border.all(color: col.withOpacity(.3 + glowT * .1)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: col,
              shadows: [Shadow(color: col.withOpacity(.5), blurRadius: 8)],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              letterSpacing: 1.5,
              color: col.withOpacity(.7),
            ),
          ),
        ],
      ),
    ),
  );
}
