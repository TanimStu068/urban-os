import 'package:flutter/material.dart';

import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_type.dart';
import 'package:urban_os/screens/districts/district_analytics_screen.dart';

typedef C = AppColors;

class DistrictHeader extends StatelessWidget {
  final DistrictModel district;
  final Animation<double> glowAnim;
  final Animation<double> blinkAnim;
  final void Function()? onBack;
  final Color Function(dynamic) typeColor;

  const DistrictHeader({
    super.key,
    required this.district,
    required this.glowAnim,
    required this.blinkAnim,
    this.onBack,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnim,
      builder: (_, __) => Container(
        height: 52,
        color: C.bgCard.withOpacity(0.92),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Back button
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

            // District name & type
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (b) => LinearGradient(
                      colors: [typeColor(district.type), C.cyan],
                    ).createShader(b),
                    child: Text(
                      district.name.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: C.white,
                      ),
                    ),
                  ),
                  Text(
                    '${district.type.displayName}  ·  ${district.id}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      color: C.mutedLt,
                    ),
                  ),
                ],
              ),
            ),

            // Critical issues badge
            if (district.metrics.hasCriticalIssues)
              AnimatedBuilder(
                animation: blinkAnim,
                builder: (_, __) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: C.red.withOpacity(0.1 + blinkAnim.value * 0.06),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: C.red.withOpacity(0.45 + blinkAnim.value * 0.2),
                    ),
                  ),
                  child: const Text(
                    'CRITICAL',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      color: C.red,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 6),

            // Analysis button
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DistrictAnalysisScreen(district: district),
                ),
              ),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: C.violet.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: C.violet.withOpacity(0.3 + glowAnim.value * 0.15),
                  ),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: C.violet,
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
