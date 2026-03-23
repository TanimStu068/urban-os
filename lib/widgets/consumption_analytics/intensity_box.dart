import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class IntensityBox extends StatelessWidget {
  final String label, value, unit;
  final Color color;
  final double change;
  const IntensityBox(
    this.label,
    this.value,
    this.unit,
    this.color,
    this.change, {
    super.key,
  });
  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: color,
            shadows: [Shadow(color: color.withOpacity(0.4), blurRadius: 5)],
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: C.muted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: C.mutedLt,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 3),
        Text(
          '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: change > 0 ? C.red : C.green,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
