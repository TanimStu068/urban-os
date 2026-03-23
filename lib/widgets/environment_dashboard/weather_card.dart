import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/environment_dashboard/weather_icon_painter.dart';
import 'package:urban_os/widgets/environment_dashboard/w_row.dart';

class WeatherCard extends StatelessWidget {
  final WeatherType weather;
  final EnvSensorReading tempSensor;
  final EnvSensorReading humSensor;
  final EnvSensorReading rainfallSensor;
  final EnvSensorReading uvSensor;
  final AnimationController glowCtrl;
  final AnimationController pulseCtrl;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.tempSensor,
    required this.humSensor,
    required this.rainfallSensor,
    required this.uvSensor,
    required this.glowCtrl,
    required this.pulseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowCtrl, pulseCtrl]),
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.bgCard.withOpacity(0.9),
          border: Border.all(
            color: weather.color.withOpacity(0.25 + glowCtrl.value * 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: weather.color.withOpacity(0.06 + glowCtrl.value * 0.03),
              blurRadius: 16,
            ),
          ],
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
                    color: weather.color.withOpacity(0.12),
                    border: Border.all(color: weather.color.withOpacity(0.3)),
                  ),
                  child: Icon(weather.icon, color: weather.color, size: 11),
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    'WEATHER',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: weather.color,
                      letterSpacing: 1.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(color: Color(0x1A00FFCC), height: 1),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                height: 70,
                child: CustomPaint(
                  painter: WeatherIconPainter(
                    type: weather,
                    glow: glowCtrl.value,
                    anim: pulseCtrl.value,
                  ),
                  size: const Size(double.infinity, 70),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                weather.label,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: weather.color,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 10),
            WRow(
              Icons.thermostat_rounded,
              '${tempSensor.value.toStringAsFixed(1)}°C',
              AppColors.amber,
            ),
            WRow(
              Icons.water_drop_rounded,
              '${humSensor.value.toStringAsFixed(0)}% RH',
              AppColors.cyan,
            ),
            WRow(
              Icons.grain_rounded,
              '${rainfallSensor.value.toStringAsFixed(1)} mm/h',
              AppColors.sky,
            ),
            WRow(
              Icons.wb_sunny_rounded,
              'UV ${uvSensor.value.toStringAsFixed(1)}',
              AppColors.yellow,
            ),
          ],
        ),
      ),
    );
  }
}
