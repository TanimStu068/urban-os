import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

enum TimeRange { h24, d7, d30, d90, y1 }

enum ChartMode { consumption, comparison, forecast, breakdown }

enum ViewTab { overview, districts, categories, costs, anomalies }

extension TimeRangeX on TimeRange {
  String get label {
    switch (this) {
      case TimeRange.h24:
        return '24H';
      case TimeRange.d7:
        return '7D';
      case TimeRange.d30:
        return '30D';
      case TimeRange.d90:
        return '90D';
      case TimeRange.y1:
        return '1Y';
    }
  }

  int get points {
    switch (this) {
      case TimeRange.h24:
        return 24;
      case TimeRange.d7:
        return 7;
      case TimeRange.d30:
        return 30;
      case TimeRange.d90:
        return 90;
      case TimeRange.y1:
        return 12;
    }
  }

  String xLabel(int i) {
    switch (this) {
      case TimeRange.h24:
        return '${i.toString().padLeft(2, '0')}:00';
      case TimeRange.d7:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i % 7];
      case TimeRange.d30:
        return 'D${i + 1}';
      case TimeRange.d90:
        return 'W${i + 1}';
      case TimeRange.y1:
        return [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ][i % 12];
    }
  }
}

//  DATA MODELS
class ConsumptionPoint {
  final int index;
  final double value; // kWh
  final double prevValue; // kWh (comparison)
  final double forecast; // kWh
  final bool isAnomaly;
  final double cost; // $
  ConsumptionPoint({
    required this.index,
    required this.value,
    required this.prevValue,
    required this.forecast,
    required this.isAnomaly,
    required this.cost,
  });
}

class DistrictConsumption {
  final String id;
  final String name;
  final Color color;
  final double total; // kWh
  final double pct; // % of total
  final double avgLoad; // kW
  final double peakLoad; // kW
  final double cost; // $
  final double change; // % vs prev period
  final List<double> sparkline;
  DistrictConsumption({
    required this.id,
    required this.name,
    required this.color,
    required this.total,
    required this.pct,
    required this.avgLoad,
    required this.peakLoad,
    required this.cost,
    required this.change,
    required this.sparkline,
  });
}

class CategoryData {
  final String name;
  final IconData icon;
  final Color color;
  final double value;
  final double pct;
  final double change;
  CategoryData({
    required this.name,
    required this.icon,
    required this.color,
    required this.value,
    required this.pct,
    required this.change,
  });
}

class AnomalyEvent {
  final String id;
  final String description;
  final String district;
  final double deviation; // %
  final double expectedKWh;
  final double actualKWh;
  final String time;
  final Color severity;
  bool acknowledged;
  AnomalyEvent({
    required this.id,
    required this.description,
    required this.district,
    required this.deviation,
    required this.expectedKWh,
    required this.actualKWh,
    required this.time,
    required this.severity,
    this.acknowledged = false,
  });
}

class HourlyHeatmapCell {
  final int day; // 0=Mon..6=Sun
  final int hour; // 0..23
  final double value; // kWh
  HourlyHeatmapCell(this.day, this.hour, this.value);
}

//  DATA FACTORY
final rng = Random(7);

List<double> wave(int n, double base, double amp, {double noise = 0.08}) =>
    List.generate(n, (i) {
      final curve = sin(i / n * 2 * pi - pi / 2) * 0.5 + 0.5;
      return (base +
              amp * curve +
              ((rng.nextDouble() - 0.5) * 2 * base * noise))
          .clamp(base * 0.3, base * 1.8);
    });

List<ConsumptionPoint> buildSeries(TimeRange r) {
  final n = r.points;
  final base = r == TimeRange.h24
      ? 2800.0
      : r == TimeRange.y1
      ? 420000.0
      : 65000.0;
  final amp = base * 0.35;
  final curr = wave(n, base, amp);
  final prev = wave(n, base * 0.92, amp * 0.9, noise: 0.07);
  final fore = List.generate(
    n,
    (i) => i < n * 0.7 ? curr[i] : prev[i] * (1.04 + rng.nextDouble() * 0.06),
  );
  return List.generate(n, (i) {
    final anomaly = rng.nextDouble() < 0.07;
    final val = anomaly ? curr[i] * (1.3 + rng.nextDouble() * 0.5) : curr[i];
    return ConsumptionPoint(
      index: i,
      value: val,
      prevValue: prev[i],
      forecast: fore[i],
      isAnomaly: anomaly,
      cost: val * 0.00015,
    );
  });
}

List<DistrictConsumption> buildDistricts() {
  final data = [
    ('Z-RES', 'Residential', C.cyan, 4200.0, 3900.0),
    ('Z-IND', 'Industrial', C.red, 9700.0, 8800.0),
    ('Z-COM', 'Commercial', C.amber, 5600.0, 5100.0),
    ('Z-MED', 'Medical', C.green, 3100.0, 2900.0),
    ('Z-EDU', 'Education', C.violet, 1400.0, 1350.0),
    ('Z-TRN', 'Transport', C.sky, 2800.0, 2600.0),
    ('Z-GOV', 'Government', C.yellow, 1800.0, 1700.0),
    ('Z-PRK', 'Green Zone', C.teal, 340.0, 320.0),
  ];
  final total = data.fold(0.0, (s, d) => s + d.$4);
  return data.map((d) {
    final change = (d.$4 - d.$5) / d.$5 * 100;
    return DistrictConsumption(
      id: d.$1,
      name: d.$2,
      color: d.$3,
      total: d.$4,
      pct: d.$4 / total * 100,
      avgLoad: d.$4 * 0.85,
      peakLoad: d.$4 * 1.18,
      cost: d.$4 * 0.00015 * 24,
      change: change,
      sparkline: wave(12, d.$4 * 0.9, d.$4 * 0.2, noise: 0.1),
    );
  }).toList();
}

List<CategoryData> buildCategories(double totalKWh) {
  final cats = [
    ('HVAC', Icons.thermostat_rounded, C.orange, 0.31),
    ('Lighting', Icons.wb_incandescent_rounded, C.yellow, 0.18),
    ('Industrial Proc.', Icons.factory_rounded, C.red, 0.22),
    ('Transport', Icons.electric_car_rounded, C.cyan, 0.09),
    ('IT & Comms', Icons.computer_rounded, C.violet, 0.08),
    ('Water Systems', Icons.water_drop_rounded, C.sky, 0.07),
    ('Other', Icons.more_horiz_rounded, C.mutedLt, 0.05),
  ];
  double prevPct = 0;
  return cats.map((c) {
    final v = totalKWh * c.$4;
    prevPct += 0.03;
    return CategoryData(
      name: c.$1,
      icon: c.$2,
      color: c.$3,
      value: v,
      pct: c.$4 * 100,
      change: ((rng.nextDouble() - 0.3) * 12),
    );
  }).toList();
}

List<AnomalyEvent> buildAnomalies() => [
  AnomalyEvent(
    id: 'AN-001',
    description: 'Sudden spike in Industrial South',
    district: 'Z-IND',
    deviation: 43.2,
    expectedKWh: 8200,
    actualKWh: 11740,
    time: '02:14',
    severity: C.red,
  ),
  AnomalyEvent(
    id: 'AN-002',
    description: 'HVAC overconsumption — Commercial Hub',
    district: 'Z-COM',
    deviation: 28.7,
    expectedKWh: 4900,
    actualKWh: 6308,
    time: '11:45',
    severity: C.red,
  ),
  AnomalyEvent(
    id: 'AN-003',
    description: 'Off-hours consumption — Education Zone',
    district: 'Z-EDU',
    deviation: 19.4,
    expectedKWh: 320,
    actualKWh: 382,
    time: '03:30',
    severity: C.amber,
  ),
  AnomalyEvent(
    id: 'AN-004',
    description: 'Medical District draw exceeds SLA',
    district: 'Z-MED',
    deviation: 14.1,
    expectedKWh: 2900,
    actualKWh: 3309,
    time: '14:22',
    severity: C.amber,
  ),
  AnomalyEvent(
    id: 'AN-005',
    description: 'Residential night usage elevated',
    district: 'Z-RES',
    deviation: 8.3,
    expectedKWh: 3800,
    actualKWh: 4116,
    time: '23:55',
    severity: C.yellow,
    acknowledged: true,
  ),
];

List<HourlyHeatmapCell> buildHeatmap() {
  final cells = <HourlyHeatmapCell>[];
  for (int d = 0; d < 7; d++) {
    for (int h = 0; h < 24; h++) {
      final isPeak = h >= 9 && h <= 20;
      final isWeekend = d >= 5;
      final base = isPeak
          ? (isWeekend ? 2200.0 : 3400.0)
          : (isWeekend ? 800.0 : 1200.0);
      cells.add(HourlyHeatmapCell(d, h, base + rng.nextDouble() * base * 0.3));
    }
  }
  return cells;
}
