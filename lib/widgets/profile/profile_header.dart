import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ProfileHeader extends StatelessWidget {
  final Animation<double> glowAnimation;
  final VoidCallback onLogout;
  final VoidCallback? onBack;

  const ProfileHeader({
    super.key,
    required this.glowAnimation,
    required this.onLogout,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.teal.withOpacity(0.2))),
          boxShadow: [
            BoxShadow(
              color: C.teal.withOpacity(0.03 + glowAnimation.value * 0.03),
              blurRadius: 22,
            ),
          ],
        ),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: onBack ?? () => Navigator.maybePop(context),
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

            // Profile icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.teal.withOpacity(0.10),
                border: Border.all(color: C.teal.withOpacity(0.3)),
              ),
              child: const Icon(Icons.person_rounded, color: C.teal, size: 18),
            ),

            const SizedBox(width: 12),

            // Title & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [C.teal, C.cyan],
                    ).createShader(bounds),
                    child: const Text(
                      'USER PROFILE',
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
                  const Text(
                    'Account Settings & Security',
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

            const SizedBox(width: 8),

            // Logout button
            GestureDetector(
              onTap: onLogout,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: C.red.withOpacity(0.15),
                  border: Border.all(color: C.red.withOpacity(0.3)),
                ),
                child: const Icon(Icons.logout_rounded, color: C.red, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
