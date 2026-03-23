import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class AKpi extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const AKpi({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withOpacity(0.07),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
              shadows: [Shadow(color: color.withOpacity(0.4), blurRadius: 6)],
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              color: C.muted,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
