import 'package:flutter/material.dart';

class BgPainter extends CustomPainter {
  final double t;
  BgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Deep base
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF050A12),
    );

    void radial(Offset c, double r, Color col, double opacity) {
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [col.withOpacity(opacity), Colors.transparent],
          ).createShader(Rect.fromCircle(center: c, radius: r)),
      );
    }

    // Cyan top bleed
    radial(
      Offset(size.width * 0.2, size.height * 0.05),
      size.width * 0.85,
      const Color(0xFF00D4FF),
      0.06 + t * 0.04,
    );

    // Amber mid-right bleed
    radial(
      Offset(size.width, size.height * 0.5),
      size.width * 0.65,
      const Color(0xFFFFAA00),
      0.04 + t * 0.02,
    );

    // Bottom blue bleed
    radial(
      Offset(size.width * 0.15, size.height * 0.95),
      size.width * 0.6,
      const Color(0xFF4D9EFF),
      0.04 + t * 0.02,
    );
  }

  @override
  bool shouldRepaint(BgPainter o) => o.t != t;
}
