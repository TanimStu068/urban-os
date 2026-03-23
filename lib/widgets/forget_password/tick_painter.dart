import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class TickPainterWidget extends CustomPainter {
  final double t;
  TickPainterWidget(this.t);
  @override
  void paint(Canvas canvas, Size s) {
    if (t < 0.3) return;
    final progress = ((t - 0.3) / 0.7).clamp(0.0, 1.0);
    final path = Path()
      ..moveTo(s.width * .28, s.height * .52)
      ..lineTo(s.width * .44, s.height * .66)
      ..lineTo(s.width * .72, s.height * .38);
    final m = path.computeMetrics().first;
    final p = Paint()
      ..color = AppColors.teal
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(m.extractPath(0, m.length * progress), p);
  }

  @override
  bool shouldRepaint(TickPainterWidget o) => o.t != t;
}
