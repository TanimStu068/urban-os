import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_dashboard_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'dart:math';

typedef C = AppColors;

class CityMapPainter extends CustomPainter {
  final double mapT, pulseT, glowT;
  final List<DistrictModel> districts;
  final int sensorCount, alertCount, ruleCount;

  CityMapPainter({
    required this.mapT,
    required this.pulseT,
    required this.glowT,
    required this.districts,
    required this.sensorCount,
    required this.alertCount,
    required this.ruleCount,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;

    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFF040C14));

    final gp = Paint()
      ..color = C.cyan.withOpacity(.04)
      ..strokeWidth = .4;
    for (double x = 0; x < w; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gp);
    }
    for (double y = 0; y < h; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gp);
    }

    final rp = Paint()
      ..color = C.cyan.withOpacity(.12)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, h * .33), Offset(w, h * .33), rp);
    canvas.drawLine(Offset(0, h * .66), Offset(w, h * .66), rp);
    canvas.drawLine(Offset(w * .25, 0), Offset(w * .25, h), rp);
    canvas.drawLine(Offset(w * .5, 0), Offset(w * .5, h), rp);
    canvas.drawLine(Offset(w * .75, 0), Offset(w * .75, h), rp);

    // Up to 8 district rects
    final maxD = districts.length.clamp(0, 8);
    final distRects = [
      Rect.fromLTRB(0, 0, w * .25, h * .33),
      Rect.fromLTRB(w * .25, 0, w * .5, h * .33),
      Rect.fromLTRB(w * .5, 0, w * .75, h * .33),
      Rect.fromLTRB(w * .75, 0, w, h * .33),
      Rect.fromLTRB(0, h * .33, w * .25, h * .66),
      Rect.fromLTRB(w * .25, h * .33, w * .5, h * .66),
      Rect.fromLTRB(w * .5, h * .33, w * .75, h * .66),
      Rect.fromLTRB(w * .75, h * .33, w, h * .66),
    ];

    for (int i = 0; i < maxD; i++) {
      final d = districts[i];
      final r = distRects[i];
      final col = d.displayColor;
      canvas.drawRect(r.deflate(2), Paint()..color = col.withOpacity(.04));
      canvas.drawRect(
        r.deflate(2),
        Paint()
          ..color = col.withOpacity(.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = .8,
      );

      final center = r.center;
      _drawText(
        canvas,
        d.shortLabel,
        center.dx,
        center.dy - 12,
        9,
        col.withOpacity(.7),
        FontWeight.normal,
      );

      final barW = r.width * .5;
      final hp = d.healthPercent / 100;
      canvas.drawRect(
        Rect.fromLTWH(center.dx - barW / 2, center.dy + 2, barW, 2),
        Paint()..color = col.withOpacity(.15),
      );
      canvas.drawRect(
        Rect.fromLTWH(center.dx - barW / 2, center.dy + 2, barW * hp, 2),
        Paint()
          ..color = col.withOpacity(.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
      );

      // Pulse on districts with alerts
      if (d.alertCount > 0) {
        final pt = (pulseT + i * .3) % 1.0;
        canvas.drawCircle(
          center,
          8 + pt * 30,
          Paint()
            ..color = col.withOpacity((1 - pt) * .3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    }

    // Building clusters
    final bRng = Random(7);
    for (int i = 0; i < maxD; i++) {
      final r = distRects[i].deflate(12);
      final col = districts[i].displayColor;
      for (int b = 0; b < 6; b++) {
        final bx = r.left + bRng.nextDouble() * r.width;
        final by = r.top + bRng.nextDouble() * r.height;
        final bw = 4 + bRng.nextDouble() * 6, bh = 4 + bRng.nextDouble() * 10;
        canvas.drawRect(
          Rect.fromLTWH(bx, by, bw, bh),
          Paint()..color = col.withOpacity(.12),
        );
        canvas.drawRect(
          Rect.fromLTWH(bx, by, bw, bh),
          Paint()
            ..color = col.withOpacity(.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = .4,
        );
      }
    }

    // Traffic dots
    for (int i = 0; i < 8; i++) {
      final progress = (mapT + i * .125) % 1.0;
      canvas.drawCircle(
        Offset(w * progress, i < 4 ? h * .33 : h * .66),
        2.5,
        Paint()
          ..color = C.amber.withOpacity(.7)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
      );
    }
    for (int i = 0; i < 6; i++) {
      final progress = (mapT + i * .16) % 1.0;
      final vx = i < 2
          ? w * .25
          : i < 4
          ? w * .5
          : w * .75;
      canvas.drawCircle(
        Offset(vx, h * progress),
        2,
        Paint()
          ..color = C.cyan.withOpacity(.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
      );
    }

    // Bottom status row — live data
    final bottomRow = [
      ['${districts.length}', 'DISTRICTS'],
      ['$sensorCount', 'SENSORS'],
      ['$alertCount', 'ALERTS'],
      ['$ruleCount', 'RULES'],
    ];
    final bw2 = w / 4;
    for (int i = 0; i < 4; i++) {
      final bx = i * bw2;
      if (i > 0) {
        canvas.drawLine(
          Offset(bx, h * .66 + 2),
          Offset(bx, h),
          Paint()..color = C.gBdr,
        );
      }

      _drawText(
        canvas,
        bottomRow[i][0],
        bx + bw2 / 2,
        h * .66 + 8,
        15,
        C.cyan,
        FontWeight.w800,
      );
      _drawText(
        canvas,
        bottomRow[i][1],
        bx + bw2 / 2,
        h * .66 + 28,
        7,
        C.muted,
        FontWeight.normal,
        letterSpacing: 1.5,
      );
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    double cx,
    double cy,
    double fontSize,
    Color color,
    FontWeight weight, {
    double letterSpacing = 0,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: weight == FontWeight.w800 ? 'Orbitron' : 'monospace',
          fontSize: fontSize,
          fontWeight: weight,
          color: color,
          letterSpacing: letterSpacing,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(CityMapPainter o) =>
      o.mapT != mapT ||
      o.pulseT != pulseT ||
      o.glowT != glowT ||
      o.districts.length != districts.length ||
      o.alertCount != alertCount;
}
