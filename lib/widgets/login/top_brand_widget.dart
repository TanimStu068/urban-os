import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/login/mini_city_painter.dart';

class TopBrand extends StatelessWidget {
  const TopBrand({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mini logo mark
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder, width: 1),
            boxShadow: [
              BoxShadow(color: AppColors.cyan.withOpacity(0.2), blurRadius: 20),
            ],
          ),
          child: Center(
            child: CustomPaint(
              painter: MiniCityPainter(),
              size: const Size(28, 28),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppColors.cyan, Colors.white, AppColors.teal],
          ).createShader(b),
          child: const Text(
            'UrbanOS',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'OPERATOR ACCESS PORTAL',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            letterSpacing: 5,
            color: AppColors.cyanDim,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 160,
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, AppColors.cyan, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }
}
