import 'package:urban_os/models/city/city_health_model.dart';
import 'package:urban_os/models/district/district_model.dart';

/// Represents the entire city in the UrbanOS digital twin system
///
/// The CityModel is the top-level entity that contains all districts
/// and provides city-wide analytics and aggregated metrics
class CityModel {
  /// Unique identifier for the city
  final String id;

  /// City name
  final String name;

  /// City population
  final int? population;

  /// City area in square kilometers
  final double? areaKm2;

  /// City-wide geographic coordinates (city center)
  final double? latitude;
  final double? longitude;

  /// Timezone of the city
  final String? timezone;

  /// Country/Region for the city
  final String? region;

  /// All districts within the city
  final List<DistrictModel> districts;

  /// Overall city health assessment
  final CityHealthModel health;

  /// Total number of sensors deployed
  final int totalSensors;

  /// Total number of actuators deployed
  final int totalActuators;

  /// Whether the city is actively being monitored
  final bool isMonitored;

  /// When the city was added to the system
  final DateTime? addedDate;

  /// Last time city data was updated
  final DateTime? lastUpdateTime;

  /// Brief description of the city
  final String? description;

  const CityModel({
    required this.id,
    required this.name,
    required this.districts,
    required this.health,
    this.population,
    this.areaKm2,
    this.latitude,
    this.longitude,
    this.timezone,
    this.region,
    this.totalSensors = 0,
    this.totalActuators = 0,
    this.isMonitored = true,
    this.addedDate,
    this.lastUpdateTime,
    this.description,
  });

  /// Create a copy with optional field overrides
  CityModel copyWith({
    String? id,
    String? name,
    int? population,
    double? areaKm2,
    double? latitude,
    double? longitude,
    String? timezone,
    String? region,
    List<DistrictModel>? districts,
    CityHealthModel? health,
    int? totalSensors,
    int? totalActuators,
    bool? isMonitored,
    DateTime? addedDate,
    DateTime? lastUpdateTime,
    String? description,
  }) {
    return CityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      population: population ?? this.population,
      areaKm2: areaKm2 ?? this.areaKm2,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      region: region ?? this.region,
      districts: districts ?? this.districts,
      health: health ?? this.health,
      totalSensors: totalSensors ?? this.totalSensors,
      totalActuators: totalActuators ?? this.totalActuators,
      isMonitored: isMonitored ?? this.isMonitored,
      addedDate: addedDate ?? this.addedDate,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      description: description ?? this.description,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'population': population,
      'areaKm2': areaKm2,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
      'region': region,
      'districts': districts.map((d) => d.toJson()).toList(),
      'health': health.toJson(),
      'totalSensors': totalSensors,
      'totalActuators': totalActuators,
      'isMonitored': isMonitored,
      'addedDate': addedDate?.toIso8601String(),
      'lastUpdateTime': lastUpdateTime?.toIso8601String(),
      'description': description,
    };
  }

  /// Create from JSON
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      population: json['population'],
      areaKm2: (json['areaKm2'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      timezone: json['timezone'],
      region: json['region'],
      districts: ((json['districts'] ?? []) as List)
          .map((d) => DistrictModel.fromJson(d as Map<String, dynamic>))
          .toList(),
      health: CityHealthModel.fromJson(
        json['health'] ?? {'overallScore': 0, 'status': 'normal'},
      ),
      totalSensors: json['totalSensors'] ?? 0,
      totalActuators: json['totalActuators'] ?? 0,
      isMonitored: json['isMonitored'] ?? true,
      addedDate: json['addedDate'] != null
          ? DateTime.parse(json['addedDate'])
          : null,
      lastUpdateTime: json['lastUpdateTime'] != null
          ? DateTime.parse(json['lastUpdateTime'])
          : null,
      description: json['description'],
    );
  }

  /// Get district by ID
  DistrictModel? getDistrict(String districtId) {
    try {
      return districts.firstWhere((d) => d.id == districtId);
    } catch (_) {
      return null;
    }
  }

  /// Calculate population density (people per km²)
  double? get populationDensity {
    if (population == null || areaKm2 == null) return null;
    return population! / areaKm2!;
  }

  /// Get count of critical districts
  int get criticalDistrictCount {
    return districts.where((d) => d.safetyScore < 60).length;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CityModel(id: $id, name: $name, districts: ${districts.length}, '
      'health: ${health.overallScore}%)';
}
