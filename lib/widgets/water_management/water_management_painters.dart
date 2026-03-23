import 'dart:math';
import 'package:flutter/material.dart';
import 'water_management_models.dart';

class BgPainter extends CustomPainter {
  final double t;
  final double glow;
  const BgPainter({required this.t, required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-.3, -.5),
          colors: [const Color(0xFF041520), C.bg],
          radius: 1.8,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    final glv = (sin(t * pi * 2) + 1) / 2;
    final gp = Paint()
      ..color = C.cyan.withOpacity(.006 * (0.5 + glv * .3))
      ..strokeWidth = .3;
    for (double x = 0; x < size.width; x += 48)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gp);
    for (double y = 0; y < size.height; y += 48)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gp);
    canvas.drawCircle(
      Offset(size.width * .85, size.height * .2),
      160,
      Paint()
        ..color = C.cyan.withOpacity(.015 + glv * .008)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90),
    );
    canvas.drawCircle(
      Offset(size.width * .12, size.height * .75),
      110,
      Paint()
        ..color = C.teal.withOpacity(.012 + glv * .006)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 70),
    );
  }

  @override
  bool shouldRepaint(covariant BgPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.glow != glow;
}

class WavePainter extends CustomPainter {
  final double t;
  const WavePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (int layer = 0; layer < 2; layer++) {
      final path = Path();
      path.moveTo(0, size.height);
      final offset = layer == 0 ? 0.0 : 1.2;
      final amp1 = layer == 0 ? .20 : .14;
      final amp2 = layer == 0 ? .08 : .06;
      final base = layer == 0 ? .42 : .55;
      for (double x = 0; x <= size.width; x += 2) {
        final y =
            size.height * base +
            sin(x / size.width * pi * 3 + t * pi * 2 + offset) *
                size.height *
                amp1 +
            sin(x / size.width * pi * 5 + t * pi * 1.4) * size.height * amp2;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.close();
      final c = layer == 0 ? C.cyan : C.teal;
      canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              c.withOpacity(layer == 0 ? .035 : .02),
              c.withOpacity(.005),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => oldDelegate.t != t;
}

class SDArcPainter extends CustomPainter {
  final double fill;
  final Color color;

  const SDArcPainter(this.fill, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide / 2 - 8;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      pi * .75,
      pi * 1.5,
      false,
      Paint()
        ..color = C.muted.withOpacity(.3)
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    if (fill > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        pi * .75,
        pi * 1.5 * fill,
        false,
        Paint()
          ..shader = SweepGradient(
            startAngle: pi * .75,
            endAngle: pi * .75 + pi * 1.5 * fill,
            colors: [color.withOpacity(.6), color],
          ).createShader(Rect.fromCircle(center: center, radius: r))
          ..strokeWidth = 8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        pi * .75,
        pi * 1.5 * fill,
        false,
        Paint()
          ..color = color.withOpacity(.25)
          ..strokeWidth = 14
          ..style = PaintingStyle.stroke
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant SDArcPainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.color != color;
}

class HealthRingPainter extends CustomPainter {
  final double score;
  final double pulse;
  final Color color;

  const HealthRingPainter(this.score, this.color, this.pulse);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide / 2 - 8;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      -pi / 2,
      pi * 2,
      false,
      Paint()
        ..color = C.muted.withOpacity(.25)
        ..strokeWidth = 7
        ..style = PaintingStyle.stroke,
    );

    if (score > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        -pi / 2,
        pi * 2 * score,
        false,
        Paint()
          ..shader = SweepGradient(
            startAngle: -pi / 2,
            endAngle: -pi / 2 + pi * 2 * score,
            colors: [color.withOpacity(.5), color],
          ).createShader(Rect.fromCircle(center: center, radius: r))
          ..strokeWidth = 7
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        -pi / 2,
        pi * 2 * score,
        false,
        Paint()
          ..color = color.withOpacity(.15 + pulse * .08)
          ..strokeWidth = 13
          ..style = PaintingStyle.stroke
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant HealthRingPainter oldDelegate) =>
      oldDelegate.score != score ||
      oldDelegate.pulse != pulse ||
      oldDelegate.color != color;
}

class HourlyPainter extends CustomPainter {
  final List<HrUsage> data;
  final double t;

  const HourlyPainter(this.data, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final mx = data.map((d) => d.supply).reduce(max) * 1.1;
    final dx = size.width / (data.length - 1);

    Path curve(List<double> vals) {
      final path = Path();
      for (int i = 0; i < vals.length; i++) {
        final x = i * dx;
        final y = size.height - (vals[i] / mx * size.height);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          final cx = (x + (i - 1) * dx) / 2;
          path.quadraticBezierTo(
            cx,
            size.height - (vals[i - 1] / mx * size.height),
            x,
            y,
          );
        }
      }
      return path;
    }

    final supVals = data.map((d) => d.supply).toList();
    final conVals = data.map((d) => d.cons).toList();
    final supPath = curve(supVals);
    final conPath = curve(conVals);

    final supFill = Path.from(supPath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      supFill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [C.teal.withOpacity(.18), C.teal.withOpacity(.02)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    canvas.drawPath(
      conPath,
      Paint()
        ..color = C.cyan.withOpacity(.85)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      supPath,
      Paint()
        ..color = C.teal.withOpacity(.75)
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    final idx = (t * data.length).floor().clamp(0, data.length - 1);
    final px = idx * dx;
    final py = size.height - (conVals[idx] / mx * size.height);
    canvas.drawCircle(
      Offset(px, py),
      8,
      Paint()
        ..color = C.cyan.withOpacity(.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(Offset(px, py), 4, Paint()..color = C.cyan);

    for (int i = 1; i <= 3; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 4),
        Offset(size.width, size.height * i / 4),
        Paint()
          ..color = C.cyan.withOpacity(.04)
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HourlyPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.data != data;
}

class TankVizPainter extends CustomPainter {
  final double level;
  final Color color;

  const TankVizPainter(this.level, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final rr = RRect.fromRectAndRadius(
      Rect.fromLTWH(4, 6, size.width - 8, size.height - 6),
      const Radius.circular(5),
    );
    canvas.drawRRect(
      rr,
      Paint()
        ..color = color.withOpacity(.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    final fillHeight = (size.height - 6) * level;
    canvas.save();
    canvas.clipRect(
      Rect.fromLTWH(0, size.height - fillHeight, size.width, fillHeight),
    );
    canvas.drawRRect(
      rr,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(.25), color.withOpacity(.55)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    canvas.restore();
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * .3, 1, size.width * .4, 8),
        const Radius.circular(3),
      ),
      Paint()..color = color.withOpacity(.4),
    );
    canvas.drawRRect(
      rr,
      Paint()
        ..color = color.withOpacity(.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant TankVizPainter oldDelegate) =>
      oldDelegate.level != level || oldDelegate.color != color;
}

class MiniLinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  const MiniLinePainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;
    final mn = data.reduce(min);
    final mx = data.reduce(max);
    final rng = mx - mn == 0 ? 1.0 : mx - mn;
    final dx = size.width / (data.length - 1);

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = i * dx;
      final y =
          size.height -
          ((data[i] - mn) / rng * size.height * .85 + size.height * .075);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final cx = (x + (i - 1) * dx) / 2;
        path.quadraticBezierTo(
          cx,
          size.height -
              ((data[i - 1] - mn) / rng * size.height * .85 +
                  size.height * .075),
          x,
          y,
        );
      }
    }

    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(.2), color.withOpacity(.02)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withOpacity(.7)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant MiniLinePainter oldDelegate) => false;
}

class MiniBarPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  const MiniBarPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final mx = data.reduce(max);
    if (mx == 0) return;
    final bw = size.width / data.length - 1;
    for (int i = 0; i < data.length; i++) {
      final h = data[i] / mx * size.height * .9;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(i * (bw + 1), size.height - h, bw, h),
          const Radius.circular(2),
        ),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(.6), color.withOpacity(.3)],
          ).createShader(Rect.fromLTWH(0, 0, bw, size.height)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant MiniBarPainter oldDelegate) => false;
}

class PumpDialPainter extends CustomPainter {
  final double speed;
  final double t;
  final Color color;

  const PumpDialPainter(this.speed, this.color, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide / 2 - 2;
    canvas.drawCircle(c, r, Paint()..color = color.withOpacity(.08));
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = color.withOpacity(.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    if (speed > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r - 4),
        -pi / 2 + t * pi * 2,
        pi * 2 * speed,
        false,
        Paint()
          ..color = color.withOpacity(.7)
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.drawCircle(c, 4, Paint()..color = color.withOpacity(.9));
    canvas.drawCircle(
      c,
      7,
      Paint()
        ..color = color.withOpacity(.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  @override
  bool shouldRepaint(covariant PumpDialPainter oldDelegate) =>
      oldDelegate.t != t ||
      oldDelegate.speed != speed ||
      oldDelegate.color != color;
}

class TopoPainter extends CustomPainter {
  final List<WaterPipe> pipes;
  final double t;

  static const Map<String, Offset> nodes = {
    'WTP': Offset(.5, .05),
    'T-01': Offset(.15, .25),
    'T-02': Offset(.75, .25),
    'T-03': Offset(.35, .55),
    'T-04': Offset(.85, .5),
    'T-05': Offset(.2, .75),
    'T-06': Offset(.6, .4),
    'Z-RES': Offset(.05, .55),
    'Z-IND': Offset(.9, .7),
    'Z-MED': Offset(.42, .85),
    'Z-COM': Offset(.7, .85),
    'Z-IRR': Offset(.1, .95),
    'Z-EMR': Offset(.85, .85),
  };

  const TopoPainter(this.pipes, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final anim = (sin(t * pi * 2) + 1) / 2;
    for (final p in pipes) {
      final from = nodes[p.fromNode];
      final to = nodes[p.toNode];
      if (from == null || to == null) continue;
      final a = Offset(from.dx * size.width, from.dy * size.height);
      final b = Offset(to.dx * size.width, to.dy * size.height);
      canvas.drawLine(
        a,
        b,
        Paint()
          ..color = p.status.color.withOpacity(.35)
          ..strokeWidth = p.diameterMM / 150
          ..strokeCap = StrokeCap.round,
      );
      if (p.status.isActive) {
        final pos = (t * 1.5) % 1.0;
        canvas.drawCircle(
          Offset(a.dx + (b.dx - a.dx) * pos, a.dy + (b.dy - a.dy) * pos),
          3,
          Paint()
            ..color = p.status.color.withOpacity(.7 + anim * .2)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
    }
    for (final entry in nodes.entries) {
      final pos = Offset(
        entry.value.dx * size.width,
        entry.value.dy * size.height,
      );
      final isTank = entry.key.startsWith('T-');
      final isWTP = entry.key == 'WTP';
      final color = isWTP
          ? C.violet
          : isTank
          ? C.cyan
          : C.teal;
      final r = isWTP
          ? 7.0
          : isTank
          ? 5.5
          : 4.0;
      canvas.drawCircle(
        pos,
        r + 2,
        Paint()
          ..color = color.withOpacity(.15 + anim * .05)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.drawCircle(pos, r, Paint()..color = color.withOpacity(.8));
      final tp = TextPainter(
        text: TextSpan(
          text: entry.key,
          style: TextStyle(
            color: color.withOpacity(.7),
            fontSize: 6,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy + r + 2));
    }
  }

  @override
  bool shouldRepaint(covariant TopoPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.pipes != pipes;
}
