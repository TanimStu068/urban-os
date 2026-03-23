import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class InfraCount extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  const InfraCount({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(.1),
          border: Border.all(color: color.withOpacity(.25)),
        ),
        child: Icon(icon, color: color, size: 14),
      ),
      const SizedBox(height: 4),
      Text(
        '$count',
        style: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
      Text(
        label,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 6,
          letterSpacing: 1,
          color: C.muted,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
