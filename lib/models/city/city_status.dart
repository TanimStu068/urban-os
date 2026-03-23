/// City operational status levels
enum CityStatus {
  /// All systems nominal, within normal operating parameters
  normal,

  /// System is functioning but has encountered non-critical issues requiring attention
  warning,

  /// System is experiencing critical issues that may impact operations
  critical,

  /// System is offline or experiencing catastrophic failure
  offline,
}

/// Extension for CityStatus utilities
extension CityStatusExtension on CityStatus {
  /// Get human-readable status name
  String get displayName {
    const nameMap = {
      CityStatus.normal: 'Normal',
      CityStatus.warning: 'Warning',
      CityStatus.critical: 'Critical',
      CityStatus.offline: 'Offline',
    };
    return nameMap[this] ?? 'Unknown';
  }

  /// Get color code for UI visualization
  String get colorCode {
    switch (this) {
      case CityStatus.normal:
        return '#00D4FF'; // Cyan - Healthy
      case CityStatus.warning:
        return '#FFD700'; // Gold - Caution
      case CityStatus.critical:
        return '#FF6B6B'; // Red - Danger
      case CityStatus.offline:
        return '#808080'; // Gray - Offline
    }
  }

  /// Check if city is operational
  bool get isOperational => this != CityStatus.offline;

  /// Check if city has issues
  bool get hasIssues =>
      this == CityStatus.warning || this == CityStatus.critical;
}
