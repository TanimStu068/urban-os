import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

// ─────────────────────────────────────────
//  ENUMS & DATA MODELS
// ─────────────────────────────────────────
enum PollutantType { pm25, pm10, no2, o3, co, so2 }

enum TimeRange { h24, day7, month30, year }

extension PollutantTypeX on PollutantType {
  String get label {
    switch (this) {
      case PollutantType.pm25:
        return 'PM 2.5';
      case PollutantType.pm10:
        return 'PM 10';
      case PollutantType.no2:
        return 'NO₂';
      case PollutantType.o3:
        return 'O₃';
      case PollutantType.co:
        return 'CO';
      case PollutantType.so2:
        return 'SO₂';
    }
  }

  String get unit {
    switch (this) {
      case PollutantType.pm25:
      case PollutantType.pm10:
      case PollutantType.no2:
      case PollutantType.o3:
      case PollutantType.so2:
        return 'µg/m³';
      case PollutantType.co:
        return 'mg/m³';
    }
  }

  Color get color {
    switch (this) {
      case PollutantType.pm25:
        return C.red;
      case PollutantType.pm10:
        return C.orange;
      case PollutantType.no2:
        return C.amber;
      case PollutantType.o3:
        return C.cyan;
      case PollutantType.co:
        return C.violet;
      case PollutantType.so2:
        return C.lime;
    }
  }

  double get safeLimit {
    switch (this) {
      case PollutantType.pm25:
        return 25.0;
      case PollutantType.pm10:
        return 50.0;
      case PollutantType.no2:
        return 40.0;
      case PollutantType.o3:
        return 100.0;
      case PollutantType.co:
        return 10.0;
      case PollutantType.so2:
        return 20.0;
    }
  }
}

class PollutionDataPoint {
  final DateTime timestamp;
  final double pm25;
  final double pm10;
  final double no2;
  final double o3;
  final double co;
  final double so2;

  PollutionDataPoint({
    required this.timestamp,
    required this.pm25,
    required this.pm10,
    required this.no2,
    required this.o3,
    required this.co,
    required this.so2,
  });
}

class DistrictPollutionData {
  final String id;
  final String name;
  final Color color;
  final double pm25;
  final double pm10;
  final double no2;
  final double o3;
  final double co;
  final double so2;
  final String primarySource;
  final int healthRiskLevel; // 1-5

  DistrictPollutionData({
    required this.id,
    required this.name,
    required this.color,
    required this.pm25,
    required this.pm10,
    required this.no2,
    required this.o3,
    required this.co,
    required this.so2,
    required this.primarySource,
    required this.healthRiskLevel,
  });
}

class PollutionSource {
  final String id;
  final String name;
  final Color color;
  final IconData icon;
  final double percentage;
  final List<double> contribution;

  PollutionSource({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.percentage,
    required this.contribution,
  });
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
final rng = Random(42);

List<double> genTrendData(int count, double base, double variance) =>
    List.generate(
      count,
      (_) => (base + rng.nextDouble() * variance - variance / 2).clamp(0, 500),
    );

List<PollutionDataPoint> buildHourlyData() => List.generate(24, (h) {
  final t = rng.nextDouble();
  return PollutionDataPoint(
    timestamp: DateTime.now().subtract(Duration(hours: 24 - h)),
    pm25: 25 + t * 20 + 8 * sin((h / 24) * 2 * pi),
    pm10: 48 + t * 25 + 12 * sin((h / 24) * 2 * pi),
    no2: 38 + t * 15 + 6 * sin((h / 24) * 2 * pi),
    o3: 68 + t * 20 + 14 * sin(((h + 6) / 24) * 2 * pi),
    co: 0.8 + t * 0.4,
    so2: 14 + t * 8,
  );
});

List<DistrictPollutionData> buildDistrictData() => [
  DistrictPollutionData(
    id: 'Z-IND-01',
    name: 'Industrial Zone Alpha',
    color: C.red,
    pm25: 48.2,
    pm10: 72.4,
    no2: 62.1,
    o3: 42.5,
    co: 1.8,
    so2: 28.3,
    primarySource: 'Industrial Emissions',
    healthRiskLevel: 5,
  ),
  DistrictPollutionData(
    id: 'Z-TRN-02',
    name: 'Transport Hub',
    color: C.orange,
    pm25: 35.1,
    pm10: 58.6,
    no2: 54.3,
    o3: 38.2,
    co: 1.2,
    so2: 12.4,
    primarySource: 'Vehicle Emissions',
    healthRiskLevel: 4,
  ),
  DistrictPollutionData(
    id: 'Z-COM-03',
    name: 'Commercial District',
    color: C.amber,
    pm25: 28.7,
    pm10: 45.2,
    no2: 41.8,
    o3: 52.1,
    co: 0.9,
    so2: 10.2,
    primarySource: 'Mixed Sources',
    healthRiskLevel: 3,
  ),
  DistrictPollutionData(
    id: 'Z-RES-04',
    name: 'Residential Area',
    color: C.cyan,
    pm25: 18.4,
    pm10: 32.1,
    no2: 28.5,
    o3: 65.3,
    co: 0.5,
    so2: 7.8,
    primarySource: 'Residential Heating',
    healthRiskLevel: 2,
  ),
];

List<PollutionSource> buildSources() => [
  PollutionSource(
    id: 'SRC-VEH',
    name: 'Vehicles',
    color: C.orange,
    icon: Icons.directions_car_rounded,
    percentage: 38.5,
    contribution: genTrendData(24, 38.5, 8),
  ),
  PollutionSource(
    id: 'SRC-IND',
    name: 'Industry',
    color: C.red,
    icon: Icons.factory_rounded,
    percentage: 28.2,
    contribution: genTrendData(24, 28.2, 6),
  ),
  PollutionSource(
    id: 'SRC-RES',
    name: 'Residential',
    color: C.amber,
    icon: Icons.home_rounded,
    percentage: 18.3,
    contribution: genTrendData(24, 18.3, 4),
  ),
  PollutionSource(
    id: 'SRC-AGR',
    name: 'Agricultural',
    color: C.lime,
    icon: Icons.eco_rounded,
    percentage: 9.2,
    contribution: genTrendData(24, 9.2, 2),
  ),
  PollutionSource(
    id: 'SRC-OTH',
    name: 'Other',
    color: C.muted,
    icon: Icons.help_outline_rounded,
    percentage: 5.8,
    contribution: genTrendData(24, 5.8, 1),
  ),
];
Color getRiskColor(int level) {
  switch (level) {
    case 1:
      return C.green;
    case 2:
      return C.lime;
    case 3:
      return C.amber;
    case 4:
      return C.orange;
    case 5:
      return C.red;
    default:
      return C.muted;
  }
}

double getDistrictPollutantValue(
  DistrictPollutionData district,
  PollutantType type,
) {
  switch (type) {
    case PollutantType.pm25:
      return district.pm25;
    case PollutantType.pm10:
      return district.pm10;
    case PollutantType.no2:
      return district.no2;
    case PollutantType.o3:
      return district.o3;
    case PollutantType.co:
      return district.co;
    case PollutantType.so2:
      return district.so2;
  }
}
