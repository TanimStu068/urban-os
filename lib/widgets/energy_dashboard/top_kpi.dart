import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class TopKpi extends StatelessWidget {
  final String label, value, unit;
  final Color color;
  final IconData icon;
  final double glow;
  final bool blink;
  final double blinkT;

  const TopKpi({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
    required this.glow,
    this.blink = false,
    this.blinkT = 0,
  });

  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
            border: Border.all(
              color: color.withOpacity(blink ? 0.3 + blinkT * 0.25 : 0.25),
            ),
          ),
          child: Icon(icon, color: color, size: 13),
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: blink ? color.withOpacity(0.7 + blinkT * 0.3) : color,
                  shadows: [
                    Shadow(
                      color: color.withOpacity(0.4 + glow * 0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: color.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6,
            color: C.muted,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
