import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.cyan,
                boxShadow: [BoxShadow(color: AppColors.cyan, blurRadius: 8)],
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'WELCOME BACK',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            'Authenticate to access city control systems',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: AppColors.muted,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
