/// Operational status of a road segment
enum RoadStatus {
  /// Road is open and traffic is flowing normally
  open,

  /// Road is experiencing heavy traffic congestion
  congested,

  /// Road is closed to traffic
  closed,

  /// There is an accident on the road
  accident,

  /// Road is under maintenance or repair
  maintenance,

  /// Road is flooded or unusable due to weather
  flooding,

  /// Road has debris or obstacles
  obstruction,

  /// Road is under construction/excavation
  construction,
}

/// Extension for RoadStatus utilities
extension RoadStatusExtension on RoadStatus {
  /// Get human-readable status name
  String get displayName {
    const nameMap = {
      RoadStatus.open: 'Open',
      RoadStatus.congested: 'Congested',
      RoadStatus.closed: 'Closed',
      RoadStatus.accident: 'Accident',
      RoadStatus.maintenance: 'Maintenance',
      RoadStatus.flooding: 'Flooded',
      RoadStatus.obstruction: 'Obstruction',
      RoadStatus.construction: 'Under Construction',
    };
    return nameMap[this] ?? 'Unknown';
  }

  /// Get color code for UI visualization
  String get colorCode {
    switch (this) {
      case RoadStatus.open:
        return '#00D084'; // Green - Clear
      case RoadStatus.congested:
        return '#FFD700'; // Gold - Caution
      case RoadStatus.closed:
        return '#FF6B6B'; // Red - Danger
      case RoadStatus.accident:
        return '#FF6B6B'; // Red - Emergency
      case RoadStatus.maintenance:
        return '#9D8DFF'; // Purple - Service
      case RoadStatus.flooding:
        return '#0066FF'; // Blue - Water
      case RoadStatus.obstruction:
        return '#FF8A00'; // Orange - Warning
      case RoadStatus.construction:
        return '#A9A9A9'; // Gray - Under work
    }
  }

  /// Check if road is passable for vehicles
  bool get isPassable =>
      this == RoadStatus.open || (this == RoadStatus.congested);

  /// Check if road is completely closed
  bool get isBlocked =>
      this == RoadStatus.closed ||
      this == RoadStatus.accident ||
      this == RoadStatus.flooding;

  /// Check if road is restricted/limited
  bool get isRestricted =>
      this == RoadStatus.maintenance ||
      this == RoadStatus.construction ||
      this == RoadStatus.obstruction;

  /// Get recommended action for drivers
  String get recommendedAction {
    switch (this) {
      case RoadStatus.open:
        return 'No action needed - road is clear';
      case RoadStatus.congested:
        return 'Consider alternative routes due to traffic';
      case RoadStatus.closed:
        return 'Seek alternate routes - road is closed';
      case RoadStatus.accident:
        return 'Emergency - avoid road, take alternate route';
      case RoadStatus.maintenance:
        return 'Road is under maintenance - use caution';
      case RoadStatus.flooding:
        return 'Road is flooded - do not attempt to cross';
      case RoadStatus.obstruction:
        return 'Road has obstacles - proceed with caution';
      case RoadStatus.construction:
        return 'Road construction in progress - expect delays';
    }
  }
}
