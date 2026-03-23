import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

const kAccent = C.cyan;

class ChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double maxVal, progress, glowT;
  final String label;
  ChartPainter({
    required this.data,
    required this.color,
    required this.maxVal,
    required this.label,
    required this.progress,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    const padT = 14.0, padB = 22.0, padL = 34.0, padR = 8.0;
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
      _paintTxt(
        canvas,
        (maxVal / 4 * i).toStringAsFixed(0),
        Offset(0, y - 3.5),
        6.5,
        color.withOpacity(0.35),
      );
    }
    for (int i = 0; i < data.length; i += 4) {
      final x = padL + (i / (data.length - 1)) * w;
      _paintTxt(
        canvas,
        '${i}h',
        Offset(x - 4, s.height - padB + 5),
        6.5,
        kAccent.withOpacity(0.3),
      );
    }

    final pts = List.generate(
      data.length,
      (i) => Offset(
        padL + (i / (data.length - 1)) * w,
        padT + h - (data[i].clamp(0, maxVal) / maxVal) * h,
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
        ..strokeWidth = 7
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

    int peakIdx = 0;
    for (int i = 1; i < data.length; i++)
      if (data[i] > data[peakIdx]) peakIdx = i;
    if (peakIdx < vis.length) {
      final pp = vis[peakIdx];
      canvas.drawCircle(
        pp,
        6,
        Paint()
          ..color = C.red.withOpacity(0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(pp, 3, Paint()..color = C.red);
      _paintTxt(canvas, 'PEAK', Offset(pp.dx - 9, pp.dy - 16), 7, C.red);
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
      canvas.drawCircle(last, 3, Paint()..color = color);
      canvas.drawCircle(last, 1.5, Paint()..color = Colors.white);
    }
  }

  void _paintTxt(Canvas canvas, String t, Offset pos, double sz, Color col) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(fontFamily: 'monospace', fontSize: sz, color: col),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(ChartPainter o) =>
      o.progress != progress || o.glowT != glowT;
}
