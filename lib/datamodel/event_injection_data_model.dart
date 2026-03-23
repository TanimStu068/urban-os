import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

// ─────────────────────────────────────────
//  ENUMS & DATA MODELS
// ─────────────────────────────────────────
enum EventType {
  fire,
  accident,
  powerOutage,
  weatherEvent,
  crowdSurge,
  pollution,
  waterLeak,
  cyberAttack,
}

enum EventSeverity { low, medium, high, critical }

enum EventStatus { scheduled, active, completed, failed, cancelled }

enum ImpactArea { single, district, citywide }

extension EventTypeX on EventType {
  String get label {
    switch (this) {
      case EventType.fire:
        return 'FIRE';
      case EventType.accident:
        return 'ACCIDENT';
      case EventType.powerOutage:
        return 'POWER OUTAGE';
      case EventType.weatherEvent:
        return 'WEATHER';
      case EventType.crowdSurge:
        return 'CROWD SURGE';
      case EventType.pollution:
        return 'POLLUTION';
      case EventType.waterLeak:
        return 'WATER LEAK';
      case EventType.cyberAttack:
        return 'CYBER ATTACK';
    }
  }

  IconData get icon {
    switch (this) {
      case EventType.fire:
        return Icons.local_fire_department_rounded;
      case EventType.accident:
        return Icons.traffic_rounded;
      case EventType.powerOutage:
        return Icons.flash_off_rounded;
      case EventType.weatherEvent:
        return Icons.cloud_rounded;
      case EventType.crowdSurge:
        return Icons.people_rounded;
      case EventType.pollution:
        return Icons.air_rounded;
      case EventType.waterLeak:
        return Icons.water_damage_rounded;
      case EventType.cyberAttack:
        return Icons.security_rounded;
    }
  }

  Color get color {
    switch (this) {
      case EventType.fire:
        return C.red;
      case EventType.accident:
        return C.orange;
      case EventType.powerOutage:
        return C.yellow;
      case EventType.weatherEvent:
        return C.cyan;
      case EventType.crowdSurge:
        return C.pink;
      case EventType.pollution:
        return C.amber;
      case EventType.waterLeak:
        return C.sky;
      case EventType.cyberAttack:
        return C.violet;
    }
  }
}

extension EventSeverityX on EventSeverity {
  String get label {
    switch (this) {
      case EventSeverity.low:
        return 'LOW';
      case EventSeverity.medium:
        return 'MEDIUM';
      case EventSeverity.high:
        return 'HIGH';
      case EventSeverity.critical:
        return 'CRITICAL';
    }
  }

  Color get color {
    switch (this) {
      case EventSeverity.low:
        return C.yellow;
      case EventSeverity.medium:
        return C.orange;
      case EventSeverity.high:
        return C.red;
      case EventSeverity.critical:
        return C.violet;
    }
  }
}

extension EventStatusX on EventStatus {
  String get label {
    switch (this) {
      case EventStatus.scheduled:
        return 'SCHEDULED';
      case EventStatus.active:
        return 'ACTIVE';
      case EventStatus.completed:
        return 'COMPLETED';
      case EventStatus.failed:
        return 'FAILED';
      case EventStatus.cancelled:
        return 'CANCELLED';
    }
  }

  Color get color {
    switch (this) {
      case EventStatus.scheduled:
        return C.yellow;
      case EventStatus.active:
        return C.red;
      case EventStatus.completed:
        return C.green;
      case EventStatus.failed:
        return C.orange;
      case EventStatus.cancelled:
        return C.mutedLt;
    }
  }
}

extension ImpactAreaX on ImpactArea {
  String get label {
    switch (this) {
      case ImpactArea.single:
        return 'SINGLE LOCATION';
      case ImpactArea.district:
        return 'DISTRICT';
      case ImpactArea.citywide:
        return 'CITY-WIDE';
    }
  }

  int get affectedZones {
    switch (this) {
      case ImpactArea.single:
        return 1;
      case ImpactArea.district:
        return 4;
      case ImpactArea.citywide:
        return 8;
    }
  }
}

class InjectedEvent {
  final String id;
  final EventType type;
  final EventSeverity severity;
  final String description;
  final String location;
  ImpactArea impactArea;
  EventStatus status;
  final DateTime createdAt;
  final int durationSeconds;
  int elapsedSeconds;
  final List<String> affectedSystems;
  final Map<String, dynamic> parameters;

  InjectedEvent({
    required this.id,
    required this.type,
    required this.severity,
    required this.description,
    required this.location,
    required this.impactArea,
    required this.status,
    required this.createdAt,
    required this.durationSeconds,
    required this.elapsedSeconds,
    required this.affectedSystems,
    required this.parameters,
  });

  String get timeRemaining {
    final remaining = durationSeconds - elapsedSeconds;
    if (remaining <= 0) return 'ENDED';
    if (remaining < 60) return '${remaining}s';
    return '${(remaining / 60).toStringAsFixed(1)}m';
  }

  double get progressPercent => (elapsedSeconds / durationSeconds).clamp(0, 1);

  int get systemsAffected => affectedSystems.length;
}

class EventTemplate {
  final EventType type;
  final String name;
  final String description;
  final EventSeverity defaultSeverity;
  final int defaultDuration; // seconds
  final List<String> affectedSystems;

  EventTemplate({
    required this.type,
    required this.name,
    required this.description,
    required this.defaultSeverity,
    required this.defaultDuration,
    required this.affectedSystems,
  });
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
final rng = Random(654);

List<InjectedEvent> buildActiveEvents() {
  final now = DateTime.now();
  return [
    InjectedEvent(
      id: 'EVT-001',
      type: EventType.fire,
      severity: EventSeverity.critical,
      description: 'High-rise fire scenario in downtown district',
      location: 'Commercial Tower, Downtown',
      impactArea: ImpactArea.district,
      status: EventStatus.active,
      createdAt: now.subtract(const Duration(minutes: 12)),
      durationSeconds: 1800,
      elapsedSeconds: 720,
      affectedSystems: ['FD-001', 'FD-002', 'TRAFFIC-001', 'ALERTS'],
      parameters: {
        'temperature': 950,
        'spreadRate': 2.1,
        'evacuationCount': 245,
      },
    ),
    InjectedEvent(
      id: 'EVT-002',
      type: EventType.powerOutage,
      severity: EventSeverity.high,
      description: 'Grid failure in industrial zone',
      location: 'Industrial District, East',
      impactArea: ImpactArea.district,
      status: EventStatus.active,
      createdAt: now.subtract(const Duration(minutes: 5)),
      durationSeconds: 900,
      elapsedSeconds: 300,
      affectedSystems: ['GRID-01', 'BACKUP-01', 'LIGHTING', 'PUMPS'],
      parameters: {'zones': 4, 'powerLoss': 45, 'duration': 15},
    ),
    InjectedEvent(
      id: 'EVT-003',
      type: EventType.weatherEvent,
      severity: EventSeverity.medium,
      description: 'Heavy rainfall and wind simulation',
      location: 'City-wide',
      impactArea: ImpactArea.citywide,
      status: EventStatus.active,
      createdAt: now.subtract(const Duration(minutes: 2)),
      durationSeconds: 3600,
      elapsedSeconds: 120,
      affectedSystems: ['WEATHER', 'DRAINAGE', 'TRAFFIC', 'VISIBILITY'],
      parameters: {'rainfallMm': 35, 'windSpeed': 45, 'visibility': 200},
    ),
  ];
}

List<EventTemplate> buildTemplates() => [
  EventTemplate(
    type: EventType.fire,
    name: 'High-Rise Fire',
    description: 'Multi-floor structural fire scenario',
    defaultSeverity: EventSeverity.critical,
    defaultDuration: 1800,
    affectedSystems: ['FIRE_BRIGADE', 'ALERTS', 'EVACUATION', 'SPRINKLERS'],
  ),
  EventTemplate(
    type: EventType.accident,
    name: 'Multi-Vehicle Collision',
    description: 'Traffic accident blocking main roads',
    defaultSeverity: EventSeverity.high,
    defaultDuration: 900,
    affectedSystems: ['TRAFFIC_CONTROL', 'AMBULANCE', 'POLICE', 'ALERTS'],
  ),
  EventTemplate(
    type: EventType.powerOutage,
    name: 'Grid Failure',
    description: 'Partial or complete power grid failure',
    defaultSeverity: EventSeverity.critical,
    defaultDuration: 1200,
    affectedSystems: [
      'POWER_GRID',
      'BACKUP_SYSTEMS',
      'LIGHTING',
      'INFRASTRUCTURE',
    ],
  ),
  EventTemplate(
    type: EventType.weatherEvent,
    name: 'Extreme Weather',
    description: 'Heavy rain, wind, or temperature extremes',
    defaultSeverity: EventSeverity.medium,
    defaultDuration: 3600,
    affectedSystems: ['WEATHER_SYSTEMS', 'DRAINAGE', 'VISIBILITY', 'TRAFFIC'],
  ),
  EventTemplate(
    type: EventType.crowdSurge,
    name: 'Crowd Surge',
    description: 'Unexpected crowd density at transit hub',
    defaultSeverity: EventSeverity.high,
    defaultDuration: 600,
    affectedSystems: ['CROWD_CONTROL', 'ALERTS', 'SECURITY', 'TRANSIT'],
  ),
  EventTemplate(
    type: EventType.pollution,
    name: 'Air Quality Drop',
    description: 'Sudden pollution spike in district',
    defaultSeverity: EventSeverity.medium,
    defaultDuration: 2400,
    affectedSystems: ['AIR_FILTERS', 'MONITORING', 'ALERTS', 'TRANSPORT'],
  ),
  EventTemplate(
    type: EventType.waterLeak,
    name: 'Water Main Break',
    description: 'Major water infrastructure failure',
    defaultSeverity: EventSeverity.high,
    defaultDuration: 1200,
    affectedSystems: ['WATER_SYSTEMS', 'DRAINAGE', 'ALERTS', 'REPAIRS'],
  ),
  EventTemplate(
    type: EventType.cyberAttack,
    name: 'Cyber Security Intrusion',
    description: 'System intrusion or anomaly detection',
    defaultSeverity: EventSeverity.critical,
    defaultDuration: 900,
    affectedSystems: ['SECURITY', 'MONITORING', 'ALERTS', 'SYSTEMS'],
  ),
];
