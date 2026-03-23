import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class KpiCell extends StatelessWidget {
  final String label, value, unit;
  final Color color;
  final double glow;
  final bool blink;
  final double blinkT;

  const KpiCell(
    this.label,
    this.value,
    this.unit,
    this.color,
    this.glow, {
    this.blink = false,
    this.blinkT = 0,
  });

  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: blink ? color.withOpacity(0.7 + blinkT * 0.3) : color,
                  shadows: [
                    Shadow(
                      color: color.withOpacity(0.4 + glow * 0.1),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              if (unit.isNotEmpty)
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: color.withOpacity(0.6),
                  ),
                ),
            ],
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
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
