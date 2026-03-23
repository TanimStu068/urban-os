/// Operational status of a geographic zone
enum ZoneStatus {
  /// Zone is operating normally within safe parameters
  normal,

  /// Zone has issues requiring attention but not critical
  warning,

  /// Zone is in critical condition requiring immediate action
  critical,

  /// Zone is restricted/closed to public
  restricted,

  /// Zone is under emergency condition
  emergency,
}

/// Extension for ZoneStatus utilities
extension ZoneStatusExtension on ZoneStatus {
  /// Get human-readable status name
  String get displayName {
    const nameMap = {
      ZoneStatus.normal: 'Normal',
      ZoneStatus.warning: 'Warning',
      ZoneStatus.critical: 'Critical',
      ZoneStatus.restricted: 'Restricted',
      ZoneStatus.emergency: 'Emergency',
    };
    return nameMap[this] ?? 'Unknown';
  }

  /// Get color code for UI
  String get colorCode {
    switch (this) {
      case ZoneStatus.normal:
        return '#00D084'; // Green
      case ZoneStatus.warning:
        return '#FFD700'; // Gold
      case ZoneStatus.critical:
        return '#FF6B6B'; // Red
      case ZoneStatus.restricted:
        return '#808080'; // Gray
      case ZoneStatus.emergency:
        return '#FF0000'; // Bright Red
    }
  }

  /// Check if zone is safe for public
  bool get isSafeForPublic => this == ZoneStatus.normal;

  /// Check if zone is in critical condition
  bool get isCritical =>
      this == ZoneStatus.critical || this == ZoneStatus.emergency;
}
