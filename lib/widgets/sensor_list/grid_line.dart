import 'package:flutter/material.dart';
import 'package:urban_os/widgets/sensor_list/grid_painter.dart';

class GridLines extends StatelessWidget {
  const GridLines({super.key});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: GridPainter(), child: const SizedBox.expand());
}
