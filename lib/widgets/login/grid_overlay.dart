import 'package:flutter/material.dart';
import 'package:urban_os/widgets/login/grid_painter.dart';

class GridOverlay extends StatelessWidget {
  final Animation<double> animation;
  const GridOverlay({super.key, required this.animation});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    builder: (_, __) =>
        CustomPaint(painter: GridPainter(animation.value), size: Size.infinite),
  );
}
