import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/signup/mini_city_painter.dart';

class TopBrand extends StatelessWidget {
  const TopBrand({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgCard,
              border: Border.all(color: AppColors.glassBdr),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withOpacity(.18),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Center(
              child: CustomPaint(
                painter: MiniCityPainter(),
                size: const Size(24, 24),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [AppColors.cyan, Colors.white, AppColors.teal],
                ).createShader(b),
                child: const Text(
                  'UrbanOS',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                    color: Colors.white,
                  ),
                ),
              ),
              const Text(
                'NEW OPERATOR REGISTRATION',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  letterSpacing: 3.5,
                  color: AppColors.cyanDim,
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        width: 200,
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
