import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/log/log_provider.dart';

typedef C = AppColors;

class ReportHeaderWidget extends StatelessWidget {
  final LogProvider logProvider;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;

  const ReportHeaderWidget({
    super.key,
    required this.logProvider,
    required this.glowAnimation,
    required this.blinkAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: C.bgCard.withOpacity(0.92),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Glowing icon
          AnimatedBuilder(
            animation: glowAnimation,
            builder: (_, __) => Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: C.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: C.green.withOpacity(0.3 + glowAnimation.value * 0.2),
                ),
                boxShadow: [
                  BoxShadow(color: C.green.withOpacity(0.1), blurRadius: 8),
                ],
              ),
              child: Icon(Icons.description_rounded, color: C.green, size: 15),
            ),
          ),
          const SizedBox(width: 10),

          // Gradient title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [C.green, C.cyan],
            ).createShader(bounds),
            child: const Text(
              'REPORT GENERATOR',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: C.white,
              ),
            ),
          ),
          const Spacer(),

          // Generated count
          Text(
            '${logProvider.alerts.length} GENERATED',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              color: C.mutedLt,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 10),

          // Blinking live indicator
          AnimatedBuilder(
            animation: blinkAnimation,
            builder: (_, __) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: C.green.withOpacity(0.05 + blinkAnimation.value * 0.03),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: C.green.withOpacity(0.2 + blinkAnimation.value * 0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: C.green.withOpacity(
                        0.6 + blinkAnimation.value * 0.4,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'SYS LIVE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: C.green,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
