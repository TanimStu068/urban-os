/// Geographic zone classification within a district
enum ZoneType {
  /// Residential housing zone
  residential,

  /// Industrial manufacturing zone
  industrial,

  /// Commercial business zone
  commercial,

  /// Green space/park zone
  green,

  /// High-risk hazardous zone
  highRisk,

  /// Flood-prone area
  floodProne,

  /// High-density urban zone
  highDensity,

  /// Low-density suburban zone
  lowDensity,

  /// Mixed-use development zone
  mixedUse,

  /// Protected/conservation zone
  protected,

  /// Entertainment/nightlife zone
  entertainment,

  /// Agricultural zone
  agricultural,

  /// Transportation/logistics zone
  transportation,
}

/// Extension for ZoneType utilities
extension ZoneTypeExtension on ZoneType {
  /// Get human-readable zone name
  String get displayName {
    const nameMap = {
      ZoneType.residential: 'Residential',
      ZoneType.industrial: 'Industrial',
      ZoneType.commercial: 'Commercial',
      ZoneType.green: 'Green Space',
      ZoneType.highRisk: 'High-Risk',
      ZoneType.floodProne: 'Flood-Prone',
      ZoneType.highDensity: 'High-Density',
      ZoneType.lowDensity: 'Low-Density',
      ZoneType.mixedUse: 'Mixed-Use',
      ZoneType.protected: 'Protected',
      ZoneType.entertainment: 'Entertainment',
      ZoneType.agricultural: 'Agricultural',
      ZoneType.transportation: 'Transportation',
    };
    return nameMap[this] ?? 'Zone';
  }

  /// Get color code for UI
  String get colorCode {
    switch (this) {
      case ZoneType.residential:
        return '#87CEEB';
      case ZoneType.industrial:
        return '#A9A9A9';
      case ZoneType.commercial:
        return '#FFD700';
      case ZoneType.green:
        return '#00D084';
      case ZoneType.highRisk:
        return '#FF6B6B';
      case ZoneType.floodProne:
        return '#0066FF';
      case ZoneType.highDensity:
        return '#9D4EDD';
      case ZoneType.lowDensity:
        return '#90EE90';
      case ZoneType.mixedUse:
        return '#9D8DFF';
      case ZoneType.protected:
        return '#228B22';
      case ZoneType.entertainment:
        return '#FF1493';
      case ZoneType.agricultural:
        return '#9ACD32';
      case ZoneType.transportation:
        return '#FF8C00';
    }
  }

  /// Check if zone requires special monitoring
  bool get requiresSpecialMonitoring =>
      this == ZoneType.highRisk ||
      this == ZoneType.floodProne ||
      this == ZoneType.protected;

  /// Get monitoring intensity (1-5)
  int get monitoringIntensity {
    switch (this) {
      case ZoneType.highRisk:
        return 5;
      case ZoneType.floodProne:
        return 4;
      case ZoneType.highDensity:
        return 4;
      case ZoneType.protected:
        return 4;
      case ZoneType.industrial:
        return 3;
      case ZoneType.commercial:
        return 3;
      case ZoneType.entertainment:
        return 3;
      default:
        return 2;
    }
  }
}
