import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ScenarioHeader extends StatelessWidget {
  final Animation<double> glowAnimation;
  final VoidCallback? onBack;

  const ScenarioHeader({super.key, required this.glowAnimation, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.teal.withOpacity(0.2))),
          boxShadow: [
            BoxShadow(
              color: C.teal.withOpacity(0.03 + glowAnimation.value * 0.03),
              blurRadius: 22,
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBack ?? () => Navigator.maybePop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: C.teal,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.teal.withOpacity(0.10),
                border: Border.all(color: C.teal.withOpacity(0.3)),
              ),
              child: const Icon(
                Icons.construction_rounded,
                color: C.teal,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [C.teal, C.cyan],
                    ).createShader(bounds),
                    child: const Text(
                      'SCENARIO BUILDER',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Text(
                    'Advanced Test Planning & Simulation',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      letterSpacing: 1.4,
                      color: C.mutedLt,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
