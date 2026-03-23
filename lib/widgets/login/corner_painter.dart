import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class CornerPainter extends CustomPainter {
  final double p;
  CornerPainter(this.p);
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
    final m = path.computeMetrics().first;
    canvas.drawPath(m.extractPath(0, m.length * p), paint);
    if (p > 0.05) {
      final pos = m.getTangentForOffset(m.length * p)!.position;
      canvas.drawCircle(pos, 2.5, Paint()..color = AppColors.cyan);
      canvas.drawCircle(
        pos,
        5,
        Paint()
          ..color = AppColors.cyan.withOpacity(0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  @override
  bool shouldRepaint(CornerPainter o) => o.p != p;
}
