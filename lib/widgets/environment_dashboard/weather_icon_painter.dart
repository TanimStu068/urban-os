import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'dart:math';

class WeatherIconPainter extends CustomPainter {
  final WeatherType type;
  final double glow, anim;
  const WeatherIconPainter({
    required this.type,
    required this.glow,
    required this.anim,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final col = type.color;
    final pulse = 1.0 + sin(anim * 2 * pi) * 0.06;

    switch (type) {
      case WeatherType.clear:
        // Sun
        canvas.drawCircle(
          Offset(cx, cy),
          18 * pulse,
          Paint()
            ..color = col.withOpacity(0.2 + glow * 0.1)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
        );
        canvas.drawCircle(Offset(cx, cy), 14 * pulse, Paint()..color = col);
        for (int i = 0; i < 8; i++) {
          final a = i * pi / 4;
          canvas.drawLine(
            Offset(cx + cos(a) * 18, cy + sin(a) * 18),
            Offset(cx + cos(a) * 26, cy + sin(a) * 26),
            Paint()
              ..color = col
              ..strokeWidth = 2.5
              ..strokeCap = StrokeCap.round,
          );
        }
        break;
      case WeatherType.cloudy:
        canvas.drawCircle(
          Offset(cx - 10, cy + 4),
          14,
          Paint()..color = col.withOpacity(0.5),
        );
        canvas.drawCircle(
          Offset(cx + 6, cy + 4),
          16,
          Paint()..color = col.withOpacity(0.6),
        );
        canvas.drawCircle(
          Offset(cx, cy - 4),
          13,
          Paint()..color = col.withOpacity(0.4),
        );
        canvas.drawRect(
          Rect.fromLTWH(cx - 24, cy + 4, 48, 20),
          Paint()..color = C.bg,
        );
        canvas.drawCircle(
          Offset(cx - 10, cy + 4),
          14,
          Paint()
            ..color = col.withOpacity(0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0,
        );
        // flat bottom
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 22, cy + 4, 44, 18),
            const Radius.circular(9),
          ),
          Paint()..color = col.withOpacity(0.45),
        );
        break;
      case WeatherType.rainy:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 22, cy - 12, 44, 18),
            const Radius.circular(9),
          ),
          Paint()..color = col.withOpacity(0.5),
        );
        for (int i = 0; i < 5; i++) {
          final dx = cx - 16.0 + i * 8;
          final dy = cy + 10 + (anim * 12 + i * 3) % 18;
          canvas.drawLine(
            Offset(dx, dy),
            Offset(dx - 3, dy + 10),
            Paint()
              ..color = col
              ..strokeWidth = 1.5
              ..strokeCap = StrokeCap.round,
          );
        }
        break;
      case WeatherType.stormy:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 22, cy - 14, 44, 18),
            const Radius.circular(9),
          ),
          Paint()..color = C.violet.withOpacity(0.5),
        );
        final lightning = Path()
          ..moveTo(cx + 4, cy + 4)
          ..lineTo(cx - 4, cy + 17)
          ..lineTo(cx + 2, cy + 17)
          ..lineTo(cx - 4, cy + 30)
          ..lineTo(cx + 10, cy + 14)
          ..lineTo(cx + 3, cy + 14)
          ..close();
        canvas.drawPath(
          lightning,
          Paint()
            ..color = C.yellow.withOpacity(0.6 + glow * 0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
        canvas.drawPath(lightning, Paint()..color = C.yellow);
        break;
      case WeatherType.foggy:
        for (int i = 0; i < 4; i++) {
          final y = cy - 12.0 + i * 10;
          final w = 40.0 - i * 4;
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(cx - w / 2, y, w, 4),
              const Radius.circular(2),
            ),
            Paint()..color = col.withOpacity(0.3 + i * 0.08),
          );
        }
        break;
      case WeatherType.windy:
        for (int i = 0; i < 3; i++) {
          final y = cy - 8.0 + i * 10;
          final len = 36.0 - i * 6;
          final off = sin(anim * 2 * pi + i * 1.2) * 3;
          final path = Path()
            ..moveTo(cx - len / 2 + off, y)
            ..quadraticBezierTo(cx + off, y + 4, cx + len / 2 + off, y);
          canvas.drawPath(
            path,
            Paint()
              ..color = col.withOpacity(0.5 + i * 0.1)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..strokeCap = StrokeCap.round,
          );
        }
        break;
    }
  }

  @override
  bool shouldRepaint(WeatherIconPainter o) =>
      o.glow != glow || o.anim != anim || o.type != type;
}
