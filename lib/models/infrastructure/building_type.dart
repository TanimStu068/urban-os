/// Classification of building types in the urban infrastructure
enum BuildingType {
  /// Single-family residential house
  house,

  /// Multi-family residential apartment complex
  apartment,

  /// Office building/commercial workspace
  office,

  /// Manufacturing/industrial factory
  factory,

  /// Hospital/medical facility
  hospital,

  /// School/educational institution
  school,

  /// Shopping mall/commercial center
  mall,

  /// Warehouse/storage facility
  warehouse,

  /// Power generation plant
  powerPlant,

  /// Water treatment/distribution plant
  waterPlant,

  /// Police station
  policeStation,

  /// Fire station
  fireStation,

  /// Government office building
  governmentOffice,

  /// Hotel/lodging
  hotel,

  /// Restaurant/food service
  restaurant,

  /// Utility substation
  substation,

  /// Data center/server facility
  dataCenter,

  /// Library/cultural institution
  library,

  /// Sports facility/gym
  sportsFacility,

  /// Parking structure
  parkingStructure,
}

/// Extension for BuildingType utilities
extension BuildingTypeExtension on BuildingType {
  /// Get human-readable building name
  String get displayName {
    const nameMap = {
      BuildingType.house: 'House',
      BuildingType.apartment: 'Apartment',
      BuildingType.office: 'Office',
      BuildingType.factory: 'Factory',
      BuildingType.hospital: 'Hospital',
      BuildingType.school: 'School',
      BuildingType.mall: 'Shopping Mall',
      BuildingType.warehouse: 'Warehouse',
      BuildingType.powerPlant: 'Power Plant',
      BuildingType.waterPlant: 'Water Treatment Plant',
      BuildingType.policeStation: 'Police Station',
      BuildingType.fireStation: 'Fire Station',
      BuildingType.governmentOffice: 'Government Office',
      BuildingType.hotel: 'Hotel',
      BuildingType.restaurant: 'Restaurant',
      BuildingType.substation: 'Utility Substation',
      BuildingType.dataCenter: 'Data Center',
      BuildingType.library: 'Library',
      BuildingType.sportsFacility: 'Sports Facility',
      BuildingType.parkingStructure: 'Parking Structure',
    };
    return nameMap[this] ?? 'Building';
  }

  /// Check if building is critical infrastructure
  bool get isCritical =>
      this == BuildingType.hospital ||
      this == BuildingType.powerPlant ||
      this == BuildingType.waterPlant ||
      this == BuildingType.policeStation ||
      this == BuildingType.fireStation ||
      this == BuildingType.dataCenter;

  /// Check if building houses people regularly
  bool get housesResidents =>
      this == BuildingType.house ||
      this == BuildingType.apartment ||
      this == BuildingType.hotel ||
      this == BuildingType.office ||
      this == BuildingType.school;

  /// Get typical occupancy during business hours
  int? get typicalOccupancy {
    switch (this) {
      case BuildingType.house:
        return 5;
      case BuildingType.apartment:
        return 300;
      case BuildingType.office:
        return 500;
      case BuildingType.factory:
        return 200;
      case BuildingType.hospital:
        return 300;
      case BuildingType.school:
        return 600;
      case BuildingType.mall:
        return 2000;
      case BuildingType.hotel:
        return 400;
      case BuildingType.restaurant:
        return 150;
      case BuildingType.sportsFacility:
        return 500;
      default:
        return null;
    }
  }
}
