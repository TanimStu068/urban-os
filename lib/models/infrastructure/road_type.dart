/// Road classification types in the urban infrastructure
enum RoadType {
  /// High-speed multi-lane roads (limited access)
  highway,

  /// Major roads connecting districts (4-8 lanes)
  arterial,

  /// Secondary roads collecting traffic (2-4 lanes)
  collector,

  /// Local residential/neighborhood streets (1-2 lanes)
  local,

  /// Suburban roads
  suburban,

  /// Rural roads
  rural,

  /// Pedestrian paths/walkways
  pedestrian,

  /// Bicycle lanes
  bicycle,

  /// Mixed-use roads (vehicles + pedestrians)
  mixed,
}

/// Extension for RoadType utilities
extension RoadTypeExtension on RoadType {
  /// Get human-readable road type name
  String get displayName {
    const nameMap = {
      RoadType.highway: 'Highway',
      RoadType.arterial: 'Arterial Road',
      RoadType.collector: 'Collector Road',
      RoadType.local: 'Local Street',
      RoadType.suburban: 'Suburban Road',
      RoadType.rural: 'Rural Road',
      RoadType.pedestrian: 'Pedestrian Path',
      RoadType.bicycle: 'Bicycle Lane',
      RoadType.mixed: 'Mixed-Use Road',
    };
    return nameMap[this] ?? 'Unknown';
  }

  /// Get typical speed limit in km/h
  int get typicalSpeedLimit {
    switch (this) {
      case RoadType.highway:
        return 120;
      case RoadType.arterial:
        return 80;
      case RoadType.collector:
        return 60;
      case RoadType.local:
        return 40;
      case RoadType.suburban:
        return 50;
      case RoadType.rural:
        return 60;
      case RoadType.pedestrian:
        return 5;
      case RoadType.bicycle:
        return 20;
      case RoadType.mixed:
        return 30;
    }
  }

  /// Get typical lane count
  int get typicalLaneCount {
    switch (this) {
      case RoadType.highway:
        return 6;
      case RoadType.arterial:
        return 4;
      case RoadType.collector:
        return 2;
      case RoadType.local:
        return 2;
      case RoadType.suburban:
        return 2;
      case RoadType.rural:
        return 2;
      case RoadType.pedestrian:
        return 1;
      case RoadType.bicycle:
        return 1;
      case RoadType.mixed:
        return 2;
    }
  }

  /// Check if road is major traffic corridor
  bool get isMajorCorridor =>
      this == RoadType.highway || this == RoadType.arterial;

  /// Check if road allows vehicle traffic
  bool get allowsVehicles =>
      this != RoadType.pedestrian && this != RoadType.bicycle;

  /// Check if road allows pedestrians
  bool get allowsPedestrians =>
      this == RoadType.pedestrian ||
      this == RoadType.local ||
      this == RoadType.mixed;

  /// Check if road allows bicycles
  bool get allowsBicycles =>
      this == RoadType.bicycle ||
      this == RoadType.local ||
      this == RoadType.mixed;
}
