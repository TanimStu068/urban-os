import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/providers/log/log_provider.dart';

typedef C = AppColors;

class PredictiveHeader extends StatelessWidget {
  final LogProvider logProvider;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;
  final int modelCount;

  const PredictiveHeader({
    super.key,
    required this.logProvider,
    required this.glowAnimation,
    required this.blinkAnimation,
    required this.modelCount,
  });

  @override
  Widget build(BuildContext context) {
    final critCount = logProvider.alerts
        .where((a) => a.severity == RulePriority.critical && a.isActive)
        .length;

    return Container(
      height: 52,
      color: C.bgCard.withOpacity(0.92),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: glowAnimation,
            builder: (_, __) => Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: C.violet.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: C.violet.withOpacity(0.3 + glowAnimation.value * 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: C.violet.withOpacity(
                      0.12 + glowAnimation.value * 0.1,
                    ),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_graph_rounded,
                color: C.violet,
                size: 15,
              ),
            ),
          ),

          const SizedBox(width: 10),

          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [C.violet, C.cyan],
            ).createShader(b),
            child: const Text(
              'PREDICTIVE ANALYSIS',
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

          if (critCount > 0)
            AnimatedBuilder(
              animation: blinkAnimation,
              builder: (_, __) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: C.red.withOpacity(0.1 + blinkAnimation.value * 0.06),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: C.red.withOpacity(0.45 + blinkAnimation.value * 0.2),
                  ),
                ),
                child: Text(
                  '$critCount CRITICAL',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    color: C.red,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

          const SizedBox(width: 8),

          Text(
            '$modelCount MODELS',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              color: C.mutedLt,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
