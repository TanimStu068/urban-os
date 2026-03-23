import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  SparklinePainter({required this.data, required this.color});
  @override
  void paint(Canvas canvas, Size s) {
    if (data.length < 2) return;
    final minV = data.reduce(min) * .9, maxV = data.reduce(max) * 1.05;
    final range = maxV - minV;
    if (range == 0) return;
    final pts = List.generate(
      data.length,
      (i) => Offset(
        i / (data.length - 1) * s.width,
        s.height - (data[i] - minV) / range * s.height,
      ),
    );
    final fp = Path()..moveTo(pts.first.dx, s.height);

    fp
      ..lineTo(pts.last.dx, s.height)
      ..close();
    canvas.drawPath(
      fp,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(.25), Colors.transparent],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );
    final lp = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      final prev = pts[i - 1], curr = pts[i], cpx = (prev.dx + curr.dx) / 2;
      lp.cubicTo(cpx, prev.dy, cpx, curr.dy, curr.dx, curr.dy);
    }
    canvas.drawPath(
      lp,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );
    canvas.drawCircle(
      pts.last,
      4,
      Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawCircle(pts.last, 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(SparklinePainter o) => o.data != data;
}
