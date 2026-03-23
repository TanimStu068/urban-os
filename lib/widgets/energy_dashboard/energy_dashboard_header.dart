import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/energy_dashboard/circle_btn.dart';

typedef C = AppColors;

class EnergyDashboardHeader extends StatelessWidget {
  final int zonesCount;
  final int activeSources;
  final bool liveUpdates;
  final int unackAlerts;
  final Animation<double> glowAnimation;
  final Animation<double> pulseAnimation;
  final Animation<double> blinkAnimation;
  final VoidCallback onBack;
  final VoidCallback onToggleLive;

  const EnergyDashboardHeader({
    super.key,
    required this.zonesCount,
    required this.activeSources,
    required this.liveUpdates,
    required this.unackAlerts,
    required this.glowAnimation,
    required this.pulseAnimation,
    required this.blinkAnimation,
    required this.onBack,
    required this.onToggleLive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        glowAnimation,
        pulseAnimation,
        blinkAnimation,
      ]),
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.gBdr)),
          boxShadow: [
            BoxShadow(
              color: C.amber.withOpacity(0.03 + glowAnimation.value * 0.02),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBack,
              child: CircleBtn(Icons.arrow_back_ios_rounded, sz: 14),
            ),
            const SizedBox(width: 12),
            // Icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.amber.withOpacity(0.1),
                border: Border.all(
                  color: C.amber.withOpacity(0.3 + glowAnimation.value * 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: C.amber.withOpacity(
                      0.15 + glowAnimation.value * 0.1,
                    ),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Icon(
                Icons.electric_bolt_rounded,
                color: C.amber,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [C.amber, C.yellow],
                    ).createShader(b),
                    child: const Text(
                      'ENERGY COMMAND',
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
                    'POWER GRID CONTROL  ·  $zonesCount ZONES  ·  $activeSources SOURCES',
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
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: liveUpdates
                      ? C.green.withOpacity(0.08 + blinkAnimation.value * 0.04)
                      : C.bgCard2,
                  border: Border.all(
                    color: liveUpdates
                        ? C.green.withOpacity(0.4 + blinkAnimation.value * 0.15)
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
                        color: liveUpdates
                            ? C.green.withOpacity(
                                0.6 + blinkAnimation.value * 0.4,
                              )
                            : C.muted,
                        boxShadow: liveUpdates
                            ? [
                                BoxShadow(
                                  color: C.green.withOpacity(0.5),
                                  blurRadius: 6,
                                ),
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      liveUpdates ? 'LIVE' : 'PAUSED',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        color: liveUpdates ? C.green : C.mutedLt,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (unackAlerts > 0)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: C.red.withOpacity(0.1 + blinkAnimation.value * 0.04),
                  border: Border.all(
                    color: C.red.withOpacity(
                      0.35 + blinkAnimation.value * 0.15,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: C.red,
                      size: 12,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$unackAlerts ALERT${unackAlerts > 1 ? 'S' : ''}',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7.5,
                        color: C.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            CircleBtn(Icons.download_rounded, sz: 15),
          ],
        ),
      ),
    );
  }
}
