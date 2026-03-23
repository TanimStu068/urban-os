import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

class WavePainter extends CustomPainter {
  final double t, intensity;
  WavePainter({required this.t, required this.intensity});
  @override
  void paint(Canvas canvas, Size s) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [C.red.withOpacity(.06 * intensity), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, s.width, s.height));
    canvas.drawRect(Offset.zero & s, paint);

    // Sine wave lines
    for (int w = 0; w < 3; w++) {
      final path = Path();
      final wOffset = w * 0.3;
      path.moveTo(0, s.height * 0.4);
      for (double x = 0; x <= s.width; x += 2) {
        final y =
            s.height * 0.4 +
            sin((x / s.width * 2 * pi) + t * 2 * pi + wOffset) *
                (8.0 + w * 4) *
                intensity;
        x == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = C.red.withOpacity((.04 - w * .01) * intensity)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(WavePainter o) => o.t != t;
}
