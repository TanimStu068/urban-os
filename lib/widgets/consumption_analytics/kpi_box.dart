import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class KpiBox extends StatelessWidget {
  final String label, value, unit;
  final Color color;
  final double glow;
  final IconData icon;
  final bool blink;
  final double blinkT;
  const KpiBox({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.glow,
    required this.icon,
    this.blink = false,
    this.blinkT = 0,
  });
  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
            border: Border.all(color: color.withOpacity(0.28)),
          ),
          child: Icon(icon, color: color, size: 12),
        ),
        const SizedBox(height: 3),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: blink ? color.withOpacity(0.7 + blinkT * 0.3) : color,
                  shadows: [
                    Shadow(
                      color: color.withOpacity(0.35 + glow * 0.1),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              if (unit.isNotEmpty)
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6.5,
                    color: color.withOpacity(0.6),
                  ),
                ),
            ],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 5.5,
            color: C.muted,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
