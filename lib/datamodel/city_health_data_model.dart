import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';

typedef C = AppColors;

extension DistrictHealth on DistrictModel {
  double get healthScore => metrics.overallHealthScore.clamp(0, 100);
  int get incidentCount => metrics.activeIncidents;
  Color get healthColor {
    final h = healthScore;
    if (h >= 80) return C.teal;
    if (h >= 60) return C.amber;
    return C.red;
  }

  Color get typeColor {
    switch (type.name.toLowerCase()) {
      case 'residential':
        return C.teal;
      case 'commercial':
        return C.cyan;
      case 'industrial':
        return C.orange;
      case 'educational':
        return C.green;
      case 'medical':
        return C.violet;
      case 'transport':
        return C.amber;
      case 'green':
        return C.green;
      case 'government':
        return C.cyan;
      default:
        return C.mutedLt;
    }
  }

  IconData get typeIcon {
    switch (type.name.toLowerCase()) {
      case 'residential':
        return Icons.home_rounded;
      case 'commercial':
        return Icons.storefront_rounded;
      case 'industrial':
        return Icons.factory_rounded;
      case 'educational':
        return Icons.school_rounded;
      case 'medical':
        return Icons.local_hospital_rounded;
      case 'transport':
        return Icons.traffic_rounded;
      case 'green':
        return Icons.park_rounded;
      case 'government':
        return Icons.account_balance_rounded;
      default:
        return Icons.location_city_rounded;
    }
  }
}

extension AlertSeverityDisplay on AlertLog {
  Color get sColor {
    switch (severity.name.toLowerCase()) {
      case 'critical':
        return C.red;
      case 'high':
        return C.orange;
      case 'medium':
        return C.amber;
      default:
        return C.cyan;
    }
  }

  String get ageLabel {
    final d = DateTime.now().difference(timestamp);
    if (d.inMinutes < 1) return '${d.inSeconds}s ago';
    if (d.inHours < 1) return '${d.inMinutes}m ago';
    if (d.inDays < 1) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }

  bool get isActive => this.isActive;
}

extension SensorVal on SensorModel {
  double get val => latestReading?.value ?? 0;
  String get valLabel {
    final v = latestReading?.value;
    if (v == null) return '—';
    switch (type) {
      case SensorType.powerConsumption:
        return '${v.toStringAsFixed(1)} kW';
      case SensorType.airQuality:
        return v.toStringAsFixed(0);
      case SensorType.waterFlow:
        return '${v.toStringAsFixed(1)} L/s';
      case SensorType.congestionLevel:
        return '${v.toStringAsFixed(0)}%';
      case SensorType.temperature:
        return '${v.toStringAsFixed(1)}°C';
      case SensorType.humidity:
        return '${v.toStringAsFixed(0)}%';
      case SensorType.noiseLevel:
        return '${v.toStringAsFixed(0)} dB';
      case SensorType.fireAlarm:
        return v == 1 ? 'ALARM' : 'OK';
      default:
        return v.toStringAsFixed(1);
    }
  }

  Color get statusColor {
    switch (type) {
      case SensorType.fireAlarm:
        return (latestReading?.value ?? 0) == 1 ? C.red : C.teal;
      case SensorType.powerConsumption:
        return (latestReading?.value ?? 0) > 400 ? C.red : C.amber;
      case SensorType.airQuality:
        final v = latestReading?.value ?? 0;
        return v < 100
            ? C.teal
            : v < 150
            ? C.amber
            : C.red;
      default:
        return C.cyan;
    }
  }
}
