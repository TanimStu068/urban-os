import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class HotspotRow extends StatelessWidget {
  final String road;
  final int count;
  final Color col;
  final double glowT;
  const HotspotRow(this.road, this.count, this.col, this.glowT, {super.key});

  @override
  Widget build(BuildContext ctx) => Container(
    margin: const EdgeInsets.only(bottom: 7),
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: C.bgCard2.withOpacity(0.5),
      border: Border.all(color: col.withOpacity(0.15 + glowT * 0.05)),
    ),
    child: Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: col.withOpacity(0.15),
          ),
          child: Center(
            child: Text(
              '$count',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: col,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            road,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              color: C.white,
            ),
          ),
        ),
        Container(
          height: 6,
          width: 50 * (count / 3.0).clamp(0.1, 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: LinearGradient(colors: [col.withOpacity(0.5), col]),
            boxShadow: [BoxShadow(color: col.withOpacity(0.3), blurRadius: 4)],
          ),
        ),
      ],
    ),
  );
}
