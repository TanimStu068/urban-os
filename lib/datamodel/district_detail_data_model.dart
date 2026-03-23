import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/district/district_type.dart';
import 'package:urban_os/widgets/district_detail/actuator_row.dart';
import 'package:urban_os/widgets/district_detail/empty_tap.dart';
import 'package:urban_os/widgets/district_detail/incident_panel.dart';
import 'package:urban_os/widgets/district_detail/info_card.dart';
import 'package:urban_os/widgets/district_detail/matrict_grid.dart';
import 'package:urban_os/widgets/district_detail/matrict_item.dart';
import 'package:urban_os/widgets/district_detail/section_header.dart';
import 'package:urban_os/widgets/district_detail/sensor_row.dart';
import 'package:urban_os/widgets/district_detail/spark_history.dart';
import 'package:urban_os/widgets/district_detail/time_line_card.dart';

typedef C = AppColors;
String fmtNum(int n) => n >= 1000000
    ? '${(n / 1e6).toStringAsFixed(1)}M'
    : n >= 1000
    ? '${(n / 1000).toStringAsFixed(1)}K'
    : '$n';
String fmtDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String ago(DateTime dt) {
  final d = DateTime.now().difference(dt);
  if (d.inMinutes < 60) return '${d.inMinutes}m ago';
  if (d.inHours < 24) return '${d.inHours}h ago';
  return '${d.inDays}d ago';
}

List<(String, String, Color, String)> syntheticTimeline(DistrictModel d) {
  final now = DateTime.now();
  return [
    (
      'METRICS UPDATED',
      'Health score recalculated: ${d.healthPercentage.toStringAsFixed(1)}%',
      C.cyan,
      ago(now.subtract(const Duration(minutes: 5))),
    ),
    (
      'SENSOR SYNC',
      '${d.sensorIds.length} sensors reported nominal',
      C.green,
      ago(now.subtract(const Duration(minutes: 23))),
    ),
    if (d.metrics.activeIncidents > 0)
      (
        'INCIDENT RAISED',
        '${d.metrics.activeIncidents} incident(s) opened in ${d.name}',
        C.red,
        ago(now.subtract(const Duration(hours: 1))),
      ),
    (
      'TRAFFIC UPDATE',
      'Average congestion: ${d.metrics.averageTraffic.toInt()}%',
      C.amber,
      ago(now.subtract(const Duration(hours: 2))),
    ),
    (
      'ENERGY REPORT',
      'Consumption: ${d.metrics.energyConsumption.toStringAsFixed(1)} MWh',
      C.amber,
      ago(now.subtract(const Duration(hours: 4))),
    ),
    (
      'AQI READING',
      'Air quality index: ${d.metrics.airQualityIndex.toInt()}',
      aqiColor(d.metrics.airQualityIndex),
      ago(now.subtract(const Duration(hours: 6))),
    ),
    (
      'DISTRICT ADDED',
      'Joined monitoring system',
      C.violet,
      d.addedDate != null ? ago(d.addedDate!) : 'N/A',
    ),
  ];
}

List<Widget> buildHistoryTab(DistrictModel d) => [
  SectionHeader('UPDATE TIMELINE', C.violet),
  const SizedBox(height: 10),
  TimelineCard(d: d, timelineGenerator: syntheticTimeline),
  // TimelineCard(d: d),
  const SizedBox(height: 16),
  SectionHeader('HEALTH TREND', C.cyan),
  const SizedBox(height: 10),
  SparkHistory(d: d),
];

List<Widget> buildActuatorsTab(DistrictModel d) {
  if (d.actuatorIds.isEmpty) {
    return [
      EmptyTab(message: 'No actuators registered', icon: Icons.bolt_rounded),
    ];
  }
  return [
    Row(
      children: [
        SectionHeader('ACTUATORS', C.amber),
        const Spacer(),
        Text(
          '${d.actuatorIds.length} TOTAL',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: C.mutedLt,
          ),
        ),
      ],
    ),
    const SizedBox(height: 10),
    ...d.actuatorIds.asMap().entries.map(
      (e) => ActuatorRow(e.value, e.key, C.amber),
    ),
  ];
}

List<Widget> buildSensorsTab(DistrictModel d) {
  if (d.sensorIds.isEmpty) {
    return [
      EmptyTab(message: 'No sensors registered', icon: Icons.sensors_rounded),
    ];
  }
  return [
    Row(
      children: [
        SectionHeader('SENSORS', C.green),
        const Spacer(),
        Text(
          '${d.sensorIds.length} TOTAL',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: C.mutedLt,
          ),
        ),
      ],
    ),
    const SizedBox(height: 10),
    ...d.sensorIds.asMap().entries.map(
      (e) => SensorRow(e.value, e.key, C.green),
    ),
  ];
}

List<Widget> buildOverview(DistrictModel d, Animation<double> blinkAnim) => [
  SectionHeader('CORE METRICS', C.cyan),
  const SizedBox(height: 10),
  // Full metric grid
  MetricGrid([
    MetricItem(
      'AVG TRAFFIC',
      '${d.metrics.averageTraffic.toStringAsFixed(1)}%',
      C.amber,
      Icons.traffic_rounded,
    ),
    MetricItem(
      'SAFETY SCORE',
      '${d.metrics.safetyScore.toStringAsFixed(1)}',
      C.green,
      Icons.security_rounded,
    ),
    MetricItem(
      'AIR QUALITY',
      '${d.metrics.airQualityIndex.toStringAsFixed(0)} AQI',
      aqiColor(d.metrics.airQualityIndex),
      Icons.air_rounded,
    ),
    MetricItem(
      'ENERGY USE',
      '${d.metrics.energyConsumption.toStringAsFixed(1)} MWh',
      C.amber,
      Icons.bolt_rounded,
    ),
    if (d.metrics.averageTemperature != null)
      MetricItem(
        'TEMPERATURE',
        '${d.metrics.averageTemperature!.toStringAsFixed(1)}°C',
        C.cyan,
        Icons.thermostat_rounded,
      ),
    if (d.metrics.averageHumidity != null)
      MetricItem(
        'HUMIDITY',
        '${d.metrics.averageHumidity!.toStringAsFixed(0)}%',
        C.cyan,
        Icons.water_drop_rounded,
      ),
    if (d.metrics.noiseLevelDb != null)
      MetricItem(
        'NOISE LEVEL',
        '${d.metrics.noiseLevelDb!.toStringAsFixed(0)} dB',
        C.red,
        Icons.volume_up_rounded,
      ),
    if (d.metrics.waterConsumption != null)
      MetricItem(
        'WATER USE',
        '${d.metrics.waterConsumption!.toStringAsFixed(0)} m³',
        C.cyan,
        Icons.water_rounded,
      ),
    if (d.metrics.greenSpacePercentage != null)
      MetricItem(
        'GREEN SPACE',
        '${d.metrics.greenSpacePercentage!.toStringAsFixed(0)}%',
        C.green,
        Icons.park_rounded,
      ),
    if (d.metrics.satisfactionScore != null)
      MetricItem(
        'SATISFACTION',
        '${d.metrics.satisfactionScore!.toStringAsFixed(0)}%',
        C.violet,
        Icons.sentiment_satisfied_rounded,
      ),
    if (d.metrics.wasteGeneration != null)
      MetricItem(
        'WASTE GEN',
        '${d.metrics.wasteGeneration!.toStringAsFixed(1)} t/day',
        C.mutedLt,
        Icons.delete_rounded,
      ),
    if (d.metrics.renewableEnergyPercent != null)
      MetricItem(
        'RENEWABLE',
        '${d.metrics.renewableEnergyPercent!.toStringAsFixed(0)}%',
        C.green,
        Icons.energy_savings_leaf_rounded,
      ),
  ]),
  const SizedBox(height: 16),
  SectionHeader('DISTRICT INFO', C.violet),
  const SizedBox(height: 10),
  InfoCard(d: d),
  const SizedBox(height: 16),
  if (d.metrics.activeIncidents > 0) ...[
    SectionHeader('ACTIVE INCIDENTS', C.red),
    const SizedBox(height: 10),
    IncidentPanel(d: d, blinkAnim: blinkAnim),
    // IncidentPanel(d: d),
    const SizedBox(height: 16),
  ],
];

Color aqiColor(double v) => v < 50
    ? C.green
    : v < 100
    ? C.amber
    : C.red;

Color healthColor(double h) => h >= 70
    ? C.green
    : h >= 45
    ? C.amber
    : C.red;
Color typeColor(DistrictType t) {
  switch (t) {
    case DistrictType.residential:
      return C.cyan;
    case DistrictType.commercial:
      return C.amber;
    case DistrictType.industrial:
      return C.mutedLt;
    case DistrictType.educational:
      return C.violet;
    case DistrictType.medical:
      return C.red;
    case DistrictType.greenZone:
      return C.green;
    case DistrictType.government:
      return C.violet;
    default:
      return C.cyan;
  }
}
