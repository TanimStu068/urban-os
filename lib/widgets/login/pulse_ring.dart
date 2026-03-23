import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class PulseRings extends StatelessWidget {
  final Animation<double> animation;
  const PulseRings({super.key, required this.animation});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    builder: (_, __) => Stack(children: [_ring(0.0, 260), _ring(0.5, 400)]),
  );

  Widget _ring(double offset, double base) {
    final t = (animation.value + offset) % 1.0;
    return Positioned.fill(
      child: Center(
        child: Transform.scale(
          scale: 0.85 + t * 0.35,
          child: Container(
            width: base,
            height: base,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.cyan.withOpacity((1 - t) * 0.1),
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
