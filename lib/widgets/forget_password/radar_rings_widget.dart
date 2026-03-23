import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class RadarRings extends StatelessWidget {
  final Animation<double> anim;
  const RadarRings({super.key, required this.anim});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: anim,
    builder: (_, __) =>
        Stack(children: [_ring(0.0, 120), _ring(0.33, 200), _ring(0.66, 280)]),
  );

  Widget _ring(double off, double base) {
    final t = (anim.value + off) % 1.0;
    return Center(
      child: Transform.scale(
        scale: .6 + t * .8,
        child: Container(
          width: base,
          height: base,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.cyan.withOpacity((1 - t) * .06),
              width: .8,
            ),
          ),
        ),
      ),
    );
  }
}
