import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class FireHeader extends StatelessWidget {
  final BuildContext contextRef;
  final AnimationController glowCtrl;
  final AnimationController flameCtrl;
  final int fireZones;
  final double avgTemp;

  const FireHeader({
    Key? key,
    required this.contextRef,
    required this.glowCtrl,
    required this.flameCtrl,
    required this.fireZones,
    required this.avgTemp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.red.withOpacity(0.2))),
          boxShadow: [
            BoxShadow(
              color: C.red.withOpacity(0.04 + glowCtrl.value * 0.04),
              blurRadius: 24,
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.maybePop(contextRef),
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
            // Animated flame icon
            AnimatedBuilder(
              animation: flameCtrl,
              builder: (_, __) => Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.red.withOpacity(0.12 + flameCtrl.value * 0.1),
                  border: Border.all(
                    color: C.red.withOpacity(0.4 + flameCtrl.value * 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: C.red.withOpacity(0.15 + flameCtrl.value * 0.15),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: C.red,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [C.red, C.orange],
                    ).createShader(bounds),
                    child: const Text(
                      'FIRE MONITORING',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Active: $fireZones  ·  Avg: ${avgTemp.toStringAsFixed(0)}°C',
                    style: const TextStyle(
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
