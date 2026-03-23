import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/splash/city_icon.dart';
import 'package:urban_os/widgets/splash/ring_painter.dart';
import 'dart:math';

class LogoRing extends StatelessWidget {
  final AnimationController ringCtrl, ringRevCtrl, glowCtrl;
  final bool isSmallScreen;
  const LogoRing({
    super.key,
    required this.ringCtrl,
    required this.ringRevCtrl,
    required this.glowCtrl,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isSmallScreen ? 140.0 : 180.0;
    final innerSize = isSmallScreen ? 122.0 : 156.0;
    final centerSize = isSmallScreen ? 108.0 : 140.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          AnimatedBuilder(
            animation: ringCtrl,
            builder: (_, __) => Transform.rotate(
              angle: ringCtrl.value * 2 * pi,
              child: CustomPaint(
                painter: RingPainter(false),
                size: Size(size, size),
              ),
            ),
          ),
          // Inner reverse ring
          AnimatedBuilder(
            animation: ringRevCtrl,
            builder: (_, __) => Transform.rotate(
              angle: -ringRevCtrl.value * 2 * pi,
              child: CustomPaint(
                painter: RingPainter(true),
                size: Size(innerSize, innerSize),
              ),
            ),
          ),
          // Center circle
          Container(
            width: centerSize,
            height: centerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF071520), Color(0xFF0A1E30)],
              ),
              border: Border.all(color: AppColors.glassBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withOpacity(0.15),
                  blurRadius: 40,
                ),
                BoxShadow(
                  color: AppColors.cyan.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Center(child: CityIcon(glowCtrl: glowCtrl)),
          ),
        ],
      ),
    );
  }
}
