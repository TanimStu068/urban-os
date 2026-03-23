import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

enum EnergySource { grid, solar, wind, battery, generator }

enum ZoneStatus { normal, warning, critical, offline, saving }

enum AlertLevel { info, warning, critical }

extension EnergySourceX on EnergySource {
  Color get color {
    switch (this) {
      case EnergySource.grid:
        return C.amber;
      case EnergySource.solar:
        return C.yellow;
      case EnergySource.wind:
        return C.cyan;
      case EnergySource.battery:
        return C.green;
      case EnergySource.generator:
        return C.orange;
    }
  }

  IconData get icon {
    switch (this) {
      case EnergySource.grid:
        return Icons.electric_bolt_rounded;
      case EnergySource.solar:
        return Icons.wb_sunny_rounded;
      case EnergySource.wind:
        return Icons.air_rounded;
      case EnergySource.battery:
        return Icons.battery_charging_full_rounded;
      case EnergySource.generator:
        return Icons.settings_backup_restore_rounded;
    }
  }

  String get label {
    switch (this) {
      case EnergySource.grid:
        return 'GRID';
      case EnergySource.solar:
        return 'SOLAR';
      case EnergySource.wind:
        return 'WIND';
      case EnergySource.battery:
        return 'BATTERY';
      case EnergySource.generator:
        return 'GENERATOR';
    }
  }
}

extension ZoneStatusX on ZoneStatus {
  Color get color {
    switch (this) {
      case ZoneStatus.normal:
        return C.green;
      case ZoneStatus.warning:
        return C.amber;
      case ZoneStatus.critical:
        return C.red;
      case ZoneStatus.offline:
        return C.mutedLt;
      case ZoneStatus.saving:
        return C.cyan;
    }
  }

  String get label {
    switch (this) {
      case ZoneStatus.normal:
        return 'NORMAL';
      case ZoneStatus.warning:
        return 'WARNING';
      case ZoneStatus.critical:
        return 'CRITICAL';
      case ZoneStatus.offline:
        return 'OFFLINE';
      case ZoneStatus.saving:
        return 'ECO MODE';
    }
  }
}

// ─────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────
class PowerZone {
  final String id;
  final String name;
  final String district;
  double consumption; // kW
  final double capacity; // kW
  ZoneStatus status;
  double loadPct;
  final List<double> history; // 24-point hourly

  PowerZone({
    required this.id,
    required this.name,
    required this.district,
    required this.consumption,
    required this.capacity,
    required this.status,
    required this.loadPct,
    required this.history,
  });
}

class EnergySourceModel {
  final EnergySource type;
  double output; // kW
  double capacity; // kW
  double efficiency; // %
  bool isActive;
  final List<double> history;

  EnergySourceModel({
    required this.type,
    required this.output,
    required this.capacity,
    required this.efficiency,
    required this.isActive,
    required this.history,
  });

  double get loadPct =>
      capacity > 0 ? (output / capacity * 100).clamp(0, 100) : 0;
}

class EnergyAlert {
  final String id;
  final String message;
  final String zone;
  final AlertLevel level;
  final String time;
  bool acknowledged;

  EnergyAlert({
    required this.id,
    required this.message,
    required this.zone,
    required this.level,
    required this.time,
    this.acknowledged = false,
  });
}

class HourlyData {
  final int hour;
  final double consumption;
  final double generation;
  HourlyData(this.hour, this.consumption, this.generation);
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
List<PowerZone> buildZones() => [
  PowerZone(
    id: 'Z-01',
    name: 'RESIDENTIAL CORE',
    district: 'Residential',
    consumption: 4200,
    capacity: 6000,
    status: ZoneStatus.normal,
    loadPct: 70,
    history: rndHistory(3000, 5000),
  ),
  PowerZone(
    id: 'Z-02',
    name: 'INDUSTRIAL NORTH',
    district: 'Industrial',
    consumption: 8900,
    capacity: 10000,
    status: ZoneStatus.warning,
    loadPct: 89,
    history: rndHistory(6000, 9500),
  ),
  PowerZone(
    id: 'Z-03',
    name: 'COMMERCIAL HUB',
    district: 'Commercial',
    consumption: 5600,
    capacity: 7000,
    status: ZoneStatus.normal,
    loadPct: 80,
    history: rndHistory(3500, 6000),
  ),
  PowerZone(
    id: 'Z-04',
    name: 'MEDICAL DISTRICT',
    district: 'Medical',
    consumption: 3100,
    capacity: 4000,
    status: ZoneStatus.saving,
    loadPct: 77,
    history: rndHistory(2500, 3500),
  ),
  PowerZone(
    id: 'Z-05',
    name: 'TRANSPORT HUB',
    district: 'Transport',
    consumption: 2800,
    capacity: 3500,
    status: ZoneStatus.normal,
    loadPct: 80,
    history: rndHistory(2000, 3200),
  ),
  PowerZone(
    id: 'Z-06',
    name: 'EDUCATIONAL ZONE',
    district: 'Education',
    consumption: 1400,
    capacity: 2000,
    status: ZoneStatus.normal,
    loadPct: 70,
    history: rndHistory(800, 1600),
  ),
  PowerZone(
    id: 'Z-07',
    name: 'GOV. COMPLEX',
    district: 'Government',
    consumption: 1800,
    capacity: 2200,
    status: ZoneStatus.normal,
    loadPct: 82,
    history: rndHistory(1200, 2000),
  ),
  PowerZone(
    id: 'Z-08',
    name: 'GREEN ZONE WEST',
    district: 'Park',
    consumption: 340,
    capacity: 500,
    status: ZoneStatus.saving,
    loadPct: 68,
    history: rndHistory(200, 400),
  ),
  PowerZone(
    id: 'Z-09',
    name: 'INDUSTRIAL SOUTH',
    district: 'Industrial',
    consumption: 9700,
    capacity: 10000,
    status: ZoneStatus.critical,
    loadPct: 97,
    history: rndHistory(7000, 10000),
  ),
  PowerZone(
    id: 'Z-10',
    name: 'SUBSTATION ALPHA',
    district: 'Core',
    consumption: 0,
    capacity: 1000,
    status: ZoneStatus.offline,
    loadPct: 0,
    history: rndHistory(0, 0),
  ),
];

List<EnergySourceModel> buildSources() => [
  EnergySourceModel(
    type: EnergySource.grid,
    output: 28400,
    capacity: 40000,
    efficiency: 94.2,
    isActive: true,
    history: rndHistory(20000, 32000),
  ),
  EnergySourceModel(
    type: EnergySource.solar,
    output: 6200,
    capacity: 12000,
    efficiency: 87.5,
    isActive: true,
    history: rndHistory(0, 10000),
  ),
  EnergySourceModel(
    type: EnergySource.wind,
    output: 1800,
    capacity: 5000,
    efficiency: 76.3,
    isActive: true,
    history: rndHistory(500, 4000),
  ),
  EnergySourceModel(
    type: EnergySource.battery,
    output: 1200,
    capacity: 8000,
    efficiency: 92.1,
    isActive: true,
    history: rndHistory(0, 2000),
  ),
  EnergySourceModel(
    type: EnergySource.generator,
    output: 0,
    capacity: 6000,
    efficiency: 68.0,
    isActive: false,
    history: rndHistory(0, 0),
  ),
];

List<EnergyAlert> buildAlerts() => [
  EnergyAlert(
    id: 'EA-001',
    message: 'Grid load at 97% — shedding risk',
    zone: 'Z-09',
    level: AlertLevel.critical,
    time: '10:42',
  ),
  EnergyAlert(
    id: 'EA-002',
    message: 'Industrial North load > 89%',
    zone: 'Z-02',
    level: AlertLevel.warning,
    time: '10:31',
  ),
  EnergyAlert(
    id: 'EA-003',
    message: 'Substation Alpha offline — maintenance',
    zone: 'Z-10',
    level: AlertLevel.info,
    time: '09:15',
  ),
  EnergyAlert(
    id: 'EA-004',
    message: 'Solar output below expected (cloudy)',
    zone: 'SOLAR',
    level: AlertLevel.info,
    time: '08:50',
  ),
  EnergyAlert(
    id: 'EA-005',
    message: 'Battery reserve below 30%',
    zone: 'BATT',
    level: AlertLevel.warning,
    time: '08:22',
  ),
];

List<HourlyData> buildHourly() => List.generate(24, (h) {
  final base = 25000.0;
  final peak = h >= 8 && h <= 20 ? 1.4 : 0.75;
  final gen = h >= 7 && h <= 18
      ? (5000 + 3000 * sin((h - 7) / 11 * pi))
      : 1000.0;
  return HourlyData(h, base * peak + (Random().nextDouble() - 0.5) * 3000, gen);
});

List<double> rndHistory(double lo, double hi) {
  final r = Random();
  return List.generate(24, (_) => lo + r.nextDouble() * (hi - lo));
}
