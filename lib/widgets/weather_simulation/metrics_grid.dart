import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/weather_simulation_data_model.dart';
import 'package:urban_os/widgets/weather_simulation/metric_card.dart';

typedef C = AppColors;

class MetricsGridWidget extends StatelessWidget {
  final WeatherSnapshot currentWeather;
  final Animation<double> glowAnimation;

  const MetricsGridWidget({
    super.key,
    required this.currentWeather,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.2,
      children: [
        MetricCardWidget(
          label: 'HUMIDITY',
          value: currentWeather.humidity.toStringAsFixed(0),
          unit: '%',
          icon: Icons.water_drop_rounded,
          color: C.cyan,
          glowAnimation: glowAnimation,
        ),
        MetricCardWidget(
          label: 'WIND SPEED',
          value: currentWeather.windSpeed.toStringAsFixed(1),
          unit: 'km/h',
          icon: Icons.air_rounded,
          color: C.mint,
          glowAnimation: glowAnimation,
        ),
        MetricCardWidget(
          label: 'RAINFALL',
          value: currentWeather.rainfall.toStringAsFixed(1),
          unit: 'mm',
          icon: Icons.grain_rounded,
          color: C.sky,
          glowAnimation: glowAnimation,
        ),
        MetricCardWidget(
          label: 'UV INDEX',
          value: currentWeather.uvIndex.toStringAsFixed(1),
          icon: Icons.wb_sunny_rounded,
          color: C.yellow,
          glowAnimation: glowAnimation,
        ),
        MetricCardWidget(
          label: 'VISIBILITY',
          value: currentWeather.visibility.toStringAsFixed(1),
          unit: 'km',
          icon: Icons.visibility_rounded,
          color: C.teal,
          glowAnimation: glowAnimation,
        ),
        MetricCardWidget(
          label: 'PRESSURE',
          value: currentWeather.pressure.toStringAsFixed(0),
          unit: 'hPa',
          icon: Icons.compress_rounded,
          color: C.violet,
          glowAnimation: glowAnimation,
        ),
      ],
    );
  }
}
