/// Operational states for IoT sensors
enum SensorState {
  /// Sensor is online and operational
  online,

  /// Sensor is offline/unreachable
  offline,

  /// Sensor has detected an error condition
  error,

  /// Sensor is being calibrated
  calibrating,

  /// Sensor is in maintenance mode
  maintenance,
}

/// Extension for SensorState utilities
extension SensorStateExtension on SensorState {
  /// Get human-readable state name
  String get displayName {
    const nameMap = {
      SensorState.online: 'Online',
      SensorState.offline: 'Offline',
      SensorState.error: 'Error',
      SensorState.calibrating: 'Calibrating',
      SensorState.maintenance: 'Under Maintenance',
    };
    return nameMap[this] ?? 'Unknown';
  }

  /// Get color code for UI (from colors file)
  String get colorCode {
    switch (this) {
      case SensorState.online:
        return '#00D4FF'; // Cyan
      case SensorState.offline:
        return '#FF6B6B'; // Red
      case SensorState.error:
        return '#FF8A00'; // Orange
      case SensorState.calibrating:
        return '#FFD700'; // Gold
      case SensorState.maintenance:
        return '#9D8DFF'; // Purple
    }
  }

  /// Check if sensor is operational
  bool get isOperational => this == SensorState.online;

  /// Check if sensor has issues
  bool get hasIssues =>
      this == SensorState.offline ||
      this == SensorState.error ||
      this == SensorState.maintenance;
}
