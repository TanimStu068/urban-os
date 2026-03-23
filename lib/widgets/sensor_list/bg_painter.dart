import 'package:flutter/material.dart';

class BgPainter extends CustomPainter {
  final double t;
  BgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Deep navy base
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF050911),
    );

    // Top-left radial bleed — cyan
    final p1 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFF00D4FF).withOpacity(0.07 + t * 0.04),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.15, size.height * 0.08),
              radius: size.width * 0.55,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.08),
      size.width * 0.55,
      p1,
    );

    // Bottom-right radial bleed — amber
    final p2 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFFFFAA00).withOpacity(0.05 + t * 0.03),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.9, size.height * 0.9),
              radius: size.width * 0.45,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.9),
      size.width * 0.45,
      p2,
    );
  }

  @override
  bool shouldRepaint(BgPainter old) => old.t != t;
}
