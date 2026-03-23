import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/district/district_provider.dart';

typedef C = AppColors;

class DistrictHeader extends StatelessWidget {
  final DistrictProvider districtProvider;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;
  final VoidCallback openMap;

  const DistrictHeader({
    super.key,
    required this.districtProvider,
    required this.glowAnimation,
    required this.blinkAnimation,
    required this.openMap,
  });

  @override
  Widget build(BuildContext context) {
    final critCount = districtProvider.criticalDistrictCount;

    return AnimatedBuilder(
      animation: Listenable.merge([glowAnimation, blinkAnimation]),
      builder: (_, __) => Container(
        height: 52,
        color: C.bgCard.withOpacity(0.92),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: C.cyan.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: C.cyan.withOpacity(0.3 + glowAnimation.value * 0.18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: C.cyan.withOpacity(
                      0.08 + glowAnimation.value * 0.08,
                    ),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                color: C.cyan,
                size: 15,
              ),
            ),
            const SizedBox(width: 10),

            // Title
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [C.cyan, C.violet],
              ).createShader(b),
              child: const Text(
                'DISTRICTS',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                  color: C.white,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Total count
            Text(
              '/ ${districtProvider.totalDistricts}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: C.mutedLt,
              ),
            ),
            const Spacer(),

            // Critical count
            if (critCount > 0)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: C.red.withOpacity(0.1 + blinkAnimation.value * 0.05),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: C.red.withOpacity(0.45 + blinkAnimation.value * 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: C.red, size: 10),
                    const SizedBox(width: 4),
                    Text(
                      '$critCount CRITICAL',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7.5,
                        color: C.red,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

            // Map button
            GestureDetector(
              onTap: openMap,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: C.violet.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: C.violet.withOpacity(0.3)),
                ),
                child: const Icon(Icons.map_rounded, color: C.violet, size: 14),
              ),
            ),
            const SizedBox(width: 6),

            // Refresh button
            GestureDetector(
              onTap: () => districtProvider.refresh(),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: C.cyan.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: C.gBdr),
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: C.mutedLt,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
