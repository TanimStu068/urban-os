import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class OverviewStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const OverviewStat({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: color,
          shadows: [Shadow(color: color.withOpacity(.4), blurRadius: 6)],
        ),
      ),
      const SizedBox(height: 3),
      Text(
        label,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 7,
          letterSpacing: 1.5,
          color: C.muted,
        ),
      ),
    ],
  );
}
