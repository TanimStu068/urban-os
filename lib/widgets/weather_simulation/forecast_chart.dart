import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/weather_simulation_data_model.dart';
import 'package:urban_os/widgets/weather_simulation/tempature_forcast_painter.dart';

typedef C = AppColors;

class ForecastChartWidget extends StatelessWidget {
  final List<WeatherSnapshot> forecastData;
  final int currentHour;
  final AnimationController glowCtrl;

  const ForecastChartWidget({
    super.key,
    required this.forecastData,
    required this.currentHour,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: C.bgCard.withOpacity(0.9),
        border: Border.all(color: C.sky.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.sky.withOpacity(0.12),
                  border: Border.all(color: C.sky.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.show_chart_rounded,
                  color: C.sky,
                  size: 11,
                ),
              ),
              const SizedBox(width: 7),
              const Text(
                '48H FORECAST',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: C.sky,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0x1A00FFCC), height: 1),
          const SizedBox(height: 10),
          SizedBox(
            height: 140,
            child: AnimatedBuilder(
              animation: glowCtrl,
              builder: (_, __) => CustomPaint(
                painter: TemperatureForecastPainter(
                  data: forecastData,
                  currentIndex: currentHour,
                  glow: glowCtrl.value,
                ),
                size: const Size(double.infinity, 140),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
