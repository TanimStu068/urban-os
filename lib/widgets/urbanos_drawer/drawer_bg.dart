import 'package:flutter/material.dart';
import 'package:urban_os/widgets/urbanos_drawer/bg_painter.dart';

class DrawerBg extends StatelessWidget {
  final AnimationController pulse;
  const DrawerBg({super.key, required this.pulse});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: pulse,
    builder: (_, __) => CustomPaint(
      painter: BgPainter(pulse.value),
      child: const SizedBox.expand(),
    ),
  );
}
