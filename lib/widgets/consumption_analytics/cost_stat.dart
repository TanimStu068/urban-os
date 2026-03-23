import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class CostStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const CostStat(this.label, this.value, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: color,
            shadows: [Shadow(color: color.withOpacity(0.35), blurRadius: 4)],
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
