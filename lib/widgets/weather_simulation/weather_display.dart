import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/weather_simulation_data_model.dart';

typedef C = AppColors;

class WeatherDisplayWidget extends StatelessWidget {
  final WeatherSnapshot currentWeather;
  final Animation<double> glowAnimation;
  final Animation<double> weatherAnimation;

  const WeatherDisplayWidget({
    super.key,
    required this.currentWeather,
    required this.glowAnimation,
    required this.weatherAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowAnimation, weatherAnimation]),
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: C.bgCard.withOpacity(0.85),
          border: Border.all(
            color: currentWeather.condition.color.withOpacity(
              0.25 + glowAnimation.value * 0.1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: currentWeather.condition.color.withOpacity(
                0.08 + glowAnimation.value * 0.04,
              ),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          children: [
            // Large condition icon
            SizedBox(
              height: 100,
              child: Icon(
                currentWeather.condition.icon,
                size: 80,
                color: currentWeather.condition.color.withOpacity(
                  0.7 + weatherAnimation.value * 0.3,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Condition label
            Text(
              currentWeather.condition.label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: currentWeather.condition.color,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            // Temperature display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${currentWeather.temperature.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: C.teal,
                    shadows: [Shadow(color: C.teal, blurRadius: 12)],
                  ),
                ),
                const Text(
                  '°C',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: C.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Feels like ${currentWeather.feelsLike.toStringAsFixed(1)}°C',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8.5,
                color: C.mutedLt,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
