import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/pollution_analysis_data_model.dart';

class PollutionTrendPainter extends CustomPainter {
  final List<PollutionDataPoint> data;
  final PollutantType pollutantType;
  final double glow;
  final double safeLimit;

  PollutionTrendPainter({
    required this.data,
    required this.pollutantType,
    required this.glow,
    required this.safeLimit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = pollutantType.color.withOpacity(0.7 + glow * 0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final limitPaint = Paint()
      ..color = C.amber.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height - 20;
    final maxVal = (safeLimit * 1.5).toDouble();

    // Draw safe limit line
    final limitY = size.height - 10 - (safeLimit / maxVal) * h;
    canvas.drawLine(Offset(0, limitY), Offset(w, limitY), limitPaint);

    // Draw trend line
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final val = _getPollutantValue(data[i], pollutantType);
      final x = (i / (data.length - 1)) * w;
      final y = size.height - 10 - (val / maxVal).clamp(0, 1) * h;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw glow effect
    canvas.drawPath(
      path,
      Paint()
        ..color = pollutantType.color.withOpacity((glow * 0.3).clamp(0, 0.3))
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  double _getPollutantValue(PollutionDataPoint data, PollutantType type) {
    switch (type) {
      case PollutantType.pm25:
        return data.pm25;
      case PollutantType.pm10:
        return data.pm10;
      case PollutantType.no2:
        return data.no2;
      case PollutantType.o3:
        return data.o3;
      case PollutantType.co:
        return data.co;
      case PollutantType.so2:
        return data.so2;
    }
  }

  @override
  bool shouldRepaint(PollutionTrendPainter oldDelegate) =>
      glow != oldDelegate.glow;
}
