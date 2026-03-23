import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/providers/district/district_provider.dart';
import 'package:urban_os/widgets/district_analytics/radar_axis.dart';

typedef C = AppColors;
List<(String, IconData, Color, String)> generateInsights(DistrictModel d) {
  final list = <(String, IconData, Color, String)>[];
  if (d.metrics.safetyScore < 50) {
    list.add((
      'CRITICAL SAFETY',
      Icons.warning_amber_rounded,
      C.red,
      'Safety score is critically low at ${d.metrics.safetyScore.toInt()}. Immediate infrastructure review recommended.',
    ));
  }
  if (d.metrics.airQualityIndex > 150) {
    list.add((
      'AIR QUALITY ALERT',
      Icons.air_rounded,
      C.red,
      'AQI of ${d.metrics.airQualityIndex.toInt()} exceeds safe threshold. Pollution controls advised.',
    ));
  }
  if (d.metrics.averageTraffic > 75) {
    list.add((
      'CONGESTION WARNING',
      Icons.traffic_rounded,
      C.amber,
      'Traffic congestion at ${d.metrics.averageTraffic.toInt()}%. Signal optimization may reduce by 12–18%.',
    ));
  }

  if ((d.metrics.renewableEnergyPercent ?? 0) < 30) {
    list.add((
      'LOW RENEWABLE ENERGY',
      Icons.energy_savings_leaf_rounded,
      C.amber,
      'Renewable energy at ${(d.metrics.renewableEnergyPercent ?? 0).toInt()}%. Consider solar/wind installations.',
    ));
  }
  if ((d.metrics.greenSpacePercentage ?? 0) < 15) {
    list.add((
      'INSUFFICIENT GREEN SPACE',
      Icons.park_rounded,
      C.green,
      'Green space below recommended 15%. Consider urban greening initiatives.',
    ));
  }
  if (d.healthPercentage >= 80) {
    list.add((
      'HIGH PERFORMANCE DISTRICT',
      Icons.star_rounded,
      C.green,
      'This district scores in the top tier with ${d.healthPercentage.toStringAsFixed(0)}% health. Best practices can be replicated citywide.',
    ));
  }
  if ((d.metrics.satisfactionScore ?? 70) > 80) {
    list.add((
      'HIGH CITIZEN SATISFACTION',
      Icons.sentiment_satisfied_rounded,
      C.cyan,
      'Satisfaction at ${(d.metrics.satisfactionScore ?? 0).toInt()}% indicates strong community engagement.',
    ));
  }
  if (list.isEmpty) {
    list.add((
      'DISTRICT NOMINAL',
      Icons.check_circle_outline_rounded,
      C.cyan,
      'All primary metrics are within normal operating ranges. Continue monitoring.',
    ));
  }
  return list;
}

List<RadarAxis> buildCityAverageAxes(DistrictProvider dp) {
  final ds = dp.districts;
  if (ds.isEmpty) return [];
  double avg(double Function(DistrictModel) fn) =>
      ds.fold(0.0, (a, b) => a + fn(b)) / ds.length;
  return [
    RadarAxis('HEALTH', avg((d) => d.healthPercentage) / 100, C.cyan),
    RadarAxis('SAFETY', avg((d) => d.metrics.safetyScore) / 100, C.green),
    RadarAxis(
      'TRAFFIC',
      1 - avg((d) => d.metrics.averageTraffic) / 100,
      C.amber,
    ),
    RadarAxis(
      'AIR',
      1 - avg((d) => d.metrics.airQualityIndex.clamp(0, 500)) / 500,
      C.green,
    ),
    RadarAxis(
      'ENERGY EFF',
      1 - avg((d) => d.metrics.energyConsumption.clamp(0, 1000)) / 1000,
      C.amber,
    ),
    RadarAxis('SUSTAIN', avg((d) => d.sustainabilityScore ?? 50) / 100, C.cyan),
    RadarAxis(
      'SATISFACT',
      avg((d) => d.metrics.satisfactionScore ?? 70) / 100,
      C.violet,
    ),
    RadarAxis(
      'GREEN',
      avg((d) => d.metrics.greenSpacePercentage ?? 20) / 100,
      C.green,
    ),
  ];
}

List<RadarAxis> buildRadarAxes(DistrictModel d) => [
  RadarAxis('HEALTH', d.healthPercentage / 100, C.cyan),
  RadarAxis('SAFETY', d.metrics.safetyScore / 100, C.green),
  RadarAxis('TRAFFIC', 1 - (d.metrics.averageTraffic / 100), C.amber),
  RadarAxis(
    'AIR',
    1 - (d.metrics.airQualityIndex.clamp(0, 500) / 500),
    C.green,
  ),
  RadarAxis(
    'ENERGY EFF',
    (1 - (d.metrics.energyConsumption.clamp(0, 1000) / 1000)),
    C.amber,
  ),
  RadarAxis('SUSTAIN', (d.sustainabilityScore ?? 50) / 100, C.cyan),
  RadarAxis('SATISFACT', (d.metrics.satisfactionScore ?? 70) / 100, C.violet),
  RadarAxis('GREEN', (d.metrics.greenSpacePercentage ?? 20) / 100, C.green),
];
Color healthColor(double h) => h >= 70
    ? C.green
    : h >= 45
    ? C.amber
    : C.red;
String ago(DateTime dt) {
  final d = DateTime.now().difference(dt);
  if (d.inMinutes < 60) return '${d.inMinutes}m ago';
  if (d.inHours < 24) return '${d.inHours}h ago';
  return '${d.inDays}d ago';
}
