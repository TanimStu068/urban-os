import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/screens/auth/login_screen.dart';
import 'package:urban_os/widgets/signup/badge.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'ALREADY REGISTERED? ',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: AppColors.muted,
              letterSpacing: 1,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text(
              'SIGN IN',
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
      const SizedBox(height: 14),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BadgeWidget(Icons.lock_rounded, 'ENCRYPTED'),
          const SizedBox(width: 10),
          BadgeWidget(Icons.shield_rounded, 'ISO 27001'),
          const SizedBox(width: 10),
          BadgeWidget(Icons.verified_rounded, 'CERTIFIED'),
        ],
      ),
    ],
  );
}
