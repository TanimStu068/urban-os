import 'package:flutter/material.dart';

class RoadHistoryPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double progress;
  RoadHistoryPainter({
    required this.data,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size s) {
    const padT = 10.0, padB = 20.0, padL = 24.0, padR = 8.0;
    final w = s.width - padL - padR, h = s.height - padT - padB;
    const minV = 0.0, maxV = 100.0;

    for (int i = 0; i <= 4; i++) {
      final y = padT + h - (i / 4) * h;
      canvas.drawLine(
        Offset(padL, y),
        Offset(s.width - padR, y),
        Paint()
          ..color = color.withOpacity(.06)
          ..strokeWidth = .4,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: '${(i * 25)}%',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: color.withOpacity(.4),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    for (int i = 0; i < 24; i += 6) {
      final x = padL + (i / 23) * w;
      final tp = TextPainter(
        text: TextSpan(
          text: '${i}h',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 6,
            color: color.withOpacity(.4),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, s.height - padB + 4));
    }

    final pts = List.generate(
      data.length,
      (i) => Offset(
        padL + (i / (data.length - 1)) * w,
        padT + h - ((data[i] - minV) / (maxV - minV)) * h,
      ),
    );
    final dc = (pts.length * progress).ceil().clamp(2, pts.length);
    final vis = pts.sublist(0, dc);

    final fill = Path()..moveTo(vis.first.dx, padT + h);
    for (final p in vis) fill.lineTo(p.dx, p.dy);
    fill
      ..lineTo(vis.last.dx, padT + h)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(.18), Colors.transparent],
        ).createShader(Rect.fromLTWH(padL, padT, w, h)),
    );

    final line = Path()..moveTo(vis.first.dx, vis.first.dy);
    for (int i = 1; i < vis.length; i++) {
      final p = vis[i - 1], c = vis[i];
      line.cubicTo(
        (p.dx + c.dx) / 2,
        p.dy,
        (p.dx + c.dx) / 2,
        c.dy,
        c.dx,
        c.dy,
      );
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = color.withOpacity(.25)
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  @override
  bool shouldRepaint(RoadHistoryPainter o) => o.progress != progress;
}
