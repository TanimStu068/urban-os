import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/screens/automation/automation_rule_list_screen.dart';
import 'package:urban_os/screens/energy/energy_dashboard_screen.dart';
import 'package:urban_os/screens/enviroment/environment_dashboard_screen.dart';
import 'package:urban_os/screens/safety/emergency_control_system.dart';
import 'package:urban_os/screens/sensor/sensor_list_screen.dart';
import 'package:urban_os/screens/traffic/traffic_dashboard_screen.dart';

typedef C = AppColors;

extension DistrictDisplay on DistrictModel {
  Color get displayColor {
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

  IconData get displayIcon {
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

  /// Short 3-letter label for map overlay
  String get shortLabel {
    final n = type.name.toUpperCase();
    return n.length >= 3 ? n.substring(0, 3) : n;
  }

  /// Health 0..100 drawn from safetyScore or metrics
  double get healthPercent => metrics.overallHealthScore.clamp(0, 100);

  /// Active alerts count from metrics
  int get alertCount => metrics.activeIncidents;
}

extension AlertDisplay on AlertLog {
  Color get displayColor {
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

  IconData get displayIcon {
    if (resourceType == 'sensor') return Icons.sensors_rounded;
    if (title.toLowerCase().contains('fire')) {
      return Icons.local_fire_department_rounded;
    }
    if (title.toLowerCase().contains('power')) return Icons.bolt_rounded;
    if (title.toLowerCase().contains('traffic')) return Icons.traffic_rounded;
    if (title.toLowerCase().contains('water')) return Icons.water_drop_rounded;
    return Icons.warning_amber_rounded;
  }

  String get timeLabel {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return '${diff.inSeconds}s ago';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

  String get severityLabel {
    switch (severity.name.toLowerCase()) {
      case 'critical':
        return 'CRITICAL';
      case 'high':
        return 'WARNING';
      default:
        return 'INFO';
    }
  }
}

extension SensorDisplay on SensorModel {
  String get latestValueLabel {
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
      default:
        return v.toStringAsFixed(1);
    }
  }
}

Color ruleColor(AutomationRule rule, int fallbackIndex) {
  switch (rule.priority.name.toLowerCase()) {
    case 'critical':
      return C.red;
    case 'high':
      return C.amber;
    case 'medium':
      return C.cyan;
    default:
      final colors = [C.teal, C.cyan, C.amber, C.violet, C.green];
      return colors[fallbackIndex % colors.length];
  }
}

final actions = [
  (
    Icons.traffic_rounded,
    'Traffic\nControl',
    C.cyan,
    const TrafficDashboardScreen(),
  ),
  (Icons.bolt_rounded, 'Energy\nGrid', C.amber, const EnergyDashboardScreen()),
  (
    Icons.air_rounded,
    'Air\nFilters',
    C.teal,
    const EnvironmentDashboardScreen(),
  ),
  (
    Icons.warning_rounded,
    'Emergency\nMode',
    C.red,
    const EmergencyControlSystemScreen(),
  ),
  (Icons.sensors_rounded, 'All\nSensors', C.violet, const SensorListScreen()),
  (
    Icons.auto_fix_high_rounded,
    'Automation\nRules',
    C.green,
    const AutomationRuleListScreen(),
  ),
];
