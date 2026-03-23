/// Operational states for actuators/control devices
enum ActuatorState {
  /// Actuator is enabled and operational
  enabled,

  /// Actuator is disabled/inactive
  disabled,

  /// Actuator is on standby (ready but not active)
  standby,

  /// Actuator has encountered an error
  error,

  /// Actuator is being maintained
  maintenance,

  /// Actuator is in initialization/startup
  initializing,
}

/// Extension for ActuatorState utilities
extension ActuatorStateExtension on ActuatorState {
  /// Get human-readable state name
  String get displayName {
    const nameMap = {
      ActuatorState.enabled: 'Enabled',
      ActuatorState.disabled: 'Disabled',
      ActuatorState.standby: 'Standby',
      ActuatorState.error: 'Error',
      ActuatorState.maintenance: 'Under Maintenance',
      ActuatorState.initializing: 'Initializing',
    };
    return nameMap[this] ?? 'Unknown';
  }

  /// Get color code for UI visualization
  String get colorCode {
    switch (this) {
      case ActuatorState.enabled:
        return '#00D4FF'; // Cyan - Active
      case ActuatorState.disabled:
        return '#808080'; // Gray - Inactive
      case ActuatorState.standby:
        return '#FFD700'; // Gold - Ready
      case ActuatorState.error:
        return '#FF6B6B'; // Red - Error
      case ActuatorState.maintenance:
        return '#9D8DFF'; // Purple - Service
      case ActuatorState.initializing:
        return '#FF8A00'; // Orange - Loading
    }
  }

  /// Check if actuator can receive commands
  bool get isCommandable =>
      this == ActuatorState.enabled || this == ActuatorState.standby;

  /// Check if actuator is operational
  bool get isOperational => this == ActuatorState.enabled;

  /// Check if actuator has issues
  bool get hasIssues =>
      this == ActuatorState.error || this == ActuatorState.maintenance;
}
