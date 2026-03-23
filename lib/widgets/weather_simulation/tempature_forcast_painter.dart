import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/weather_simulation_data_model.dart';

class TemperatureForecastPainter extends CustomPainter {
  final List<WeatherSnapshot> data;
  final int currentIndex;
  final double glow;

  TemperatureForecastPainter({
    required this.data,
    required this.currentIndex,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = C.amber.withOpacity(0.6 + glow * 0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height - 20;
    final maxTemp = 35.0;
    final minTemp = 5.0;

    // Draw line
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * w;
      final y =
          size.height -
          10 -
          ((data[i].temperature - minTemp) / (maxTemp - minTemp)).clamp(0, 1) *
              h;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw current position marker
    final currX = (currentIndex / (data.length - 1)) * w;
    final currVal = data[currentIndex].temperature;
    final currY =
        size.height -
        10 -
        ((currVal - minTemp) / (maxTemp - minTemp)).clamp(0, 1) * h;

    canvas.drawCircle(
      Offset(currX, currY),
      4,
      Paint()
        ..color = C.red
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      Offset(currX, currY),
      6,
      Paint()
        ..color = C.red.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(TemperatureForecastPainter oldDelegate) =>
      currentIndex != oldDelegate.currentIndex || glow != oldDelegate.glow;
}
