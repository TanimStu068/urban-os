import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/district/district_provider.dart';

typedef C = AppColors;

class DistrictMapHeader extends StatelessWidget {
  final DistrictProvider districtProvider;
  final Animation<double> glowAnimation;
  final double scale;
  final Offset pan;
  final VoidCallback onResetZoom;
  final VoidCallback? onBack;

  const DistrictMapHeader({
    super.key,
    required this.districtProvider,
    required this.glowAnimation,
    required this.scale,
    required this.pan,
    required this.onResetZoom,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, __) => Container(
        height: 52,
        color: C.bgCard.withOpacity(0.92),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBack ?? () => Navigator.pop(context),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: C.bgCard2,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: C.gBdr),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: C.mutedLt,
                  size: 13,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: C.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: C.green.withOpacity(0.3 + glowAnimation.value * 0.15),
                ),
              ),
              child: const Icon(Icons.map_rounded, color: C.green, size: 14),
            ),
            const SizedBox(width: 10),
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [C.green, C.cyan],
              ).createShader(b),
              child: const Text(
                'CITY MAP',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                  color: C.white,
                ),
              ),
            ),
            const Spacer(),
            Text(
              '${districtProvider.totalDistricts} DISTRICTS',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: C.mutedLt,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 10),
            // Reset zoom button
            GestureDetector(
              onTap: onResetZoom,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: C.bgCard2,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: C.gBdr),
                ),
                child: const Icon(
                  Icons.fit_screen_rounded,
                  color: C.mutedLt,
                  size: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
