import 'package:flutter/material.dart';
import 'package:urban_os/widgets/city_health/grid_painter.dart';

class GridLines extends StatelessWidget {
  final Animation<double> glow;
  const GridLines({super.key, required this.glow});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: glow,
    builder: (_, __) =>
        CustomPaint(painter: GridPainter(glow.value), size: Size.infinite),
  );
}
