import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class DeveloperHeader extends StatelessWidget {
  final AnimationController glowController;

  const DeveloperHeader({super.key, required this.glowController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowController,
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.cyan.withOpacity(0.2))),
          boxShadow: [
            BoxShadow(
              color: C.cyan.withOpacity(0.03 + glowController.value * 0.03),
              blurRadius: 22,
            ),
          ],
        ),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
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

            // Icon
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

            // Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [C.cyan, C.teal],
                    ).createShader(bounds),
                    child: const Text(
                      'DEVELOPER PANEL',
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
                    'Debug Tools & System Diagnostics',
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
