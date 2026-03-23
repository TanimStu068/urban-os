import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;
const kAccent = C.cyan;

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final double glowT;
  SparklinePainter({required this.data, required this.glowT});

  @override
  void paint(Canvas canvas, Size s) {
    if (data.length < 2) return;
    const padX = 6.0, padY = 8.0;
    final w = s.width - padX * 2, h = s.height - padY * 2;
    final minV = data.reduce(min) - 5, maxV = data.reduce(max) + 5;

    final pts = List.generate(
      data.length,
      (i) => Offset(
        padX + (i / (data.length - 1)) * w,
        padY + h - ((data[i] - minV) / (maxV - minV)) * h,
      ),
    );

    final fill = Path()..moveTo(pts.first.dx, padY + h);
    for (final p in pts) fill.lineTo(p.dx, p.dy);
    fill
      ..lineTo(pts.last.dx, padY + h)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [C.green.withOpacity(0.18), Colors.transparent],
        ).createShader(Rect.fromLTWH(padX, padY, w, h)),
    );

    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      final p = pts[i - 1], c = pts[i], cpx = (p.dx + c.dx) / 2;
      line.cubicTo(cpx, p.dy, cpx, c.dy, c.dx, c.dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = C.green.withOpacity(0.25 + glowT * 0.1)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = C.green
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    for (final p in pts) {
      canvas.drawCircle(p, 1.5, Paint()..color = C.green);
    }

    final avg = data.reduce((a, b) => a + b) / data.length;
    final avgY = padY + h - ((avg - minV) / (maxV - minV)) * h;
    final avgPath = Path()
      ..moveTo(padX, avgY)
      ..lineTo(padX + w, avgY);
    final dashedAvgPath = dashPath(
      avgPath,
      dashArray: CircularIntervalList<double>([4, 6]),
    );
    canvas.drawPath(
      dashedAvgPath,
      Paint()
        ..color = kAccent.withOpacity(0.2)
        ..strokeWidth = 0.7
        ..style = PaintingStyle.stroke,
    );

    final atp = TextPainter(
      text: TextSpan(
        text: 'AVG ${avg.toStringAsFixed(0)}s',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 6,
          color: kAccent.withOpacity(0.4),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    atp.paint(canvas, Offset(padX + w - atp.width, avgY - 10));
  }

  @override
  bool shouldRepaint(SparklinePainter o) => o.glowT != glowT;
}
