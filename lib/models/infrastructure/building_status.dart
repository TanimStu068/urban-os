/// Operational status of a building
enum BuildingStatus {
  /// Building is operational and all systems functioning
  operational,

  /// Building is undergoing maintenance
  maintenance,

  /// Building has a critical emergency or safety issue
  emergency,

  /// Building is offline/closed to public
  offline,

  /// Building is under construction
  construction,

  /// Building has been evacuated
  evacuated,
}

/// Extension for BuildingStatus utilities
extension BuildingStatusExtension on BuildingStatus {
  /// Get human-readable status name
  String get displayName {
    const nameMap = {
      BuildingStatus.operational: 'Operational',
      BuildingStatus.maintenance: 'Under Maintenance',
      BuildingStatus.emergency: 'Emergency',
      BuildingStatus.offline: 'Offline',
      BuildingStatus.construction: 'Under Construction',
      BuildingStatus.evacuated: 'Evacuated',
    };
    return nameMap[this] ?? 'Unknown';
  }

  /// Get color code for UI
  String get colorCode {
    switch (this) {
      case BuildingStatus.operational:
        return '#00D084'; // Green
      case BuildingStatus.maintenance:
        return '#9D8DFF'; // Purple
      case BuildingStatus.emergency:
        return '#FF6B6B'; // Red
      case BuildingStatus.offline:
        return '#808080'; // Gray
      case BuildingStatus.construction:
        return '#FFD700'; // Gold
      case BuildingStatus.evacuated:
        return '#FF6B6B'; // Red
    }
  }

  /// Check if building allows public access
  bool get isAccessible => this == BuildingStatus.operational;

  /// Check if building has critical issues
  bool get hasCriticalIssue =>
      this == BuildingStatus.emergency || this == BuildingStatus.evacuated;
}
