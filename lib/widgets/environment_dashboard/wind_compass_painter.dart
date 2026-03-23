import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class WindCompassPainter extends CustomPainter {
  final double deg, speed, glow, animT;
  const WindCompassPainter({
    required this.deg,
    required this.speed,
    required this.glow,
    required this.animT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final r = min(cx, cy) - 8;

    // Outer ring
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = C.muted.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.65,
      Paint()
        ..color = C.muted.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // Cardinal direction ticks & labels
    const dirs = ['N', 'E', 'S', 'W'];
    for (int i = 0; i < 4; i++) {
      final a = i * pi / 2 - pi / 2;
      final innerR = r * 0.88;
      final outerR = r;
      canvas.drawLine(
        Offset(cx + cos(a) * innerR, cy + sin(a) * innerR),
        Offset(cx + cos(a) * outerR, cy + sin(a) * outerR),
        Paint()
          ..color = C.teal.withOpacity(0.6)
          ..strokeWidth = 2,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: dirs[i],
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            fontWeight: FontWeight.w900,
            color: C.teal,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          cx + cos(a) * (r + 10) - tp.width / 2,
          cy + sin(a) * (r + 10) - tp.height / 2,
        ),
      );
    }
    for (int i = 0; i < 4; i++) {
      final a = i * pi / 2 - pi / 4;
      canvas.drawLine(
        Offset(cx + cos(a) * r * 0.9, cy + sin(a) * r * 0.9),
        Offset(cx + cos(a) * r, cy + sin(a) * r),
        Paint()
          ..color = C.mutedLt.withOpacity(0.5)
          ..strokeWidth = 1,
      );
    }

    // Animated wind ripples
    for (int ring = 1; ring <= 3; ring++) {
      final ringR = r * 0.22 * ring;
      final alpha = (0.15 - ring * 0.03).clamp(0.0, 0.15) + glow * 0.04;
      canvas.drawCircle(
        Offset(cx, cy),
        ringR,
        Paint()
          ..color = C.teal.withOpacity(alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }

    // Wind direction arrow
    final arrowAngle = deg * pi / 180 - pi / 2;
    final arrowLen = r * 0.65;
    final arrowEnd = Offset(
      cx + cos(arrowAngle) * arrowLen,
      cy + sin(arrowAngle) * arrowLen,
    );
    final arrowBase = Offset(
      cx - cos(arrowAngle) * arrowLen * 0.4,
      cy - sin(arrowAngle) * arrowLen * 0.4,
    );

    // Glow trail
    canvas.drawLine(
      arrowBase,
      arrowEnd,
      Paint()
        ..color = C.teal.withOpacity(0.3 + glow * 0.15)
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // Arrow body
    canvas.drawLine(
      arrowBase,
      arrowEnd,
      Paint()
        ..color = C.teal
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    // Arrowhead
    final perpA = arrowAngle + pi / 2;
    final tipX = arrowEnd.dx, tipY = arrowEnd.dy;
    final w = 7.0;
    final headPts = [
      Offset(tipX, tipY),
      Offset(
        tipX - cos(arrowAngle) * 12 + cos(perpA) * w,
        tipY - sin(arrowAngle) * 12 + sin(perpA) * w,
      ),
      Offset(
        tipX - cos(arrowAngle) * 12 - cos(perpA) * w,
        tipY - sin(arrowAngle) * 12 - sin(perpA) * w,
      ),
    ];
    canvas.drawPath(
      Path()..addPolygon(headPts, true),
      Paint()
        ..color = C.teal
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glow * 2),
    );
    canvas.drawPath(Path()..addPolygon(headPts, true), Paint()..color = C.teal);

    // Center hub
    canvas.drawCircle(Offset(cx, cy), 5, Paint()..color = C.bgCard);
    canvas.drawCircle(
      Offset(cx, cy),
      5,
      Paint()
        ..color = C.teal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Speed label
    final speedColor = speed > 50
        ? C.red
        : speed > 30
        ? C.amber
        : C.teal;
    final tp = TextPainter(
      text: TextSpan(
        text: '${speed.toStringAsFixed(0)}',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: speedColor,
          shadows: [Shadow(color: speedColor, blurRadius: 5)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2 + 4));
  }

  @override
  bool shouldRepaint(WindCompassPainter o) => o.deg != deg || o.glow != glow;
}
