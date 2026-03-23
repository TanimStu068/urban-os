import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

// Traffic theme accent
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

class TrafficLinePainter extends CustomPainter {
  final List<double> data;
  final double progress, glowT;
  TrafficLinePainter({
    required this.data,
    required this.progress,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final minV = 0.0, maxV = 1400.0;
    const padT = 16.0, padB = 20.0, padL = 32.0, padR = 8.0;
    final w = s.width - padL - padR, h = s.height - padT - padB;

    // Y grid
    for (int i = 0; i <= 4; i++) {
      final y = padT + h - (i / 4) * h;
      canvas.drawLine(
        Offset(padL, y),
        Offset(s.width - padR, y),
        Paint()
          ..color = kAccent.withOpacity(.05)
          ..strokeWidth = .5,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: '${(i * 350).toStringAsFixed(0)}',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: kAccent.withOpacity(.35),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // X axis labels (hours)
    for (int i = 0; i < data.length; i += 4) {
      final x = padL + (i / (data.length - 1)) * w;
      final tp = TextPainter(
        text: TextSpan(
          text: '${i}h',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: kAccent.withOpacity(.35),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, s.height - padB + 5));
    }

    final pts = List.generate(
      data.length,
      (i) => Offset(
        padL + (i / (data.length - 1)) * w,
        padT + h - ((data[i] - minV) / (maxV - minV)) * h,
      ),
    );

    final drawCount = (pts.length * progress).ceil().clamp(2, pts.length);
    final visible = pts.sublist(0, drawCount);

    // Fill
    final fill = Path()..moveTo(visible.first.dx, padT + h);
    for (final p in visible) fill.lineTo(p.dx, p.dy);
    fill
      ..lineTo(visible.last.dx, padT + h)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kAccent.withOpacity(.2), Colors.transparent],
        ).createShader(Rect.fromLTWH(padL, padT, w, h)),
    );

    // Line
    final line = Path()..moveTo(visible.first.dx, visible.first.dy);
    for (int i = 1; i < visible.length; i++) {
      final prev = visible[i - 1], cur = visible[i];
      final cpx = (prev.dx + cur.dx) / 2;
      line.cubicTo(cpx, prev.dy, cpx, cur.dy, cur.dx, cur.dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = kAccent
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = kAccent.withOpacity(.25)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Peak marker
    int peakIdx = 0;
    for (int i = 1; i < data.length; i++)
      if (data[i] > data[peakIdx]) peakIdx = i;
    if (peakIdx < visible.length) {
      final pp = visible[peakIdx];
      canvas.drawCircle(
        pp,
        5,
        Paint()
          ..color = C.red.withOpacity(.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(pp, 3, Paint()..color = C.red);
      final tp = TextPainter(
        text: const TextSpan(
          text: 'PEAK',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: C.red,
            letterSpacing: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(pp.dx - tp.width / 2, pp.dy - 15));
    }

    // Live dot at end
    if (visible.isNotEmpty) {
      final last = visible.last;
      canvas.drawCircle(
        last,
        4,
        Paint()
          ..color = kAccent.withOpacity(.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(last, 2.5, Paint()..color = kAccent);
      canvas.drawCircle(last, 1, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(TrafficLinePainter o) =>
      o.progress != progress || o.glowT != glowT;
}
