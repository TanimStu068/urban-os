import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/weather_simulation_data_model.dart';

typedef C = AppColors;

class WeatherHeaderWidget extends StatelessWidget {
  final WeatherSnapshot currentWeather;
  final Animation<double> glowAnimation;
  final Animation<double> weatherAnimation;
  final VoidCallback? onBack;

  const WeatherHeaderWidget({
    super.key,
    required this.currentWeather,
    required this.glowAnimation,
    required this.weatherAnimation,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.gBdr)),
          boxShadow: [
            BoxShadow(
              color: currentWeather.condition.color.withOpacity(
                0.04 + glowAnimation.value * 0.02,
              ),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBack ?? () => Navigator.maybePop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: C.teal,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Weather icon
            AnimatedBuilder(
              animation: weatherAnimation,
              builder: (_, __) => Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentWeather.condition.color.withOpacity(0.10),
                  border: Border.all(
                    color: currentWeather.condition.color.withOpacity(
                      0.3 + glowAnimation.value * 0.18,
                    ),
                  ),
                ),
                child: Icon(
                  currentWeather.condition.icon,
                  color: currentWeather.condition.color,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [currentWeather.condition.color, C.cyan],
                    ).createShader(bounds),
                    child: const Text(
                      'WEATHER SIMULATION',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '${currentWeather.condition.label}  ·  ${currentWeather.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      letterSpacing: 1.8,
                      color: C.mutedLt,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
