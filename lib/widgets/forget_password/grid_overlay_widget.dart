import 'package:flutter/material.dart';
import 'package:urban_os/widgets/forget_password/grid_painter_widget.dart';

class GridOverlay extends StatelessWidget {
  final Animation<double> anim;
  const GridOverlay({super.key, required this.anim});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: anim,
    builder: (_, __) =>
        CustomPaint(painter: GridPainter(anim.value), size: Size.infinite),
  );
}
