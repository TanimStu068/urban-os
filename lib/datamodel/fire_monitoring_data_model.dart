import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

// ─────────────────────────────────────────
//  ENUMS & DATA MODELS
// ─────────────────────────────────────────
enum FireIntensity { lowSmolder, moderate, high, critical, flashover }

enum ZoneStatus { clear, smoke, fire, hotspot, collapsed }

enum EquipmentType { sprinkler, foam, ventilation, firewall, sensor }

enum EquipmentStatus { operational, active, impaired, offline }

extension FireIntensityX on FireIntensity {
  String get label {
    switch (this) {
      case FireIntensity.lowSmolder:
        return 'SMOLDER';
      case FireIntensity.moderate:
        return 'MODERATE';
      case FireIntensity.high:
        return 'HIGH';
      case FireIntensity.critical:
        return 'CRITICAL';
      case FireIntensity.flashover:
        return 'FLASHOVER';
    }
  }

  Color get color {
    switch (this) {
      case FireIntensity.lowSmolder:
        return C.yellow;
      case FireIntensity.moderate:
        return C.orange;
      case FireIntensity.high:
        return C.red;
      case FireIntensity.critical:
        return C.pink;
      case FireIntensity.flashover:
        return C.violet;
    }
  }

  double get tempCelsius {
    switch (this) {
      case FireIntensity.lowSmolder:
        return 150;
      case FireIntensity.moderate:
        return 450;
      case FireIntensity.high:
        return 800;
      case FireIntensity.critical:
        return 1200;
      case FireIntensity.flashover:
        return 1500;
    }
  }
}

extension ZoneStatusX on ZoneStatus {
  String get label {
    switch (this) {
      case ZoneStatus.clear:
        return 'CLEAR';
      case ZoneStatus.smoke:
        return 'SMOKE';
      case ZoneStatus.fire:
        return 'FIRE';
      case ZoneStatus.hotspot:
        return 'HOTSPOT';
      case ZoneStatus.collapsed:
        return 'COLLAPSED';
    }
  }

  Color get color {
    switch (this) {
      case ZoneStatus.clear:
        return C.green;
      case ZoneStatus.smoke:
        return C.yellow;
      case ZoneStatus.fire:
        return C.red;
      case ZoneStatus.hotspot:
        return C.orange;
      case ZoneStatus.collapsed:
        return C.violet;
    }
  }

  IconData get icon {
    switch (this) {
      case ZoneStatus.clear:
        return Icons.check_circle_rounded;
      case ZoneStatus.smoke:
        return Icons.cloud_rounded;
      case ZoneStatus.fire:
        return Icons.local_fire_department_rounded;
      case ZoneStatus.hotspot:
        return Icons.thermostat_rounded;
      case ZoneStatus.collapsed:
        return Icons.broken_image_rounded;
    }
  }
}

extension EquipmentStatusX on EquipmentStatus {
  String get label {
    switch (this) {
      case EquipmentStatus.operational:
        return 'OPERATIONAL';
      case EquipmentStatus.active:
        return 'ACTIVE';
      case EquipmentStatus.impaired:
        return 'IMPAIRED';
      case EquipmentStatus.offline:
        return 'OFFLINE';
    }
  }

  Color get color {
    switch (this) {
      case EquipmentStatus.operational:
        return C.green;
      case EquipmentStatus.active:
        return C.cyan;
      case EquipmentStatus.impaired:
        return C.yellow;
      case EquipmentStatus.offline:
        return C.red;
    }
  }
}

class FireZone {
  final String id;
  final String name;
  final int level;
  ZoneStatus status;
  FireIntensity intensity;
  double temperature;
  double visibility; // 0-100%
  double spreadRate; // m/s
  int peopleInZone;
  int estimatedEvacTime; // seconds
  List<String> equipment;

  FireZone({
    required this.id,
    required this.name,
    required this.level,
    required this.status,
    required this.intensity,
    required this.temperature,
    required this.visibility,
    required this.spreadRate,
    required this.peopleInZone,
    required this.estimatedEvacTime,
    required this.equipment,
  });

  String get dangerLevel {
    if (intensity == FireIntensity.flashover) return 'EXTREME';
    if (intensity == FireIntensity.critical) return 'SEVERE';
    if (intensity == FireIntensity.high) return 'HIGH';
    if (intensity == FireIntensity.moderate) return 'MODERATE';
    return 'LOW';
  }

  String get evactimeDisplay {
    if (estimatedEvacTime <= 0) return 'EVACUATED';
    if (estimatedEvacTime < 60) return '${estimatedEvacTime}s';
    return '${(estimatedEvacTime / 60).toStringAsFixed(1)}m';
  }
}

class FireEquipment {
  final String id;
  final String name;
  final EquipmentType type;
  EquipmentStatus status;
  final int floorLocation;
  final double efficiency; // 0-100%
  final int waterRemaining; // liters (for sprinkler/foam)
  int responseTime; // seconds since activation

  FireEquipment({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.floorLocation,
    required this.efficiency,
    required this.waterRemaining,
    required this.responseTime,
  });

  String get waterPercent =>
      '${((waterRemaining / 5000) * 100).toStringAsFixed(0)}%';
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
final rng = Random(321);

List<FireZone> buildZones() => [
  FireZone(
    id: 'ZONE-F01',
    name: 'Server Room L15',
    level: 15,
    status: ZoneStatus.fire,
    intensity: FireIntensity.critical,
    temperature: 1150,
    visibility: 5,
    spreadRate: 2.3,
    peopleInZone: 0,
    estimatedEvacTime: 0,
    equipment: ['FOAM-01', 'SPRINK-01', 'VENT-01'],
  ),
  FireZone(
    id: 'ZONE-F02',
    name: 'Office Floor L14',
    level: 14,
    status: ZoneStatus.hotspot,
    intensity: FireIntensity.high,
    temperature: 820,
    visibility: 15,
    spreadRate: 1.8,
    peopleInZone: 8,
    estimatedEvacTime: 240,
    equipment: ['SPRINK-02', 'VENT-02'],
  ),
  FireZone(
    id: 'ZONE-F03',
    name: 'Stairwell A',
    level: 13,
    status: ZoneStatus.smoke,
    intensity: FireIntensity.moderate,
    temperature: 380,
    visibility: 40,
    spreadRate: 0.9,
    peopleInZone: 12,
    estimatedEvacTime: 180,
    equipment: ['WALL-01', 'VENT-03'],
  ),
  FireZone(
    id: 'ZONE-F04',
    name: 'Lobby & Entrance',
    level: 1,
    status: ZoneStatus.clear,
    intensity: FireIntensity.lowSmolder,
    temperature: 22,
    visibility: 100,
    spreadRate: 0,
    peopleInZone: 0,
    estimatedEvacTime: 0,
    equipment: [],
  ),
  FireZone(
    id: 'ZONE-F05',
    name: 'Basement Level B1',
    level: 0,
    status: ZoneStatus.hotspot,
    intensity: FireIntensity.moderate,
    temperature: 580,
    visibility: 25,
    spreadRate: 1.2,
    peopleInZone: 3,
    estimatedEvacTime: 120,
    equipment: ['FOAM-02', 'SPRINK-03'],
  ),
];

List<FireEquipment> buildEquipment() => [
  FireEquipment(
    id: 'FOAM-01',
    name: 'Foam System L15',
    type: EquipmentType.foam,
    status: EquipmentStatus.active,
    floorLocation: 15,
    efficiency: 78,
    waterRemaining: 2200,
    responseTime: 45,
  ),
  FireEquipment(
    id: 'FOAM-02',
    name: 'Foam System B1',
    type: EquipmentType.foam,
    status: EquipmentStatus.active,
    floorLocation: 0,
    efficiency: 65,
    waterRemaining: 1800,
    responseTime: 32,
  ),
  FireEquipment(
    id: 'SPRINK-01',
    name: 'Sprinkler Network L15',
    type: EquipmentType.sprinkler,
    status: EquipmentStatus.active,
    floorLocation: 15,
    efficiency: 92,
    waterRemaining: 3500,
    responseTime: 8,
  ),
  FireEquipment(
    id: 'SPRINK-02',
    name: 'Sprinkler Network L14',
    type: EquipmentType.sprinkler,
    status: EquipmentStatus.active,
    floorLocation: 14,
    efficiency: 88,
    waterRemaining: 3200,
    responseTime: 12,
  ),
  FireEquipment(
    id: 'SPRINK-03',
    name: 'Sprinkler Network B1',
    type: EquipmentType.sprinkler,
    status: EquipmentStatus.operational,
    floorLocation: 0,
    efficiency: 84,
    waterRemaining: 2900,
    responseTime: 0,
  ),
  FireEquipment(
    id: 'VENT-01',
    name: 'Smoke Ventilation L15',
    type: EquipmentType.ventilation,
    status: EquipmentStatus.active,
    floorLocation: 15,
    efficiency: 75,
    waterRemaining: 5000,
    responseTime: 15,
  ),
  FireEquipment(
    id: 'VENT-02',
    name: 'Smoke Ventilation L14',
    type: EquipmentType.ventilation,
    status: EquipmentStatus.active,
    floorLocation: 14,
    efficiency: 68,
    waterRemaining: 5000,
    responseTime: 18,
  ),
  FireEquipment(
    id: 'VENT-03',
    name: 'Smoke Ventilation L13',
    type: EquipmentType.ventilation,
    status: EquipmentStatus.active,
    floorLocation: 13,
    efficiency: 62,
    waterRemaining: 5000,
    responseTime: 22,
  ),
  FireEquipment(
    id: 'WALL-01',
    name: 'Fire Wall L13-L14',
    type: EquipmentType.firewall,
    status: EquipmentStatus.operational,
    floorLocation: 13,
    efficiency: 95,
    waterRemaining: 5000,
    responseTime: 0,
  ),
];
