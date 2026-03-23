import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SystemHeader extends StatelessWidget {
  final Animation<double> glowAnimation;
  final VoidCallback? onBackTap;

  const SystemHeader({super.key, required this.glowAnimation, this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.cyan.withOpacity(0.2))),
          boxShadow: [
            BoxShadow(
              color: C.cyan.withOpacity(0.03 + glowAnimation.value * 0.03),
              blurRadius: 22,
            ),
          ],
        ),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: onBackTap ?? () => Navigator.maybePop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: C.cyan,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Settings icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.cyan.withOpacity(0.10),
                border: Border.all(color: C.cyan.withOpacity(0.3)),
              ),
              child: const Icon(
                Icons.settings_rounded,
                color: C.cyan,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [C.cyan, C.teal],
                    ).createShader(b),
                    child: const Text(
                      'SYSTEM SETTINGS',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Configure System Preferences',
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
