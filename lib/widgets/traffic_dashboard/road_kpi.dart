import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class RoadKpi extends StatelessWidget {
  final String label, value, unit;
  final Color col;
  const RoadKpi(this.label, this.value, this.unit, this.col);
  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: col,
                  shadows: [Shadow(color: col.withOpacity(.4), blurRadius: 5)],
                ),
              ),
              TextSpan(
                text: unit,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  color: C.muted,
                ),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: C.muted,
            letterSpacing: .8,
          ),
        ),
      ],
    ),
  );
}
