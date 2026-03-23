import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class StatBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const StatBox(this.label, this.value, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: color,
            shadows: [Shadow(color: color.withOpacity(0.4), blurRadius: 5)],
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: C.muted,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}
