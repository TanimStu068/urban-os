import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class MiniScorePainter extends CustomPainter {
  final double score, glow;
  const MiniScorePainter({required this.score, required this.glow});

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final r = min(cx, cy) - 3;
    final col = score > 70
        ? C.teal
        : score > 45
        ? C.amber
        : C.red;
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = C.muted.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 2,
      (score / 100) * 2 * pi,
      false,
      Paint()
        ..color = col.withOpacity(0.3 + glow * 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 2,
      (score / 100) * 2 * pi,
      false,
      Paint()
        ..color = col
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(MiniScorePainter o) => o.score != score || o.glow != glow;
}
