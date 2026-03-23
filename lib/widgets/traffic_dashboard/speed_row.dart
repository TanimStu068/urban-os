import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SpeedRow extends StatelessWidget {
  final String name;
  final int current, limit;
  final Color color;
  final double glowT;
  const SpeedRow({
    super.key,
    required this.name,
    required this.current,
    required this.limit,
    required this.color,
    required this.glowT,
  });

  @override
  Widget build(BuildContext ctx) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      children: [
        SizedBox(
          width: 68,
          child: Text(
            name,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: C.mutedLt,
              letterSpacing: .5,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: color.withOpacity(.1),
                ),
              ),
              // Limit marker
              FractionallySizedBox(
                widthFactor: limit / 100,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: C.muted.withOpacity(.2),
                  ),
                ),
              ),
              // Actual speed
              FractionallySizedBox(
                widthFactor: (current / 100).clamp(0, 1),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: LinearGradient(
                      colors: [color.withOpacity(.5), color],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(.3 + glowT * .1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$current',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          '/$limit',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: C.muted,
          ),
        ),
        const Text(
          ' km/h',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: C.muted,
          ),
        ),
      ],
    ),
  );
}
