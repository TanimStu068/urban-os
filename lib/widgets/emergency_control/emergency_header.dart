import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class EmergencyHeader extends StatelessWidget {
  final BuildContext contextRef;
  final AnimationController glowCtrl;
  final AnimationController alertCtrl;
  final int activeIncidents;
  final int teamsDeployed;

  const EmergencyHeader({
    super.key,
    required this.contextRef,
    required this.glowCtrl,
    required this.alertCtrl,
    required this.activeIncidents,
    required this.teamsDeployed,
  });

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
            // Icon with animation
            AnimatedBuilder(
              animation: alertCtrl,
              builder: (_, __) => Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.red.withOpacity(0.12 + alertCtrl.value * 0.08),
                  border: Border.all(
                    color: C.red.withOpacity(0.4 + alertCtrl.value * 0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: C.red.withOpacity(0.2 + alertCtrl.value * 0.2),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.warning_rounded,
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
                      'EMERGENCY CONTROL',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Active: $activeIncidents  ·  Teams: $teamsDeployed',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      letterSpacing: 1.6,
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
