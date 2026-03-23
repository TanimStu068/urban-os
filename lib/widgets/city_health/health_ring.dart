import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/city_health/arc_painter.dart';
import 'dart:math';

import 'package:urban_os/widgets/city_health/radar_painter.dart';

typedef C = AppColors;

class HealthRing extends StatelessWidget {
  final double cityHealth, infraHealth;
  final Color color;
  final AnimationController ringCtrl, radarCtrl, glowCtrl, pulseCtrl;

  const HealthRing({
    super.key,
    required this.cityHealth,
    required this.infraHealth,
    required this.color,
    required this.ringCtrl,
    required this.radarCtrl,
    required this.glowCtrl,
    required this.pulseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 148,
      height: 148,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // radar sweep
          AnimatedBuilder(
            animation: radarCtrl,
            builder: (_, __) => Transform.rotate(
              angle: radarCtrl.value * 2 * pi,
              child: CustomPaint(
                painter: RadarPainter(color),
                size: const Size(148, 148),
              ),
            ),
          ),

          // outer infra ring (secondary)
          AnimatedBuilder(
            animation: ringCtrl,
            builder: (_, __) => CustomPaint(
              painter: ArcPainter(
                infraHealth / 100 * ringCtrl.value,
                C.cyan,
                148,
                4,
                4,
              ),
              size: const Size(148, 148),
            ),
          ),

          // inner city health ring (primary)
          CustomPaint(
            painter: ArcPainter(
              0.75,
              C.muted.withValues(alpha: 0.18),
              130,
              9,
              0,
            ),
            size: const Size(148, 148),
          ),
          AnimatedBuilder(
            animation: ringCtrl,
            builder: (_, __) => CustomPaint(
              painter: ArcPainter(
                cityHealth / 100 * ringCtrl.value,
                color,
                130,
                9,
                0,
              ),
              size: const Size(148, 148),
            ),
          ),

          // glow core
          AnimatedBuilder(
            animation: glowCtrl,
            builder: (_, __) => Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(.06 + glowCtrl.value * .04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // pulse ring on alerts
          AnimatedBuilder(
            animation: pulseCtrl,
            builder: (_, __) => Container(
              width: 64 + pulseCtrl.value * 8,
              height: 64 + pulseCtrl.value * 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity((1 - pulseCtrl.value) * .18),
                  width: 1,
                ),
              ),
            ),
          ),

          // Center text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cityHealth.toStringAsFixed(1),
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: color,
                  shadows: [Shadow(color: color, blurRadius: 12)],
                ),
              ),
              const Text(
                'HEALTH',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  letterSpacing: 2.5,
                  color: C.mutedLt,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'INFRA ${infraHealth.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  letterSpacing: 1.5,
                  color: C.cyan.withOpacity(.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
