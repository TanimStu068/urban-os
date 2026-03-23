import 'package:flutter/material.dart';

class BgPainter extends CustomPainter {
  final double t;
  BgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF050A13),
    );

    void radial(Offset center, double radius, Color color, double opacity) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [color.withOpacity(opacity), Colors.transparent],
          ).createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }

    radial(
      Offset(size.width * 0.1, size.height * 0.05),
      size.width * 0.6,
      const Color(0xFF00D4FF),
      0.06 + t * 0.04,
    );
    radial(
      Offset(size.width * 0.9, size.height * 0.88),
      size.width * 0.55,
      const Color(0xFFFFAA00),
      0.05 + t * 0.03,
    );
    radial(
      Offset(size.width * 0.05, size.height * 0.5),
      size.width * 0.3,
      const Color(0xFFFF3B5C),
      0.03 + t * 0.02,
    );
  }

  @override
  bool shouldRepaint(BgPainter o) => o.t != t;
}
