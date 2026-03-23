import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SumKpi extends StatelessWidget {
  final String value, label;
  final Color color;
  final IconData icon;
  final double glow;
  const SumKpi(
    this.value,
    this.label,
    this.color,
    this.icon,
    this.glow, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color.withOpacity(0.7 + glow * 0.25), size: 12),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: C.mutedLt,
            letterSpacing: 0.8,
          ),
        ),
      ],
    ),
  );
}
