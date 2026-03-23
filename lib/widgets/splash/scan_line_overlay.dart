import 'package:flutter/material.dart';
import 'package:urban_os/widgets/splash/scan_line_painter.dart';

class ScanlineOverlay extends StatelessWidget {
  const ScanlineOverlay({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: ScanlinePainter(), size: Size.infinite);
  }
}
