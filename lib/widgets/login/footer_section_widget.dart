import 'package:flutter/material.dart';
import 'package:urban_os/screens/auth/signup_screen.dart';
import 'package:urban_os/widgets/login/badge_widget.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "NEW OPERATOR? ",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: AppColors.muted,
                letterSpacing: 1,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'REQUEST ACCESS',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  letterSpacing: 1,
                  color: AppColors.cyan,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.cyan,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Security badges row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BadgeWidget(icon: Icons.lock_rounded, label: 'ENCRYPTED'),
            const SizedBox(width: 12),
            BadgeWidget(icon: Icons.shield_rounded, label: 'ISO 27001'),
            const SizedBox(width: 12),
            BadgeWidget(icon: Icons.verified_rounded, label: 'CERTIFIED'),
          ],
        ),
      ],
    );
  }
}
