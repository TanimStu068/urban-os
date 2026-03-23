import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';
import 'package:urban_os/models/sensor/sensor_type.dart';

// ─────────────────────────────────────────
//  COLOR PALETTE  (UrbanOS — Environment Theme)
// ─────────────────────────────────────────
typedef C = AppColors;

const kAccent = C.teal;

// ─────────────────────────────────────────
//  ENUMS
// ─────────────────────────────────────────
enum AqiLevel {
  good,
  moderate,
  unhealthySensitive,
  unhealthy,
  veryUnhealthy,
  hazardous,
}

enum WeatherType { clear, cloudy, rainy, stormy, foggy, windy }

enum ViewTab { overview, airQuality, climate, noise, water, alerts }

extension AqiLevelX on AqiLevel {
  Color get color {
    switch (this) {
      case AqiLevel.good:
        return C.green;
      case AqiLevel.moderate:
        return C.lime;
      case AqiLevel.unhealthySensitive:
        return C.yellow;
      case AqiLevel.unhealthy:
        return C.amber;
      case AqiLevel.veryUnhealthy:
        return C.orange;
      case AqiLevel.hazardous:
        return C.red;
    }
  }

  String get label {
    switch (this) {
      case AqiLevel.good:
        return 'GOOD';
      case AqiLevel.moderate:
        return 'MODERATE';
      case AqiLevel.unhealthySensitive:
        return 'UNHEALTHY (SENSITIVE)';
      case AqiLevel.unhealthy:
        return 'UNHEALTHY';
      case AqiLevel.veryUnhealthy:
        return 'VERY UNHEALTHY';
      case AqiLevel.hazardous:
        return 'HAZARDOUS';
    }
  }

  int get maxAqi {
    switch (this) {
      case AqiLevel.good:
        return 50;
      case AqiLevel.moderate:
        return 100;
      case AqiLevel.unhealthySensitive:
        return 150;
      case AqiLevel.unhealthy:
        return 200;
      case AqiLevel.veryUnhealthy:
        return 300;
      case AqiLevel.hazardous:
        return 500;
    }
  }
}

AqiLevel aqiLevel(double aqi) {
  if (aqi <= 50) return AqiLevel.good;
  if (aqi <= 100) return AqiLevel.moderate;
  if (aqi <= 150) return AqiLevel.unhealthySensitive;
  if (aqi <= 200) return AqiLevel.unhealthy;
  if (aqi <= 300) return AqiLevel.veryUnhealthy;
  return AqiLevel.hazardous;
}

extension WeatherTypeX on WeatherType {
  IconData get icon {
    switch (this) {
      case WeatherType.clear:
        return Icons.wb_sunny_rounded;
      case WeatherType.cloudy:
        return Icons.cloud_rounded;
      case WeatherType.rainy:
        return Icons.grain_rounded;
      case WeatherType.stormy:
        return Icons.thunderstorm_rounded;
      case WeatherType.foggy:
        return Icons.blur_on_rounded;
      case WeatherType.windy:
        return Icons.air_rounded;
    }
  }

  String get label {
    switch (this) {
      case WeatherType.clear:
        return 'CLEAR SKY';
      case WeatherType.cloudy:
        return 'PARTLY CLOUDY';
      case WeatherType.rainy:
        return 'RAIN SHOWERS';
      case WeatherType.stormy:
        return 'THUNDERSTORM';
      case WeatherType.foggy:
        return 'FOG';
      case WeatherType.windy:
        return 'HIGH WINDS';
    }
  }

  Color get color {
    switch (this) {
      case WeatherType.clear:
        return C.yellow;
      case WeatherType.cloudy:
        return C.sky;
      case WeatherType.rainy:
        return C.cyan;
      case WeatherType.stormy:
        return C.violet;
      case WeatherType.foggy:
        return C.mutedLt;
      case WeatherType.windy:
        return C.teal;
    }
  }
}

// ─────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────
class EnvSensorReading {
  final String id;
  final String name;
  final String unit;
  final IconData icon;
  final Color color;
  double value;
  final double min;
  final double max;
  final double thresholdWarn;
  final double thresholdCrit;
  final List<double> history24h;

  EnvSensorReading({
    required this.id,
    required this.name,
    required this.unit,
    required this.icon,
    required this.color,
    required this.value,
    required this.min,
    required this.max,
    required this.thresholdWarn,
    required this.thresholdCrit,
    required this.history24h,
  });

  bool get isWarning => value >= thresholdWarn && value < thresholdCrit;
  bool get isCritical => value >= thresholdCrit;
  Color get statusColor => isCritical
      ? C.red
      : isWarning
      ? C.amber
      : C.green;
  double get normalizedValue => ((value - min) / (max - min)).clamp(0.0, 1.0);
}

class Pollutant {
  final String id;
  final String name;
  final String unit;
  final Color color;
  double value;
  final double safeLimit;
  final List<double> history;

  Pollutant({
    required this.id,
    required this.name,
    required this.unit,
    required this.color,
    required this.value,
    required this.safeLimit,
    required this.history,
  });

  double get pct => (value / safeLimit * 100).clamp(0, 200);
  bool get isOverLimit => value > safeLimit;
}

class DistrictEnvData {
  final String id;
  final String name;
  final Color color;
  double aqi;
  double temperature;
  double humidity;
  double noise;
  final Offset gridPos; // 0..1 normalized

  DistrictEnvData({
    required this.id,
    required this.name,
    required this.color,
    required this.aqi,
    required this.temperature,
    required this.humidity,
    required this.noise,
    required this.gridPos,
  });
}

class EnvAlert {
  final String id;
  final String message;
  final String district;
  final Color severity;
  final IconData icon;
  final String time;
  bool acknowledged;

  EnvAlert({
    required this.id,
    required this.message,
    required this.district,
    required this.severity,
    required this.icon,
    required this.time,
    this.acknowledged = false,
  });
}

class HourlyEnvPoint {
  final int hour;
  final double temp;
  final double humidity;
  final double aqi;
  final double noise;
  final double rainfall;
  HourlyEnvPoint(
    this.hour,
    this.temp,
    this.humidity,
    this.aqi,
    this.noise,
    this.rainfall,
  );
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
final rng = Random(13);
List<double> hist(int n, double lo, double hi) =>
    List.generate(n, (_) => lo + rng.nextDouble() * (hi - lo));

List<EnvSensorReading> buildSensors() => [
  EnvSensorReading(
    id: 'TMP',
    name: 'TEMPERATURE',
    unit: '°C',
    icon: Icons.thermostat_rounded,
    color: C.amber,
    value: 28.4,
    min: -10,
    max: 50,
    thresholdWarn: 35,
    thresholdCrit: 40,
    history24h: hist(24, 22, 32),
  ),
  EnvSensorReading(
    id: 'HUM',
    name: 'HUMIDITY',
    unit: '%',
    icon: Icons.water_drop_rounded,
    color: C.cyan,
    value: 62.1,
    min: 0,
    max: 100,
    thresholdWarn: 75,
    thresholdCrit: 90,
    history24h: hist(24, 45, 78),
  ),
  EnvSensorReading(
    id: 'AQI',
    name: 'AIR QUALITY',
    unit: 'AQI',
    icon: Icons.air_rounded,
    color: C.teal,
    value: 87.0,
    min: 0,
    max: 300,
    thresholdWarn: 100,
    thresholdCrit: 150,
    history24h: hist(24, 40, 130),
  ),
  EnvSensorReading(
    id: 'NOI',
    name: 'NOISE LEVEL',
    unit: 'dB',
    icon: Icons.graphic_eq_rounded,
    color: C.violet,
    value: 68.3,
    min: 30,
    max: 120,
    thresholdWarn: 70,
    thresholdCrit: 85,
    history24h: hist(24, 42, 78),
  ),
  EnvSensorReading(
    id: 'RAN',
    name: 'RAINFALL',
    unit: 'mm/h',
    icon: Icons.grain_rounded,
    color: C.sky,
    value: 2.1,
    min: 0,
    max: 50,
    thresholdWarn: 20,
    thresholdCrit: 35,
    history24h: hist(24, 0, 8),
  ),
  EnvSensorReading(
    id: 'WND',
    name: 'WIND SPEED',
    unit: 'km/h',
    icon: Icons.air_rounded,
    color: C.mint,
    value: 18.7,
    min: 0,
    max: 100,
    thresholdWarn: 50,
    thresholdCrit: 75,
    history24h: hist(24, 5, 35),
  ),
  EnvSensorReading(
    id: 'UV',
    name: 'UV INDEX',
    unit: 'UVI',
    icon: Icons.wb_sunny_rounded,
    color: C.yellow,
    value: 6.2,
    min: 0,
    max: 11,
    thresholdWarn: 6,
    thresholdCrit: 8,
    history24h: hist(24, 0, 10),
  ),
  EnvSensorReading(
    id: 'CO2',
    name: 'CO₂ LEVEL',
    unit: 'ppm',
    icon: Icons.factory_rounded,
    color: C.lime,
    value: 412.0,
    min: 350,
    max: 700,
    thresholdWarn: 500,
    thresholdCrit: 600,
    history24h: hist(24, 385, 450),
  ),
];

List<Pollutant> buildPollutants() => [
  Pollutant(
    id: 'PM25',
    name: 'PM 2.5',
    unit: 'µg/m³',
    color: C.red,
    value: 28.4,
    safeLimit: 25,
    history: hist(24, 12, 45),
  ),
  Pollutant(
    id: 'PM10',
    name: 'PM 10',
    unit: 'µg/m³',
    color: C.orange,
    value: 48.2,
    safeLimit: 50,
    history: hist(24, 20, 65),
  ),
  Pollutant(
    id: 'NO2',
    name: 'NO₂',
    unit: 'µg/m³',
    color: C.amber,
    value: 38.1,
    safeLimit: 40,
    history: hist(24, 15, 55),
  ),
  Pollutant(
    id: 'O3',
    name: 'O₃',
    unit: 'µg/m³',
    color: C.cyan,
    value: 68.5,
    safeLimit: 100,
    history: hist(24, 30, 90),
  ),
  Pollutant(
    id: 'CO',
    name: 'CO',
    unit: 'mg/m³',
    color: C.violet,
    value: 0.8,
    safeLimit: 10,
    history: hist(24, 0.2, 2.0),
  ),
  Pollutant(
    id: 'SO2',
    name: 'SO₂',
    unit: 'µg/m³',
    color: C.lime,
    value: 14.2,
    safeLimit: 20,
    history: hist(24, 5, 25),
  ),
];

List<DistrictEnvData> buildDistricts() => [
  DistrictEnvData(
    id: 'Z-RES',
    name: 'Residential',
    color: C.green,
    aqi: 72,
    temperature: 27.2,
    humidity: 60,
    noise: 55,
    gridPos: const Offset(0.15, 0.25),
  ),
  DistrictEnvData(
    id: 'Z-IND',
    name: 'Industrial',
    color: C.red,
    aqi: 148,
    temperature: 31.5,
    humidity: 58,
    noise: 82,
    gridPos: const Offset(0.78, 0.20),
  ),
  DistrictEnvData(
    id: 'Z-COM',
    name: 'Commercial',
    color: C.amber,
    aqi: 95,
    temperature: 29.8,
    humidity: 62,
    noise: 71,
    gridPos: const Offset(0.50, 0.35),
  ),
  DistrictEnvData(
    id: 'Z-MED',
    name: 'Medical',
    color: C.cyan,
    aqi: 64,
    temperature: 26.1,
    humidity: 65,
    noise: 48,
    gridPos: const Offset(0.25, 0.62),
  ),
  DistrictEnvData(
    id: 'Z-EDU',
    name: 'Education',
    color: C.violet,
    aqi: 78,
    temperature: 27.5,
    humidity: 63,
    noise: 54,
    gridPos: const Offset(0.70, 0.58),
  ),
  DistrictEnvData(
    id: 'Z-TRN',
    name: 'Transport',
    color: C.sky,
    aqi: 112,
    temperature: 30.2,
    humidity: 57,
    noise: 78,
    gridPos: const Offset(0.50, 0.72),
  ),
  DistrictEnvData(
    id: 'Z-GOV',
    name: 'Government',
    color: C.yellow,
    aqi: 68,
    temperature: 26.8,
    humidity: 64,
    noise: 52,
    gridPos: const Offset(0.82, 0.78),
  ),
  DistrictEnvData(
    id: 'Z-PRK',
    name: 'Green Zone',
    color: C.teal,
    aqi: 38,
    temperature: 24.4,
    humidity: 72,
    noise: 42,
    gridPos: const Offset(0.18, 0.80),
  ),
];

List<EnvAlert> buildAlerts() => [
  EnvAlert(
    id: 'EA-001',
    message: 'Industrial zone AQI at 148 — approaching UNHEALTHY',
    district: 'Z-IND',
    severity: C.orange,
    icon: Icons.air_rounded,
    time: '11:22',
  ),
  EnvAlert(
    id: 'EA-002',
    message: 'Transport Hub noise exceeds 78dB — above safe limit',
    district: 'Z-TRN',
    severity: C.amber,
    icon: Icons.graphic_eq_rounded,
    time: '10:58',
  ),
  EnvAlert(
    id: 'EA-003',
    message: 'PM2.5 exceeds WHO limit in Industrial district',
    district: 'Z-IND',
    severity: C.red,
    icon: Icons.factory_rounded,
    time: '10:35',
  ),
  EnvAlert(
    id: 'EA-004',
    message: 'Commercial zone temperature 29.8°C — heat advisory',
    district: 'Z-COM',
    severity: C.amber,
    icon: Icons.thermostat_rounded,
    time: '09:44',
  ),
  EnvAlert(
    id: 'EA-005',
    message: 'UV Index 6.2 — moderate risk, outdoor caution advised',
    district: 'CITY',
    severity: C.yellow,
    icon: Icons.wb_sunny_rounded,
    time: '09:00',
    acknowledged: true,
  ),
  EnvAlert(
    id: 'EA-006',
    message: 'CO₂ rising in Residential — check ventilation',
    district: 'Z-RES',
    severity: C.lime,
    icon: Icons.cloud_circle_rounded,
    time: '08:30',
    acknowledged: true,
  ),
];

List<HourlyEnvPoint> buildHourly() => List.generate(24, (h) {
  final dayFrac = h / 24;
  final temp = 22 + 8 * sin((dayFrac - 0.25) * 2 * pi) + rng.nextDouble() * 2;
  final humidity =
      65 - 15 * sin((dayFrac - 0.25) * 2 * pi) + rng.nextDouble() * 5;
  final aqi = 60 + 40 * sin(dayFrac * 2 * pi) + rng.nextDouble() * 20;
  final noise = h >= 7 && h <= 22
      ? 60 + rng.nextDouble() * 20
      : 40 + rng.nextDouble() * 10;
  final rainfall = h >= 14 && h <= 18
      ? rng.nextDouble() * 6
      : rng.nextDouble() * 0.5;
  return HourlyEnvPoint(
    h,
    temp,
    humidity.clamp(30, 95),
    aqi.clamp(20, 200),
    noise,
    rainfall,
  );
});
final sensorConfigs = {
  SensorType.temperature: {
    'id': 'TMP',
    'name': 'TEMPERATURE',
    'unit': '°C',
    'icon': Icons.thermostat_rounded,
    'color': C.amber,
    'min': -10.0,
    'max': 50.0,
    'thresholdWarn': 35.0,
    'thresholdCrit': 40.0,
  },
  SensorType.humidity: {
    'id': 'HUM',
    'name': 'HUMIDITY',
    'unit': '%',
    'icon': Icons.water_drop_rounded,
    'color': C.cyan,
    'min': 0.0,
    'max': 100.0,
    'thresholdWarn': 75.0,
    'thresholdCrit': 90.0,
  },
  SensorType.airQuality: {
    'id': 'AQI',
    'name': 'AIR QUALITY',
    'unit': 'AQI',
    'icon': Icons.air_rounded,
    'color': C.teal,
    'min': 0.0,
    'max': 300.0,
    'thresholdWarn': 100.0,
    'thresholdCrit': 150.0,
  },
  SensorType.noiseLevel: {
    'id': 'NOI',
    'name': 'NOISE LEVEL',
    'unit': 'dB',
    'icon': Icons.graphic_eq_rounded,
    'color': C.violet,
    'min': 30.0,
    'max': 120.0,
    'thresholdWarn': 70.0,
    'thresholdCrit': 85.0,
  },
  SensorType.windSpeed: {
    'id': 'WSP',
    'name': 'WIND SPEED',
    'unit': 'km/h',
    'icon': Icons.air_rounded,
    'color': C.mint,
    'min': 0.0,
    'max': 100.0,
    'thresholdWarn': 50.0,
    'thresholdCrit': 75.0,
  },
};
