import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class CongestionImpactRow extends StatelessWidget {
  final String road;
  final int congestion;
  final String delta;
  final Color col;
  final double glowT;
  const CongestionImpactRow(
    this.road,
    this.congestion,
    this.delta,
    this.col,
    this.glowT, {
    super.key,
  });

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
        Expanded(
          child: Text(
            road,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 8.5,
              color: C.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Stack(
              children: [
                Container(height: 5, color: col.withOpacity(0.1)),
                FractionallySizedBox(
                  widthFactor: congestion / 100,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        colors: [col.withOpacity(0.5), col],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$congestion%',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: col,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: delta == '0%'
                ? C.green.withOpacity(0.08)
                : C.red.withOpacity(0.08),
            border: Border.all(
              color: delta == '0%'
                  ? C.green.withOpacity(0.3)
                  : C.red.withOpacity(0.3),
            ),
          ),
          child: Text(
            delta,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              color: delta == '0%' ? C.green : C.red,
            ),
          ),
        ),
      ],
    ),
  );
}
