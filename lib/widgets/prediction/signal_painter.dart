import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';
import 'dart:math';

class SignalPainter extends CustomPainter {
  final Prediction p;
  final double progress;
  SignalPainter(this.p, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const lpad = 8.0, rpad = 8.0, tpad = 8.0, bpad = 8.0;
    final w = size.width - lpad - rpad;
    final h = size.height - tpad - bpad;

    final allVals = [...p.signalHistory, ...p.upperBound, ...p.lowerBound];
    final minV = allVals.reduce(min) - 5;
    final maxV = allVals.reduce(max) + 5;
    final range = maxV - minV;
    final total = p.signalHistory.length + p.forecastLine.length;

    double xFor(int i) => lpad + (i / (total - 1)) * w;
    double yFor(double v) => tpad + h - ((v - minV) / range) * h;

    // Confidence band fill
    if (p.forecastLine.isNotEmpty) {
      final bandPath = Path();
      final hLen = p.signalHistory.length;
      bandPath.moveTo(xFor(hLen), yFor(p.upperBound.first));
      for (int i = 0; i < p.upperBound.length; i++) {
        bandPath.lineTo(xFor(hLen + i), yFor(p.upperBound[i]));
      }
      for (int i = p.lowerBound.length - 1; i >= 0; i--) {
        bandPath.lineTo(xFor(hLen + i), yFor(p.lowerBound[i]));
      }
      bandPath.close();
      canvas.drawPath(
        bandPath,
        Paint()..color = p.level.color.withOpacity(0.1),
      );
    }

    // History line
    if (p.signalHistory.length > 1) {
      final path = Path();
      final drawLen = (p.signalHistory.length * progress).round().clamp(
        1,
        p.signalHistory.length,
      );
      for (int i = 0; i < drawLen; i++) {
        final x = xFor(i);
        final y = yFor(p.signalHistory[i]);
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.cyan
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    // Forecast line (dashed)
    if (p.forecastLine.isNotEmpty && progress > 0.5) {
      final fp = (((progress - 0.5) / 0.5) * p.forecastLine.length)
          .round()
          .clamp(1, p.forecastLine.length);
      final hLen = p.signalHistory.length;
      final dashPaint = Paint()
        ..color = p.level.color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      double? lx, ly;
      for (int i = 0; i < fp; i++) {
        final x = xFor(hLen + i);
        final y = yFor(p.forecastLine[i]);
        if (lx != null && ly != null && i % 2 == 0) {
          canvas.drawLine(Offset(lx, ly), Offset(x, y), dashPaint);
        }
        lx = x;
        ly = y;
      }
    }

    // Separator
    final sepX = xFor(p.signalHistory.length - 1);
    canvas.drawLine(
      Offset(sepX, tpad),
      Offset(sepX, tpad + h),
      Paint()
        ..color = AppColors.mutedLt.withOpacity(0.3)
        ..strokeWidth = 0.5
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.mutedLt.withOpacity(0.0),
            AppColors.mutedLt.withOpacity(0.4),
            AppColors.mutedLt.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(sepX - 1, tpad, 2, h)),
    );
  }

  @override
  bool shouldRepaint(SignalPainter old) => old.progress != progress;
}
