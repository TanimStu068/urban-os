import 'package:flutter/material.dart';
import 'package:urban_os/widgets/system/bg_painter.dart';

class AnimatedBg extends StatelessWidget {
  final AnimationController ctrl;
  const AnimatedBg({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ctrl,
    builder: (_, __) => CustomPaint(
      painter: BgPainter(ctrl.value),
      child: const SizedBox.expand(),
    ),
  );
}
