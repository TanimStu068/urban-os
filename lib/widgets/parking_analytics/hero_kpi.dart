import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class HeroKpi extends StatelessWidget {
  final String value, label;
  final Color col;
  const HeroKpi(this.value, this.label, this.col);
  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: col,
            shadows: [Shadow(color: col.withOpacity(0.4), blurRadius: 5)],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6,
            color: C.muted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
