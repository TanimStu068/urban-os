import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class PulseRings extends StatelessWidget {
  final Animation<double> animation;
  const PulseRings({super.key, required this.animation});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Stack(
        children: [
          _buildRing(0.0, 300),
          _buildRing(0.333, 500),
          _buildRing(0.666, 700),
        ],
      ),
    );
  }

  Widget _buildRing(double offset, double baseSize) {
    final t = (animation.value + offset) % 1.0;
    final scale = 0.8 + t * 0.4;
    final opacity = (1.0 - t) * 0.15;
    return Positioned.fill(
      child: Center(
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: baseSize,
            height: baseSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.cyan.withOpacity(opacity),
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
