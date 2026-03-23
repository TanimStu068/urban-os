import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class InfraMetric extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  const InfraMetric({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: color.withOpacity(.05),
      border: Border.all(color: color.withOpacity(.15)),
    ),
    child: Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: C.muted,
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
