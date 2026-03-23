import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatItem(this.label, this.value, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: C.mutedLt,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
