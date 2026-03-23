import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/pollution_analysis_data_model.dart';

typedef C = AppColors;

class PollutionAnalyticsHeader extends StatelessWidget {
  final int districtCount;
  final bool liveMode;
  final AnimationController glowCtrl;

  final VoidCallback onBack;
  final VoidCallback onToggleLive;

  const PollutionAnalyticsHeader({
    super.key,
    required this.districtCount,
    required this.liveMode,
    required this.glowCtrl,
    required this.onBack,
    required this.onToggleLive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.gBdr)),
          boxShadow: [
            BoxShadow(
              color: C.orange.withOpacity(0.04 + glowCtrl.value * 0.02),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: onBack,
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

            // Icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.orange.withOpacity(0.10),
                border: Border.all(
                  color: C.orange.withOpacity(0.3 + glowCtrl.value * 0.18),
                ),
              ),
              child: const Icon(
                Icons.science_rounded,
                color: C.orange,
                size: 18,
              ),
            ),

            const SizedBox(width: 12),

            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [C.orange, C.red],
                    ).createShader(b),
                    child: const Text(
                      'POLLUTION ANALYTICS',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '$districtCount DISTRICTS  ·  ${PollutantType.values.length} POLLUTANTS',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      letterSpacing: 1.8,
                      color: C.mutedLt,
                    ),
                  ),
                ],
              ),
            ),

            // Live toggle
            GestureDetector(
              onTap: onToggleLive,
              child: AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: liveMode ? C.green.withOpacity(0.08) : C.bgCard2,
                    border: Border.all(
                      color: liveMode
                          ? C.green.withOpacity(0.4)
                          : C.muted.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: liveMode ? C.green : C.muted,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        liveMode ? 'LIVE' : 'PAUSED',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: liveMode ? C.green : C.mutedLt,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
