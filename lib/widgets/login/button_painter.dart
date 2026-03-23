import 'package:flutter/material.dart';

class ButtonShimmerPainter extends CustomPainter {
  final double t;
  ButtonShimmerPainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {
    if (t < 0) return;
    final x = -size.width + t * size.width * 2.5;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(rect);
    canvas.drawRect(
      Rect.fromLTWH(x, 0, size.width * 0.4, size.height),
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.08),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(x, 0, size.width * 0.4, size.height)),
    );
  }

  @override
  bool shouldRepaint(ButtonShimmerPainter o) => o.t != t;
}
