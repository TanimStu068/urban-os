import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

class CitySilhouettePainter extends CustomPainter {
  final String side;
  const CitySilhouettePainter({required this.side});

  @override
  void paint(Canvas canvas, Size size) {
    final isLeft = side == 'left';
    final paint = Paint()
      ..color = AppColors.cyan.withOpacity(0.04)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = AppColors.cyan.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final rng = Random(isLeft ? 11 : 22);
    final path = Path();
    final spath = Path();
    double x = isLeft ? size.width : 0;

    path.moveTo(x, size.height);
    spath.moveTo(x, size.height);

    final buildings = 8;
    final bWidth = size.width / buildings;

    for (int i = 0; i < buildings; i++) {
      final bx = isLeft ? size.width - (i + 1) * bWidth : i * bWidth;
      final bh = size.height * (0.3 + rng.nextDouble() * 0.6);
      final bw = bWidth * (0.6 + rng.nextDouble() * 0.3);
      final offset = bWidth * rng.nextDouble() * 0.2;

      final rect = Rect.fromLTWH(bx + offset, size.height - bh, bw, bh);
      path.addRect(rect);
      spath.addRect(rect);

      // windows
      final winPaint = Paint()..color = AppColors.cyan.withOpacity(0.15);
      for (int wy = 0; wy < (bh / 14).floor(); wy++) {
        for (int wx = 0; wx < (bw / 10).floor(); wx++) {
          if (rng.nextBool()) {
            canvas.drawRect(
              Rect.fromLTWH(
                bx + offset + 3 + wx * 10,
                size.height - bh + 6 + wy * 14,
                4,
                6,
              ),
              winPaint,
            );
          }
        }
      }
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(spath, stroke);
  }

  @override
  bool shouldRepaint(_) => false;
}
