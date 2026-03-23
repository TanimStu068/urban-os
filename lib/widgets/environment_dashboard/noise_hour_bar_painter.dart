import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class NoiseHourBarPainter extends CustomPainter {
  final List<double> data;
  final double glow;
  const NoiseHourBarPainter({required this.data, required this.glow});

  @override
  void paint(Canvas canvas, Size s) {
    if (data.isEmpty) return;
    final bw = s.width / data.length;
    for (int i = 0; i < data.length; i++) {
      final norm = ((data[i] - 30) / 70).clamp(0, 1);
      final col = data[i] > 80
          ? C.red
          : data[i] > 70
          ? C.amber
          : C.violet;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            i * bw + 0.5,
            s.height * (1 - norm),
            bw - 1,
            s.height * norm,
          ),
          const Radius.circular(2),
        ),
        Paint()..color = col.withOpacity(0.55 + norm * 0.25),
      );
    }
    // 70dB reference
    const limitNorm = (70 - 30) / 70;
    final limitY = s.height * (1 - limitNorm.clamp(0.0, 1.0));
    canvas.drawLine(
      Offset(0, limitY),
      Offset(s.width, limitY),
      Paint()
        ..color = C.amber.withOpacity(0.4)
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(NoiseHourBarPainter o) => o.glow != glow;
}
