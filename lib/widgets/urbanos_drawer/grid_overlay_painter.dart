import 'package:flutter/material.dart';
import 'package:urban_os/widgets/urbanos_drawer/grid_painter.dart';

class GridOverlay extends StatelessWidget {
  const GridOverlay({super.key});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: GridPainter(), child: const SizedBox.expand());
}
