import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

//  ENUMS & DATA MODELS
enum WeatherCondition {
  clearSky,
  partlyCloudy,
  overcast,
  fog,
  lightRain,
  moderateRain,
  heavyRain,
  thunderstorm,
  snow,
  windy,
}

enum SimulationMode { realtime, forecast, historical, replay }

extension WeatherConditionX on WeatherCondition {
  String get label {
    switch (this) {
      case WeatherCondition.clearSky:
        return 'CLEAR SKY';
      case WeatherCondition.partlyCloudy:
        return 'PARTLY CLOUDY';
      case WeatherCondition.overcast:
        return 'OVERCAST';
      case WeatherCondition.fog:
        return 'FOG';
      case WeatherCondition.lightRain:
        return 'LIGHT RAIN';
      case WeatherCondition.moderateRain:
        return 'MODERATE RAIN';
      case WeatherCondition.heavyRain:
        return 'HEAVY RAIN';
      case WeatherCondition.thunderstorm:
        return 'THUNDERSTORM';
      case WeatherCondition.snow:
        return 'SNOW';
      case WeatherCondition.windy:
        return 'WINDY';
    }
  }

  IconData get icon {
    switch (this) {
      case WeatherCondition.clearSky:
        return Icons.wb_sunny_rounded;
      case WeatherCondition.partlyCloudy:
        return Icons.cloud_rounded;
      case WeatherCondition.overcast:
        return Icons.cloud_queue_rounded;
      case WeatherCondition.fog:
        return Icons.blur_on_rounded;
      case WeatherCondition.lightRain:
        return Icons.grain_rounded;
      case WeatherCondition.moderateRain:
        return Icons.cloud_download_rounded;
      case WeatherCondition.heavyRain:
        return Icons.water_rounded;
      case WeatherCondition.thunderstorm:
        return Icons.thunderstorm_rounded;
      case WeatherCondition.snow:
        return Icons.severe_cold_rounded;
      case WeatherCondition.windy:
        return Icons.air_rounded;
    }
  }

  Color get color {
    switch (this) {
      case WeatherCondition.clearSky:
        return C.yellow;
      case WeatherCondition.partlyCloudy:
        return C.sky;
      case WeatherCondition.overcast:
        return C.mutedLt;
      case WeatherCondition.fog:
        return C.cyan;
      case WeatherCondition.lightRain:
        return C.cyan;
      case WeatherCondition.moderateRain:
        return C.sky;
      case WeatherCondition.heavyRain:
        return C.violet;
      case WeatherCondition.thunderstorm:
        return C.pink;
      case WeatherCondition.snow:
        return C.white;
      case WeatherCondition.windy:
        return C.mint;
    }
  }
}

class WeatherSnapshot {
  final DateTime timestamp;
  final WeatherCondition condition;
  double temperature;
  double humidity;
  double windSpeed;
  double windDirection;
  double rainfall;
  double cloudCover;
  double visibility;
  double uvIndex;
  double pressure;
  double feelsLike;

  WeatherSnapshot({
    required this.timestamp,
    required this.condition,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.rainfall,
    required this.cloudCover,
    required this.visibility,
    required this.uvIndex,
    required this.pressure,
    required this.feelsLike,
  });
}

class WeatherAlert {
  final String id;
  final String title;
  final String description;
  final Color severity;
  final IconData icon;
  bool dismissed;

  WeatherAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.icon,
    this.dismissed = false,
  });
}

class ImpactMetric {
  final String name;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final double intensity; // 0-1

  ImpactMetric({
    required this.name,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.intensity,
  });
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
final rng = Random(99);

List<WeatherSnapshot> buildForecastData() => List.generate(48, (i) {
  final dayFrac = (i / 24) % 1.0;
  final dayOffset = i ~/ 24;
  final baseTemp = 22 + 8 * sin(dayFrac * 2 * pi);
  final temp = baseTemp + (rng.nextDouble() - 0.5) * 3 + dayOffset * 0.5;
  final humidity =
      65 - 15 * sin(dayFrac * 2 * pi) + (rng.nextDouble() - 0.5) * 8;
  final wind = 8 + 12 * sin((dayFrac + 0.3) * pi) + rng.nextDouble() * 4;
  final rain = i >= 12 && i <= 20
      ? rng.nextDouble() * 15
      : rng.nextDouble() * 2;

  return WeatherSnapshot(
    timestamp: DateTime.now().add(Duration(hours: i)),
    condition: selectCondition(rain, wind, humidity),
    temperature: temp.clamp(-10, 50),
    humidity: humidity.clamp(10, 100),
    windSpeed: wind.clamp(0, 80),
    windDirection: (rng.nextDouble() * 360).roundToDouble(),
    rainfall: rain.clamp(0, 100),
    cloudCover: (rng.nextDouble() * 100).roundToDouble(),
    visibility: (10 - rain * 0.3).clamp(0.5, 10),
    uvIndex: (6 + 4 * sin(dayFrac * 2 * pi)).clamp(0, 11),
    pressure: 1013 + (rng.nextDouble() - 0.5) * 20,
    feelsLike: temp.clamp(-10, 50) - wind * 0.1,
  );
});

WeatherCondition selectCondition(double rain, double wind, double humidity) {
  if (wind > 40) return WeatherCondition.windy;
  if (rain > 20) return WeatherCondition.thunderstorm;
  if (rain > 10) return WeatherCondition.heavyRain;
  if (rain > 5) return WeatherCondition.moderateRain;
  if (rain > 1) return WeatherCondition.lightRain;
  if (humidity > 90) return WeatherCondition.fog;
  if (humidity > 80) return WeatherCondition.overcast;
  if (humidity > 60) return WeatherCondition.partlyCloudy;
  return WeatherCondition.clearSky;
}

List<WeatherAlert> buildAlerts(WeatherCondition condition) {
  final alerts = <WeatherAlert>[];
  if (condition == WeatherCondition.thunderstorm) {
    alerts.add(
      WeatherAlert(
        id: 'WA-001',
        title: 'SEVERE THUNDERSTORM WARNING',
        description:
            'Lightning and heavy rain possible. Seek shelter immediately.',
        severity: C.red,
        icon: Icons.warning_rounded,
      ),
    );
  }
  if (condition == WeatherCondition.heavyRain) {
    alerts.add(
      WeatherAlert(
        id: 'WA-002',
        title: 'FLOODING ALERT',
        description: 'Heavy rainfall may cause localized flooding.',
        severity: C.orange,
        icon: Icons.water_rounded,
      ),
    );
  }
  if (condition == WeatherCondition.fog) {
    alerts.add(
      WeatherAlert(
        id: 'WA-003',
        title: 'LOW VISIBILITY',
        description: 'Dense fog reducing visibility. Caution advised.',
        severity: C.amber,
        icon: Icons.blur_on_rounded,
      ),
    );
  }
  return alerts;
}
