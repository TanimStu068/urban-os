import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/profile_screen_data_model.dart';

typedef C = AppColors;

class ProfileCard extends StatelessWidget {
  final UserProfile user;
  final Animation<double> glowAnimation;
  final Animation<double> avatarAnimation;

  const ProfileCard({
    super.key,
    required this.user,
    required this.glowAnimation,
    required this.avatarAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowAnimation, avatarAnimation]),
      builder: (_, __) => Container(
        margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: C.bgCard.withOpacity(0.85),
          border: Border.all(color: C.teal.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: C.teal.withOpacity(0.04 + glowAnimation.value * 0.04),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar circle with rotating gradient
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [C.teal, C.cyan, C.teal],
                  stops: const [0, 0.5, 1],
                  transform: GradientRotation(avatarAnimation.value * 2 * pi),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.bgCard,
                ),
                child: Center(
                  child: Text(
                    user.name.isNotEmpty ? user.name[0] : "U",
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                      color: C.teal,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // User info column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: C.white,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: C.mutedLt,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: user.role.color.withOpacity(0.15),
                    ),
                    child: Text(
                      user.role.label,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 6,
                        color: user.role.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2FA status column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  user.twoFactorEnabled
                      ? Icons.verified_user_rounded
                      : Icons.error_outline_rounded,
                  color: user.twoFactorEnabled ? C.green : C.yellow,
                  size: 16,
                ),
                const SizedBox(height: 4),
                Text(
                  user.twoFactorEnabled ? '2FA ON' : '2FA OFF',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6,
                    color: user.twoFactorEnabled ? C.green : C.yellow,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
