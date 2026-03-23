import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class BrandText extends StatelessWidget {
  final Animation<double> dividerOpacity, taglineOpacity;
  final bool isSmallScreen;
  const BrandText({
    super.key,
    required this.dividerOpacity,
    required this.taglineOpacity,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleSize = isSmallScreen ? 48.0 : 62.0;
    final subtitleSize = isSmallScreen ? 10.0 : 11.0;

    return Column(
      children: [
        // Main title with gradient
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.cyan, Colors.white, AppColors.teal],
          ).createShader(bounds),
          child: Text(
            'UrbanOS',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: titleSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 12,
              color: Colors.white,
              shadows: const [Shadow(color: AppColors.cyan, blurRadius: 20)],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'SMART CITY DIGITAL TWIN',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: subtitleSize,
            letterSpacing: 6,
            color: AppColors.cyanDim,
          ),
        ),
        const SizedBox(height: 18),
        FadeTransition(
          opacity: dividerOpacity,
          child: Container(
            width: 200,
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.cyan,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        FadeTransition(
          opacity: taglineOpacity,
          child: Text(
            'AUTONOMOUS  ·  INTELLIGENT  ·  CONNECTED',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: subtitleSize,
              letterSpacing: 3,
              color: const Color(0x72E8F4F8),
            ),
          ),
        ),
      ],
    );
  }
}
