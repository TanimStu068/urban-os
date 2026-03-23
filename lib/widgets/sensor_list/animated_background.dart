import 'package:flutter/material.dart';
import 'package:urban_os/widgets/sensor_list/bg_painter.dart';

class AnimatedBackground extends StatelessWidget {
  final AnimationController pulse;
  const AnimatedBackground({super.key, required this.pulse});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (_, __) =>
          Positioned.fill(child: CustomPaint(painter: BgPainter(pulse.value))),
    );
  }
}
