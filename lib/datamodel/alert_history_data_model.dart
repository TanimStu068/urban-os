import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

// ─────────────────────────────────────────
//  ENUMS & DATA MODELS
// ─────────────────────────────────────────
enum AlertSeverity { info, warning, critical, emergency }

enum AlertType {
  sensor,
  system,
  traffic,
  energy,
  environment,
  safety,
  automation,
}

enum AlertStatus { active, acknowledged, resolved, dismissed }

extension AlertSeverityX on AlertSeverity {
  String get label {
    switch (this) {
      case AlertSeverity.info:
        return 'INFO';
      case AlertSeverity.warning:
        return 'WARNING';
      case AlertSeverity.critical:
        return 'CRITICAL';
      case AlertSeverity.emergency:
        return 'EMERGENCY';
    }
  }

  Color get color {
    switch (this) {
      case AlertSeverity.info:
        return C.cyan;
      case AlertSeverity.warning:
        return C.amber;
      case AlertSeverity.critical:
        return C.orange;
      case AlertSeverity.emergency:
        return C.red;
    }
  }

  IconData get icon {
    switch (this) {
      case AlertSeverity.info:
        return Icons.info_rounded;
      case AlertSeverity.warning:
        return Icons.warning_rounded;
      case AlertSeverity.critical:
        return Icons.error_rounded;
      case AlertSeverity.emergency:
        return Icons.emergency_rounded;
    }
  }
}

extension AlertTypeX on AlertType {
  String get label {
    switch (this) {
      case AlertType.sensor:
        return 'SENSOR';
      case AlertType.system:
        return 'SYSTEM';
      case AlertType.traffic:
        return 'TRAFFIC';
      case AlertType.energy:
        return 'ENERGY';
      case AlertType.environment:
        return 'ENVIRONMENT';
      case AlertType.safety:
        return 'SAFETY';
      case AlertType.automation:
        return 'AUTOMATION';
    }
  }

  IconData get icon {
    switch (this) {
      case AlertType.sensor:
        return Icons.sensors_rounded;
      case AlertType.system:
        return Icons.settings_rounded;
      case AlertType.traffic:
        return Icons.directions_car_rounded;
      case AlertType.energy:
        return Icons.flash_on_rounded;
      case AlertType.environment:
        return Icons.eco_rounded;
      case AlertType.safety:
        return Icons.security_rounded;
      case AlertType.automation:
        return Icons.settings_suggest_rounded;
    }
  }

  Color get color {
    switch (this) {
      case AlertType.sensor:
        return C.teal;
      case AlertType.system:
        return C.violet;
      case AlertType.traffic:
        return C.orange;
      case AlertType.energy:
        return C.yellow;
      case AlertType.environment:
        return C.green;
      case AlertType.safety:
        return C.red;
      case AlertType.automation:
        return C.lime;
    }
  }
}

class AlertLog {
  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final AlertType type;
  final String sourceId;
  final String sourceName;
  final DateTime timestamp;
  AlertStatus status;
  final String? actionTaken;
  final DateTime? resolvedAt;
  final int affectedSystems;

  AlertLog({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.type,
    required this.sourceId,
    required this.sourceName,
    required this.timestamp,
    this.status = AlertStatus.active,
    this.actionTaken,
    this.resolvedAt,
    this.affectedSystems = 1,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  bool get isActive => status == AlertStatus.active;
  bool get isAcknowledged => status == AlertStatus.acknowledged;
  bool get isResolved => status == AlertStatus.resolved;
}

class AlertStatistics {
  final int totalAlerts;
  final int activeAlerts;
  final int criticalAlerts;
  final int resolvedToday;
  final Map<AlertSeverity, int> bySeverity;
  final Map<AlertType, int> byType;

  AlertStatistics({
    required this.totalAlerts,
    required this.activeAlerts,
    required this.criticalAlerts,
    required this.resolvedToday,
    required this.bySeverity,
    required this.byType,
  });
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
final rng = Random(77);

List<AlertLog> buildAlertHistory() {
  final now = DateTime.now();
  final alerts = <AlertLog>[];

  const titles = [
    'High Traffic Congestion Detected',
    'Air Quality Index Exceeded Safe Limit',
    'Power Consumption Peak Alert',
    'Sensor Communication Loss',
    'Unusual Crowd Density Detected',
    'Water Pipeline Pressure Drop',
    'Traffic Light Malfunction',
    'Automation Rule Conflict',
    'Temperature Threshold Breached',
    'Emergency Vehicle Route Blocked',
    'Grid Load Critical',
    'Noise Level Violation Detected',
  ];

  const descriptions = [
    'Vehicle density on Main Street exceeds threshold by 35%',
    'PM2.5 levels reached 180 µg/m³ in Industrial Zone',
    'Peak demand approaching grid capacity limit',
    'Sensor SEN-0447 offline for 15 minutes',
    'Crowd density in commercial district at 4.2 persons/m²',
    'Pressure dropped to 2.1 bar in northern pipeline segment',
    'Traffic light TL-0823 not responding to commands',
    'Lane control and traffic light rules conflict on Route 5',
    'Temperature rose to 42.3°C, above critical threshold',
    'Fire truck route to emergency blocked by congestion',
    'Grid frequency unstable, 49.2 Hz detected',
    'Noise level in residential zone: 82 dB, exceeds 70 dB limit',
  ];

  for (int i = 0; i < 25; i++) {
    final type = AlertType.values[rng.nextInt(AlertType.values.length)];
    final severity = AlertSeverity
        .values[min(rng.nextInt(4), AlertSeverity.values.length - 1)];
    final status = AlertStatus.values[rng.nextInt(4)];

    alerts.add(
      AlertLog(
        id: 'ALT-${DateTime.now().millisecondsSinceEpoch}-$i',
        title: titles[rng.nextInt(titles.length)],
        description: descriptions[rng.nextInt(descriptions.length)],
        severity: severity,
        type: type,
        sourceId: 'SRC-${rng.nextInt(1000)}',
        sourceName: getSourceName(type),
        timestamp: now.subtract(
          Duration(minutes: rng.nextInt(480), seconds: rng.nextInt(60)),
        ),
        status: status,
        actionTaken: status != AlertStatus.active
            ? 'Manual intervention / System auto-corrected'
            : null,
        resolvedAt: status == AlertStatus.resolved
            ? now.subtract(Duration(minutes: rng.nextInt(180)))
            : null,
        affectedSystems: rng.nextInt(5) + 1,
      ),
    );
  }

  alerts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return alerts;
}

String getSourceName(AlertType type) {
  const sources = {
    AlertType.sensor: [
      'Temperature Sensor Zone-A',
      'Traffic Flow Sensor',
      'Air Quality Sensor',
      'Pressure Sensor Pipeline-N',
      'Humidity Sensor Zone-B',
    ],
    AlertType.system: [
      'HVAC System',
      'Power Distribution',
      'Water Management',
      'Surveillance System',
      'Communication Hub',
    ],
    AlertType.traffic: [
      'Traffic Light Controller',
      'Road Sensor Network',
      'Vehicle Detection',
      'Speed Enforcement',
      'Emergency Route',
    ],
    AlertType.energy: [
      'Power Grid Monitor',
      'Load Balancer',
      'Solar Farm',
      'Battery Storage',
      'Distribution Node',
    ],
    AlertType.environment: [
      'AQI Monitor Central',
      'Weather Station',
      'Noise Detector',
      'Pollution Sensor',
      'Emission Monitor',
    ],
    AlertType.safety: [
      'Fire Detection System',
      'CCTV Network',
      'Emergency Services',
      'Evacuation System',
      'Security Control',
    ],
    AlertType.automation: [
      'Rule Engine Core',
      'Conflict Resolver',
      'Action Executor',
      'Schedule Manager',
      'Integration Layer',
    ],
  };

  final typeSources = sources[type] ?? ['Unknown Source'];
  return typeSources[rng.nextInt(typeSources.length)];
}

AlertStatistics buildStatistics(List<AlertLog> alerts) {
  final bySeverity = <AlertSeverity, int>{};
  final byType = <AlertType, int>{};

  for (final alert in alerts) {
    bySeverity[alert.severity] = (bySeverity[alert.severity] ?? 0) + 1;
    byType[alert.type] = (byType[alert.type] ?? 0) + 1;
  }

  final activeCount = alerts.where((a) => a.isActive).length;
  final criticalCount = alerts
      .where(
        (a) =>
            a.severity == AlertSeverity.critical ||
            a.severity == AlertSeverity.emergency,
      )
      .length;
  final resolvedToday = alerts
      .where(
        (a) =>
            a.isResolved &&
            a.resolvedAt != null &&
            a.resolvedAt!.day == DateTime.now().day,
      )
      .length;

  return AlertStatistics(
    totalAlerts: alerts.length,
    activeAlerts: activeCount,
    criticalAlerts: criticalCount,
    resolvedToday: resolvedToday,
    bySeverity: bySeverity,
    byType: byType,
  );
}
