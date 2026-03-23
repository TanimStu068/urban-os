import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class PulseRings extends StatelessWidget {
  final Animation<double> anim;
  const PulseRings({super.key, required this.anim});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: anim,
    builder: (_, __) => Stack(children: [_r(0.0, 220), _r(0.5, 360)]),
  );
  Widget _r(double off, double base) {
    final t = (anim.value + off) % 1.0;
    return Center(
      child: Transform.scale(
        scale: .85 + t * .35,
        child: Container(
          width: base,
          height: base,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.amber.withOpacity((1 - t) * .07),
              width: .8,
            ),
          ),
        ),
      ),
    );
  }
}
