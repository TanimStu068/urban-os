import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

enum AlertSeverity { critical, high, medium, low }

enum ResponseTeamStatus { idle, deployed, enroute, onscene, standby }

enum IncidentType {
  fire,
  medical,
  accident,
  hazmat,
  structural,
  security,
  other,
}

enum DispatchStatus {
  pending,
  confirmed,
  enroute,
  arrived,
  completed,
  cancelled,
}

extension AlertSeverityX on AlertSeverity {
  String get label {
    switch (this) {
      case AlertSeverity.critical:
        return 'CRITICAL';
      case AlertSeverity.high:
        return 'HIGH';
      case AlertSeverity.medium:
        return 'MEDIUM';
      case AlertSeverity.low:
        return 'LOW';
    }
  }

  Color get color {
    switch (this) {
      case AlertSeverity.critical:
        return C.red;
      case AlertSeverity.high:
        return C.orange;
      case AlertSeverity.medium:
        return C.yellow;
      case AlertSeverity.low:
        return C.cyan;
    }
  }

  Color get bgColor {
    switch (this) {
      case AlertSeverity.critical:
        return C.red.withOpacity(0.15);
      case AlertSeverity.high:
        return C.orange.withOpacity(0.12);
      case AlertSeverity.medium:
        return C.yellow.withOpacity(0.10);
      case AlertSeverity.low:
        return C.cyan.withOpacity(0.08);
    }
  }
}

extension ResponseTeamStatusX on ResponseTeamStatus {
  String get label {
    switch (this) {
      case ResponseTeamStatus.idle:
        return 'IDLE';
      case ResponseTeamStatus.deployed:
        return 'DEPLOYED';
      case ResponseTeamStatus.enroute:
        return 'EN ROUTE';
      case ResponseTeamStatus.onscene:
        return 'ON SCENE';
      case ResponseTeamStatus.standby:
        return 'STANDBY';
    }
  }

  Color get color {
    switch (this) {
      case ResponseTeamStatus.idle:
        return C.mutedLt;
      case ResponseTeamStatus.deployed:
        return C.yellow;
      case ResponseTeamStatus.enroute:
        return C.orange;
      case ResponseTeamStatus.onscene:
        return C.green;
      case ResponseTeamStatus.standby:
        return C.cyan;
    }
  }
}

extension IncidentTypeX on IncidentType {
  String get label {
    switch (this) {
      case IncidentType.fire:
        return 'FIRE';
      case IncidentType.medical:
        return 'MEDICAL';
      case IncidentType.accident:
        return 'ACCIDENT';
      case IncidentType.hazmat:
        return 'HAZMAT';
      case IncidentType.structural:
        return 'STRUCTURAL';
      case IncidentType.security:
        return 'SECURITY';
      case IncidentType.other:
        return 'OTHER';
    }
  }

  IconData get icon {
    switch (this) {
      case IncidentType.fire:
        return Icons.local_fire_department_rounded;
      case IncidentType.medical:
        return Icons.health_and_safety_rounded;
      case IncidentType.accident:
        return Icons.traffic_rounded;
      case IncidentType.hazmat:
        return Icons.warning_rounded;
      case IncidentType.structural:
        return Icons.apartment;
      case IncidentType.security:
        return Icons.security_rounded;
      case IncidentType.other:
        return Icons.emergency_rounded;
    }
  }

  Color get color {
    switch (this) {
      case IncidentType.fire:
        return C.red;
      case IncidentType.medical:
        return C.pink;
      case IncidentType.accident:
        return C.yellow;
      case IncidentType.hazmat:
        return C.orange;
      case IncidentType.structural:
        return C.amber;
      case IncidentType.security:
        return C.cyan;
      case IncidentType.other:
        return C.violet;
    }
  }
}

extension DispatchStatusX on DispatchStatus {
  String get label {
    switch (this) {
      case DispatchStatus.pending:
        return 'PENDING';
      case DispatchStatus.confirmed:
        return 'CONFIRMED';
      case DispatchStatus.enroute:
        return 'EN ROUTE';
      case DispatchStatus.arrived:
        return 'ARRIVED';
      case DispatchStatus.completed:
        return 'COMPLETED';
      case DispatchStatus.cancelled:
        return 'CANCELLED';
    }
  }

  Color get color {
    switch (this) {
      case DispatchStatus.pending:
        return C.yellow;
      case DispatchStatus.confirmed:
        return C.cyan;
      case DispatchStatus.enroute:
        return C.orange;
      case DispatchStatus.arrived:
        return C.green;
      case DispatchStatus.completed:
        return C.teal;
      case DispatchStatus.cancelled:
        return C.mutedLt;
    }
  }
}

class EmergencyAlert {
  final String id;
  final IncidentType type;
  final AlertSeverity severity;
  final String title;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  DispatchStatus status;
  int estimatedArrival; // seconds
  List<String> assignedTeams;
  int affectedPeople;
  bool requiresEvacuation;

  EmergencyAlert({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.status,
    required this.estimatedArrival,
    required this.assignedTeams,
    required this.affectedPeople,
    required this.requiresEvacuation,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String get eta {
    if (estimatedArrival <= 0) return 'ON SCENE';
    if (estimatedArrival < 60) return '${estimatedArrival}s';
    return '${(estimatedArrival / 60).toStringAsFixed(1)}m';
  }
}

class ResponseTeam {
  final String id;
  final String name;
  final String specialization;
  ResponseTeamStatus status;
  final double latitude;
  final double longitude;
  final int staffCount;
  final List<String> equipment;
  final int distanceToIncident; // meters

  ResponseTeam({
    required this.id,
    required this.name,
    required this.specialization,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.staffCount,
    required this.equipment,
    required this.distanceToIncident,
  });
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
final rng = Random(789);

List<EmergencyAlert> buildAlerts() {
  final now = DateTime.now();
  return [
    EmergencyAlert(
      id: 'ALERT-001',
      type: IncidentType.fire,
      severity: AlertSeverity.critical,
      title: 'High-Rise Fire',
      description: 'Multi-floor fire detected on levels 15-18',
      location: 'Commercial Tower, Downtown',
      latitude: 40.7128,
      longitude: -74.0060,
      timestamp: now.subtract(const Duration(minutes: 8)),
      status: DispatchStatus.arrived,
      estimatedArrival: 0,
      assignedTeams: ['FD-001', 'FD-002', 'MED-001'],
      affectedPeople: 245,
      requiresEvacuation: true,
    ),
    EmergencyAlert(
      id: 'ALERT-002',
      type: IncidentType.medical,
      severity: AlertSeverity.high,
      title: 'Mass Casualty Incident',
      description: 'Multiple injuries from building collapse',
      location: 'Industrial Complex, East District',
      latitude: 40.7150,
      longitude: -74.0100,
      timestamp: now.subtract(const Duration(minutes: 12)),
      status: DispatchStatus.arrived,
      estimatedArrival: 0,
      assignedTeams: ['MED-001', 'MED-002', 'MED-003', 'FD-001'],
      affectedPeople: 38,
      requiresEvacuation: false,
    ),
    EmergencyAlert(
      id: 'ALERT-003',
      type: IncidentType.hazmat,
      severity: AlertSeverity.critical,
      title: 'Chemical Spill',
      description: 'Unknown toxic substance leaking in residential area',
      location: 'Storage Facility, North Gate',
      latitude: 40.7180,
      longitude: -74.0070,
      timestamp: now.subtract(const Duration(minutes: 5)),
      status: DispatchStatus.enroute,
      estimatedArrival: 320,
      assignedTeams: ['HM-001'],
      affectedPeople: 156,
      requiresEvacuation: true,
    ),
    EmergencyAlert(
      id: 'ALERT-004',
      type: IncidentType.accident,
      severity: AlertSeverity.medium,
      title: 'Multi-Vehicle Collision',
      description: '6 vehicles involved, highway blocked',
      location: 'Central Highway, Junction 5',
      latitude: 40.7160,
      longitude: -74.0080,
      timestamp: now.subtract(const Duration(minutes: 18)),
      status: DispatchStatus.completed,
      estimatedArrival: 0,
      assignedTeams: ['PDF-001', 'MED-001', 'TRAFFIC-001'],
      affectedPeople: 12,
      requiresEvacuation: false,
    ),
  ];
}

List<ResponseTeam> buildTeams() => [
  ResponseTeam(
    id: 'FD-001',
    name: 'Fire Brigade Alpha',
    specialization: 'Structural Fire',
    status: ResponseTeamStatus.onscene,
    latitude: 40.7128,
    longitude: -74.0060,
    staffCount: 12,
    equipment: ['Ladder Truck', 'Tanker', 'Rescue Unit'],
    distanceToIncident: 0,
  ),
  ResponseTeam(
    id: 'FD-002',
    name: 'Fire Brigade Bravo',
    specialization: 'Hazmat',
    status: ResponseTeamStatus.onscene,
    latitude: 40.7128,
    longitude: -74.0060,
    staffCount: 8,
    equipment: ['Chemical Unit', 'Decon Shower', 'Sensors'],
    distanceToIncident: 50,
  ),
  ResponseTeam(
    id: 'MED-001',
    name: 'Ambulance Team 1',
    specialization: 'Trauma',
    status: ResponseTeamStatus.onscene,
    latitude: 40.7150,
    longitude: -74.0100,
    staffCount: 4,
    equipment: ['Defibrillator', 'Ventilator', 'Stretcher'],
    distanceToIncident: 0,
  ),
  ResponseTeam(
    id: 'MED-002',
    name: 'Ambulance Team 2',
    specialization: 'Intensive Care',
    status: ResponseTeamStatus.onscene,
    latitude: 40.7150,
    longitude: -74.0100,
    staffCount: 4,
    equipment: ['ICU Kit', 'Monitoring System', 'Oxygen'],
    distanceToIncident: 80,
  ),
  ResponseTeam(
    id: 'HM-001',
    name: 'Hazmat Specialist Team',
    specialization: 'Chemical/Biological',
    status: ResponseTeamStatus.enroute,
    latitude: 40.7140,
    longitude: -74.0090,
    staffCount: 6,
    equipment: ['Protective Suits', 'Sensor Array', 'Containment Kit'],
    distanceToIncident: 2400,
  ),
  ResponseTeam(
    id: 'PDF-001',
    name: 'Police Dispatch',
    specialization: 'Traffic Control',
    status: ResponseTeamStatus.idle,
    latitude: 40.7120,
    longitude: -74.0050,
    staffCount: 8,
    equipment: ['Traffic Cones', 'Barriers', 'Lights'],
    distanceToIncident: 3200,
  ),
];
