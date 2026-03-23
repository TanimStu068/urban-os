/// Types of urban districts based on primary function
enum DistrictType {
  /// Residential areas (apartments, houses, neighborhoods)
  residential,

  /// Commercial areas (shops, offices, markets)
  commercial,

  /// Industrial zones (factories, warehouses, plants)
  industrial,

  /// Educational areas (schools, universities, research centers)
  educational,

  /// Medical/Healthcare (hospitals, clinics, health centers)
  medical,

  /// Transportation hubs (airports, train stations, bus terminals)
  transportHub,

  /// Green spaces (parks, forests, recreational areas)
  greenZone,

  /// Government areas (government buildings, civic centers)
  government,

  /// Mixed-use areas (blend of residential, commercial, etc)
  mixedUse,

  /// Agricultural/Rural areas (farms, agricultural land)
  agricultural,

  /// Entertainment/Recreation (stadiums, theaters, cultural centers)
  entertainment,

  /// Military or restricted areas
  military,

  /// Special economic zones
  economicZone,
}

/// Extension for DistrictType utilities
extension DistrictTypeExtension on DistrictType {
  /// Get human-readable district type name
  String get displayName {
    const nameMap = {
      DistrictType.residential: 'Residential',
      DistrictType.commercial: 'Commercial',
      DistrictType.industrial: 'Industrial',
      DistrictType.educational: 'Educational',
      DistrictType.medical: 'Medical',
      DistrictType.transportHub: 'Transport Hub',
      DistrictType.greenZone: 'Green Zone',
      DistrictType.government: 'Government',
      DistrictType.mixedUse: 'Mixed-Use',
      DistrictType.agricultural: 'Agricultural',
      DistrictType.entertainment: 'Entertainment',
      DistrictType.military: 'Military',
      DistrictType.economicZone: 'Economic Zone',
    };
    return nameMap[this] ?? 'Unknown';
  }

  /// Get color code for UI visualization
  String get colorCode {
    switch (this) {
      case DistrictType.residential:
        return '#87CEEB'; // Sky blue
      case DistrictType.commercial:
        return '#FFD700'; // Gold
      case DistrictType.industrial:
        return '#A9A9A9'; // Gray
      case DistrictType.educational:
        return '#B0E0E6'; // Powder blue
      case DistrictType.medical:
        return '#FF6B6B'; // Red
      case DistrictType.transportHub:
        return '#FFA500'; // Orange
      case DistrictType.greenZone:
        return '#00D084'; // Green
      case DistrictType.government:
        return '#191970'; // Midnight blue
      case DistrictType.mixedUse:
        return '#9D4EDD'; // Purple
      case DistrictType.agricultural:
        return '#90EE90'; // Light green
      case DistrictType.entertainment:
        return '#FF1493'; // Deep pink
      case DistrictType.military:
        return '#2F4F4F'; // Dark slate gray
      case DistrictType.economicZone:
        return '#00CED1'; // Dark turquoise
    }
  }

  /// Check if district is residential/living area
  bool get isResidential =>
      this == DistrictType.residential || this == DistrictType.mixedUse;

  /// Check if district is industrial/manufacturing
  bool get isIndustrial => this == DistrictType.industrial;

  /// Check if district is commercial/business
  bool get isCommercial => this == DistrictType.commercial;

  /// Get primary concern for this district type (traffic, pollution, energy, safety)
  String get primaryConcern {
    switch (this) {
      case DistrictType.residential:
        return 'Safety & Quality of Life';
      case DistrictType.commercial:
        return 'Traffic & Congestion';
      case DistrictType.industrial:
        return 'Pollution & Safety';
      case DistrictType.educational:
        return 'Safety & Crowding';
      case DistrictType.medical:
        return 'Emergency Response';
      case DistrictType.transportHub:
        return 'Traffic & Coordination';
      case DistrictType.greenZone:
        return 'Environmental Quality';
      case DistrictType.government:
        return 'Security & Operations';
      case DistrictType.mixedUse:
        return 'Balanced Management';
      case DistrictType.agricultural:
        return 'Resource Management';
      case DistrictType.entertainment:
        return 'Crowd Management';
      case DistrictType.military:
        return 'Security';
      case DistrictType.economicZone:
        return 'Economic Operations';
    }
  }
}
