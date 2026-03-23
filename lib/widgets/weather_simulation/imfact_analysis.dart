import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/weather_simulation_data_model.dart';

typedef C = AppColors;

class ImpactAnalysisWidget extends StatelessWidget {
  final WeatherSnapshot currentWeather;

  const ImpactAnalysisWidget({super.key, required this.currentWeather});

  @override
  Widget build(BuildContext context) {
    final impacts = <ImpactMetric>[
      ImpactMetric(
        name: 'TRAFFIC IMPACT',
        value: (currentWeather.rainfall > 10 ? 85 : 42).toString(),
        unit: '%',
        icon: Icons.directions_car_rounded,
        color: C.orange,
        intensity: currentWeather.rainfall > 10 ? 0.85 : 0.42,
      ),
      ImpactMetric(
        name: 'VISIBILITY RISK',
        value: ((1 - currentWeather.visibility / 10) * 100).toStringAsFixed(0),
        unit: '%',
        icon: Icons.visibility_off_rounded,
        color: C.red,
        intensity: (1 - currentWeather.visibility / 10).clamp(0, 1),
      ),
      ImpactMetric(
        name: 'POWER DEMAND',
        value: (currentWeather.temperature > 30 ? 95 : 60).toString(),
        unit: '%',
        icon: Icons.flash_on_rounded,
        color: C.yellow,
        intensity: currentWeather.temperature > 30 ? 0.95 : 0.60,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'CITY IMPACT ANALYSIS',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: C.violet,
              letterSpacing: 1.5,
            ),
          ),
        ),
        ...impacts.map(
          (impact) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(impact.icon, color: impact.color, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        impact.name,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: impact.color,
                        ),
                      ),
                    ),
                    Text(
                      '${impact.value}${impact.unit}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: impact.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: impact.intensity,
                    backgroundColor: C.bgCard2,
                    valueColor: AlwaysStoppedAnimation(impact.color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
