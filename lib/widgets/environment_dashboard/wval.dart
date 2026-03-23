import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class WVal extends StatelessWidget {
  final String label, value, unit;
  final Color color;
  const WVal(this.label, this.value, this.unit, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => Column(
    children: [
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: value,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: color,
                shadows: [Shadow(color: color.withOpacity(0.4), blurRadius: 5)],
              ),
            ),
            if (unit.isNotEmpty)
              TextSpan(
                text: ' $unit',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: color.withOpacity(0.7),
                ),
              ),
          ],
        ),
      ),
      Text(
        label,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 6.5,
          color: C.muted,
        ),
      ),
    ],
  );
}
