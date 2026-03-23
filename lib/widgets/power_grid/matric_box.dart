import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class MetricBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const MetricBox(this.label, this.value, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: color,
            shadows: [Shadow(color: color.withOpacity(0.4), blurRadius: 4)],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: C.muted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
  );
}
