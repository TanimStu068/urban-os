import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class CPainter extends CustomPainter {
  final double p;
  CPainter(this.p);
  @override
  void paint(Canvas canvas, Size s) {
    final paint = Paint()
      ..color = AppColors.amber
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(s.width, 0)
      ..lineTo(0, 0)
      ..lineTo(0, s.height);
    final m = path.computeMetrics().first;
    canvas.drawPath(m.extractPath(0, m.length * p), paint);
    if (p > .05) {
      final pos = m.getTangentForOffset(m.length * p)!.position;
      canvas.drawCircle(pos, 2.5, Paint()..color = AppColors.amber);
      canvas.drawCircle(
        pos,
        5,
        Paint()
          ..color = AppColors.amber.withOpacity(.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  @override
  bool shouldRepaint(CPainter o) => o.p != p;
}
