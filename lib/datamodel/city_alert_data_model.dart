import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/models/logs/alert_log.dart';

typedef C = AppColors;

enum UISeverity { critical, warning, info, resolved }

extension UISeverityX on UISeverity {
  Color get color {
    switch (this) {
      case UISeverity.critical:
        return C.red;
      case UISeverity.warning:
        return C.amber;
      case UISeverity.info:
        return C.cyan;
      case UISeverity.resolved:
        return C.green;
    }
  }

  String get label {
    switch (this) {
      case UISeverity.critical:
        return 'CRITICAL';
      case UISeverity.warning:
        return 'WARNING';
      case UISeverity.info:
        return 'INFO';
      case UISeverity.resolved:
        return 'RESOLVED';
    }
  }

  IconData get icon {
    switch (this) {
      case UISeverity.critical:
        return Icons.crisis_alert_rounded;
      case UISeverity.warning:
        return Icons.warning_amber_rounded;
      case UISeverity.info:
        return Icons.info_outline_rounded;
      case UISeverity.resolved:
        return Icons.check_circle_outline_rounded;
    }
  }
}

// Convert AlertLog severity to UI severity
UISeverity mapAlertSeverity(RulePriority priority, bool isActive) {
  if (!isActive) return UISeverity.resolved;
  switch (priority) {
    case RulePriority.critical:
      return UISeverity.critical;
    case RulePriority.high:
      return UISeverity.warning;
    case RulePriority.medium:
    case RulePriority.low:
      return UISeverity.info;
  }
}

// ─────────────────────────────────────────
//  UI STATE WRAPPER FOR ALERT
// ─────────────────────────────────────────
class UIAlert {
  final AlertLog alert;
  bool isExpanded;

  UIAlert({required this.alert, required this.isExpanded});
}

final samples = [
  (
    'Sensor Anomaly Detected',
    'Sensor reading outside normal range.',
    RulePriority.high,
  ),
  (
    'Traffic Signal Failure',
    'Traffic light offline at intersection 12B.',
    RulePriority.critical,
  ),
  (
    'High Humidity Warning',
    'Humidity exceeds 90% threshold in sector 6.',
    RulePriority.medium,
  ),
  (
    'Power Fluctuation',
    'Minor power fluctuation detected on line 3.',
    RulePriority.high,
  ),
];
