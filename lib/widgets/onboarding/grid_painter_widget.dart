import 'package:flutter/material.dart';
import 'package:urban_os/widgets/onboarding/grid_painter.dart';

class GridPainterWidget extends StatelessWidget {
  const GridPainterWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: GridPainter(), child: Container());
  }
}
