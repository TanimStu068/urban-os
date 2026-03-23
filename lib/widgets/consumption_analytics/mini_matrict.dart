import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class MiniMetric extends StatelessWidget {
  final String label, value;
  final Color color;
  const MiniMetric(this.label, this.value, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: color,
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
    ),
  );
}
