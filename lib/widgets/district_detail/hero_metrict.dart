import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class HeroMetric extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  const HeroMetric(this.label, this.value, this.color, this.icon, {super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, color: color, size: 12),
      const SizedBox(height: 2),
      Text(
        value,
        style: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 6.5,
          color: AppColors.mutedLt,
          letterSpacing: 0.8,
        ),
      ),
    ],
  );
}
