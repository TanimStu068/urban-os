import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class CornerPainter extends CustomPainter {
  final double progress;
  CornerPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.cyan
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, 0)
      ..lineTo(0, size.height);

    final metric = path.computeMetrics().first;
    final drawn = metric.extractPath(0, metric.length * progress);
    canvas.drawPath(drawn, paint);

    // Glow dot at tip
    if (progress > 0.05) {
      final pos = metric
          .getTangentForOffset(metric.length * progress)!
          .position;
      canvas.drawCircle(
        pos,
        2,
        Paint()..color = AppColors.cyan.withOpacity(0.8),
      );
      canvas.drawCircle(
        pos,
        4,
        Paint()
          ..color = AppColors.cyan.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  @override
  bool shouldRepaint(CornerPainter o) => o.progress != progress;
}
