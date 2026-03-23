import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

const kAccent = C.cyan;

class RevenueBarPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double progress, glowT;
  RevenueBarPainter({
    required this.data,
    required this.color,
    required this.progress,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    const padT = 14.0, padB = 22.0, padL = 36.0, padR = 8.0;
    final w = s.width - padL - padR, h = s.height - padT - padB;
    final maxV = data.reduce(max) * 1.2;
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final barW = w / data.length;

    for (int i = 0; i <= 4; i++) {
      final y = padT + h - (i / 4) * h;
      canvas.drawLine(
        Offset(padL, y),
        Offset(s.width - padR, y),
        Paint()
          ..color = color.withOpacity(0.06)
          ..strokeWidth = 0.5,
      );
      _txt(
        canvas,
        '৳${(maxV / 4 * i / 1000).toStringAsFixed(0)}k',
        Offset(0, y - 3.5),
        6,
        color.withOpacity(0.35),
      );
    }

    for (int i = 0; i < data.length; i++) {
      final barH = (data[i] / maxV) * h * progress;
      final x = padL + i * barW + barW * 0.15;
      final bw = barW * 0.7;
      final y = padT + h - barH;

      // Bar glow
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, bw, barH),
          const Radius.circular(3),
        ),
        Paint()
          ..color = color.withOpacity(0.15 + glowT * 0.06)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      // Bar fill
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, bw, barH),
          const Radius.circular(3),
        ),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [color.withOpacity(0.6), color],
          ).createShader(Rect.fromLTWH(x, y, bw, barH)),
      );

      // Day label
      _txt(
        canvas,
        days[i],
        Offset(x + bw / 2 - 8, s.height - padB + 5),
        7,
        kAccent.withOpacity(0.4),
      );
      // Value
      if (barH > 16) {
        _txt(
          canvas,
          '৳${data[i].toStringAsFixed(0)}',
          Offset(x + bw / 2 - 12, y - 12),
          6.5,
          color.withOpacity(0.7),
        );
      }
    }
  }

  void _txt(Canvas c, String t, Offset p, double sz, Color col) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(fontFamily: 'monospace', fontSize: sz, color: col),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(RevenueBarPainter o) =>
      o.progress != progress || o.glowT != glowT;
}
