import 'package:flutter/material.dart';
import 'package:urban_os/widgets/system/grid_painter.dart';

class GridPaint extends StatelessWidget {
  const GridPaint({super.key});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: GridPainter(), child: const SizedBox.expand());
}
