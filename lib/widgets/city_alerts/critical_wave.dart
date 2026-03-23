import 'package:flutter/material.dart';
import 'package:urban_os/widgets/city_alerts/wave_painter.dart';

class CriticalWave extends StatelessWidget {
  final AnimationController anim;
  final int count;
  const CriticalWave({super.key, required this.anim, required this.count});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: 180,
        child: CustomPaint(
          painter: WavePainter(
            t: anim.value,
            intensity: count.clamp(0, 3) / 3.0,
          ),
        ),
      ),
    );
  }
}
