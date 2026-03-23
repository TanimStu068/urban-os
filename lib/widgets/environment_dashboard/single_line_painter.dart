import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SingleLinePainter extends CustomPainter {
  final List<double> data;
  final Color color, dangerColor;
  final double glow, dangerLine;
  final String label;
  const SingleLinePainter({
    required this.data,
    required this.color,
    required this.glow,
    required this.dangerLine,
    required this.dangerColor,
    required this.label,
  });

  @override
  void paint(Canvas canvas, Size s) {
    if (data.isEmpty) return;
    const padL = 8.0, padR = 8.0, padT = 8.0, padB = 16.0;
    final w = s.width - padL - padR;
    final h = s.height - padT - padB;
    final maxV = data.reduce(max) * 1.15;
    final n = data.length;

    // Danger line
    final dl = padT + h - (dangerLine / maxV).clamp(0, 1) * h;
    canvas.drawLine(
      Offset(padL, dl),
      Offset(padL + w, dl),
      Paint()
        ..color = dangerColor.withOpacity(0.45)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );
    final tp = TextPainter(
      text: TextSpan(
        text: 'LIMIT: ${dangerLine.toStringAsFixed(0)}',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 6.5,
          color: dangerColor.withOpacity(0.8),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(padL + 2, dl - tp.height - 1));

    // Grid
    canvas.drawLine(
      Offset(padL, padT),
      Offset(padL, padT + h),
      Paint()
        ..color = C.muted.withOpacity(0.2)
        ..strokeWidth = 0.5,
    );
    canvas.drawLine(
      Offset(padL, padT + h),
      Offset(padL + w, padT + h),
      Paint()
        ..color = C.muted.withOpacity(0.2)
        ..strokeWidth = 0.5,
    );

    // Area
    final path = Path(), fill = Path();
    for (int i = 0; i < n; i++) {
      final x = padL + (i / (n - 1)) * w;
      final y = padT + h - (data[i] / maxV).clamp(0, 1) * h;
      if (i == 0) {
        path.moveTo(x, y);
        fill.moveTo(x, padT + h);
        fill.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fill.lineTo(x, y);
      }
    }
    fill.lineTo(padL + w, padT + h);
    fill.close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.15 + glow * 0.06), color.withOpacity(0)],
        ).createShader(Rect.fromLTWH(padL, padT, w, h)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withOpacity(0.25)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Hour labels
    for (int i = 0; i < n; i += 4) {
      final x = padL + (i / (n - 1)) * w;
      final lp = TextPainter(
        text: TextSpan(
          text: '${i.toString().padLeft(2, '0')}h',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: C.mutedLt,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      lp.paint(canvas, Offset(x - lp.width / 2, s.height - padB + 2));
    }
  }

  @override
  bool shouldRepaint(SingleLinePainter o) => o.glow != glow;
}
