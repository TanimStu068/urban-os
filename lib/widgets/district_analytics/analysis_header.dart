import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/district/district_type.dart';

typedef C = AppColors;

class AnalysisHeader extends StatelessWidget {
  final DistrictModel d;
  final Animation<double> glowAnim;
  final VoidCallback onBack;

  const AnalysisHeader({
    super.key,
    required this.d,
    required this.glowAnim,
    required this.onBack,
  });

  Color _healthColor(double value) {
    // 🔁 Move your existing logic here
    return C.green;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnim,
      builder: (_, __) => Container(
        height: 52,
        color: C.bgCard.withValues(alpha: 0.92),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            /// 🔙 Back Button
            GestureDetector(
              onTap: onBack,
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

            /// 📊 Icon Badge
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: C.violet.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: C.violet.withValues(
                    alpha: 0.3 + glowAnim.value * 0.15,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: C.violet.withValues(alpha: 0.08),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                color: C.violet,
                size: 14,
              ),
            ),

            const SizedBox(width: 10),

            /// 🏙 Title + Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [C.violet, C.cyan],
                    ).createShader(b),
                    child: Text(
                      '${d.name.toUpperCase()} · ANALYSIS',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: C.white,
                      ),
                    ),
                  ),
                  Text(
                    '${d.type.displayName}  ·  ${d.id}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: C.mutedLt,
                    ),
                  ),
                ],
              ),
            ),

            /// 💚 Health Score
            Text(
              '${d.healthPercentage.toStringAsFixed(0)}% HEALTH',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 10,
                color: _healthColor(d.healthPercentage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
