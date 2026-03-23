import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

const kAccent = C.cyan;

class OccupancyLinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double progress, glowT;
  OccupancyLinePainter({
    required this.data,
    required this.color,
    required this.progress,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    const padT = 14.0, padB = 22.0, padL = 28.0, padR = 8.0;
    final w = s.width - padL - padR, h = s.height - padT - padB;

    for (int i = 0; i <= 4; i++) {
      final y = padT + h - (i / 4) * h;
      canvas.drawLine(
        Offset(padL, y),
        Offset(s.width - padR, y),
        Paint()
          ..color = color.withOpacity(0.06)
          ..strokeWidth = 0.5,
      );
      _txt(
        canvas,
        '${i * 25}%',
        Offset(0, y - 3.5),
        6.5,
        color.withOpacity(0.35),
      );
    }
    for (int i = 0; i < 24; i += 4) {
      final x = padL + (i / 23) * w;
      _txt(
        canvas,
        '${i}h',
        Offset(x - 5, s.height - padB + 5),
        6.5,
        kAccent.withOpacity(0.3),
      );
    }

    final pts = List.generate(
      data.length,
      (i) => Offset(
        padL + (i / (data.length - 1)) * w,
        padT + h - (data[i].clamp(0, 100) / 100) * h,
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
          colors: [color.withOpacity(0.22), Colors.transparent],
        ).createShader(Rect.fromLTWH(padL, padT, w, h)),
    );

    final line = Path()..moveTo(vis.first.dx, vis.first.dy);
    for (int i = 1; i < vis.length; i++) {
      final p = vis[i - 1], c = vis[i], cpx = (p.dx + c.dx) / 2;
      line.cubicTo(cpx, p.dy, cpx, c.dy, c.dx, c.dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = color.withOpacity(0.3 + glowT * 0.1)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Peak marker
    int pk = 0;
    for (int i = 1; i < data.length; i++) if (data[i] > data[pk]) pk = i;
    if (pk < vis.length) {
      final pp = vis[pk];
      canvas.drawCircle(
        pp,
        6,
        Paint()
          ..color = C.red.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(pp, 3, Paint()..color = C.red);
      _txt(canvas, 'PEAK', Offset(pp.dx - 10, pp.dy - 16), 7, C.red);
    }
    if (vis.isNotEmpty) {
      final last = vis.last;
      canvas.drawCircle(
        last,
        5,
        Paint()
          ..color = color.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
      canvas.drawCircle(last, 2.5, Paint()..color = color);
      canvas.drawCircle(last, 1, Paint()..color = Colors.white);
    }
  }

  void _txt(Canvas c, String t, Offset p, double sz, Color col) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(fontFamily: 'monospace', fontSize: sz, color: col),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(OccupancyLinePainter o) =>
      o.progress != progress || o.glowT != glowT;
}
