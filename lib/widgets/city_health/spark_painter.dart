import 'package:flutter/material.dart';
import 'dart:math';

class SparkPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  SparkPainter({required this.data, required this.color});
  @override
  void paint(Canvas canvas, Size s) {
    if (data.length < 2) return;
    final minV = data.reduce(min) * .92;
    final maxV = data.reduce(max) * 1.05;
    final range = maxV - minV;
    if (range == 0) return;
    final pts = List.generate(
      data.length,
      (i) => Offset(
        i / (data.length - 1) * s.width,
        s.height - (data[i] - minV) / range * s.height,
      ),
    );

    // Fill
    final fp = Path()..moveTo(pts.first.dx, s.height);
    for (final p in pts) {
      fp.lineTo(p.dx, p.dy);
    }
    fp
      ..lineTo(pts.last.dx, s.height)
      ..close();
    canvas.drawPath(
      fp,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(.2), Colors.transparent],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );

    // Line
    final lp = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      final cp = (pts[i - 1].dx + pts[i].dx) / 2;
      lp.cubicTo(cp, pts[i - 1].dy, cp, pts[i].dy, pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(
      lp,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Dot
    canvas.drawCircle(
      pts.last,
      3.5,
      Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawCircle(pts.last, 2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(SparkPainter o) => o.data != data;
}
