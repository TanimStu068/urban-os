import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SparkFill extends CustomPainter {
  final List<double> data;
  final Color color;
  final double glow, dangerLine;
  const SparkFill({
    required this.data,
    required this.color,
    required this.glow,
    required this.dangerLine,
  });

  @override
  void paint(Canvas canvas, Size s) {
    if (data.length < 2) return;
    final maxV = data.reduce(max).clamp(1.0, double.infinity);
    final path = Path(), fill = Path();
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * s.width;
      final y = s.height - (data[i] / maxV).clamp(0, 1) * s.height;
      if (i == 0) {
        path.moveTo(x, y);
        fill.moveTo(x, s.height);
        fill.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fill.lineTo(x, y);
      }
    }
    fill.lineTo(s.width, s.height);
    fill.close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.18 + glow * 0.06), color.withOpacity(0)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1 + glow * 0.5),
    );

    // Danger threshold line
    if (dangerLine > 0 && dangerLine < maxV) {
      final dy = s.height - (dangerLine / maxV) * s.height;
      canvas.drawLine(
        Offset(0, dy),
        Offset(s.width, dy),
        Paint()
          ..color = C.amber.withOpacity(0.5)
          ..strokeWidth = 0.8,
      );
    }
  }

  @override
  bool shouldRepaint(SparkFill o) => o.glow != glow;
}
