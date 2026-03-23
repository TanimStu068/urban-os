import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/city_dashboard/health_arc_painter.dart';
import 'package:urban_os/widgets/city_dashboard/radar_swap_painter.dart';
import 'package:urban_os/widgets/city_dashboard/ring_track_painter.dart';
import 'dart:math';

typedef C = AppColors;

class HealthRing extends StatelessWidget {
  final double health;
  final Color color;
  final AnimationController ringCtrl, radarCtrl, glowCtrl;
  const HealthRing({
    super.key,
    required this.health,
    required this.color,
    required this.ringCtrl,
    required this.radarCtrl,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: radarCtrl,
            builder: (_, __) => Transform.rotate(
              angle: radarCtrl.value * 2 * pi,
              child: CustomPaint(
                painter: RadarSweepPainter(color),
                size: const Size(140, 140),
              ),
            ),
          ),
          CustomPaint(
            painter: RingTrackPainter(C.muted.withOpacity(.2)),
            size: const Size(140, 140),
          ),
          AnimatedBuilder(
            animation: ringCtrl,
            builder: (_, __) => CustomPaint(
              painter: HealthArcPainter(health / 100 * ringCtrl.value, color),
              size: const Size(140, 140),
            ),
          ),
          AnimatedBuilder(
            animation: glowCtrl,
            builder: (_, __) => Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(.08 + glowCtrl.value * .05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                health.toStringAsFixed(1),
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: color,
                  shadows: [Shadow(color: color, blurRadius: 10)],
                ),
              ),
              const Text(
                'HEALTH',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  letterSpacing: 2,
                  color: C.mutedLt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
