import 'package:urban_os/models/district/district_metrics.dart';
import 'package:urban_os/models/district/district_type.dart';

/// Represents an urban district within a city
///
/// A district is a geographically defined area of the city with its own
/// characteristics, infrastructure, and sensor/actuator networks
class DistrictModel {
  /// Unique identifier for the district
  final String id;

  /// District name
  final String name;

  /// Type of district (residential, commercial, industrial, etc)
  final DistrictType type;

  /// IDs of all sensors deployed in this district
  final List<String> sensorIds;

  /// IDs of all actuators deployed in this district
  final List<String> actuatorIds;

  /// Current performance metrics for the district
  final DistrictMetrics metrics;

  /// Population of the district
  final int? population;

  /// Area of the district in square kilometers
  final double? areaKm2;

  /// Geographic center - latitude
  final double? latitude;

  /// Geographic center - longitude
  final double? longitude;

  /// Brief description of the district
  final String? description;

  /// Whether the district is currently being monitored
  final bool isActive;

  /// When the district was added to the system
  final DateTime? addedDate;

  /// Last time district data was updated
  final DateTime? lastUpdateTime;

  /// ID of the city this district belongs to
  final String? cityId;

  /// Overall sustainability score (0-100)
  final double? sustainabilityScore;

  /// Development status (developing, developed, planned)
  final String? developmentStatus;

  const DistrictModel({
    required this.id,
    required this.name,
    required this.type,
    required this.sensorIds,
    required this.actuatorIds,
    required this.metrics,
    this.population,
    this.areaKm2,
    this.latitude,
    this.longitude,
    this.description,
    this.isActive = true,
    this.addedDate,
    this.lastUpdateTime,
    this.cityId,
    this.sustainabilityScore,
    this.developmentStatus,
  });

  /// Create a copy with optional field overrides
  DistrictModel copyWith({
    String? id,
    String? name,
    DistrictType? type,
    List<String>? sensorIds,
    List<String>? actuatorIds,
    DistrictMetrics? metrics,
    int? population,
    double? areaKm2,
    double? latitude,
    double? longitude,
    String? description,
    bool? isActive,
    DateTime? addedDate,
    DateTime? lastUpdateTime,
    String? cityId,
    double? sustainabilityScore,
    String? developmentStatus,
  }) {
    return DistrictModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      sensorIds: sensorIds ?? this.sensorIds,
      actuatorIds: actuatorIds ?? this.actuatorIds,
      metrics: metrics ?? this.metrics,
      population: population ?? this.population,
      areaKm2: areaKm2 ?? this.areaKm2,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      addedDate: addedDate ?? this.addedDate,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      cityId: cityId ?? this.cityId,
      sustainabilityScore: sustainabilityScore ?? this.sustainabilityScore,
      developmentStatus: developmentStatus ?? this.developmentStatus,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'sensorIds': sensorIds,
      'actuatorIds': actuatorIds,
      'metrics': metrics.toJson(),
      'population': population,
      'areaKm2': areaKm2,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'isActive': isActive,
      'addedDate': addedDate?.toIso8601String(),
      'lastUpdateTime': lastUpdateTime?.toIso8601String(),
      'cityId': cityId,
      'sustainabilityScore': sustainabilityScore,
      'developmentStatus': developmentStatus,
    };
  }

  /// Create from JSON
  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: _districtTypeFromString(json['type']),
      sensorIds: json['sensorIds'] != null
          ? List<String>.from(json['sensorIds'])
          : [],
      actuatorIds: json['actuatorIds'] != null
          ? List<String>.from(json['actuatorIds'])
          : [],
      metrics: DistrictMetrics.fromJson(json['metrics'] ?? {}),
      population: json['population'],
      areaKm2: (json['areaKm2'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      description: json['description'],
      isActive: json['isActive'] ?? true,
      addedDate: json['addedDate'] != null
          ? DateTime.parse(json['addedDate'])
          : null,
      lastUpdateTime: json['lastUpdateTime'] != null
          ? DateTime.parse(json['lastUpdateTime'])
          : null,
      cityId: json['cityId'],
      sustainabilityScore: (json['sustainabilityScore'] as num?)?.toDouble(),
      developmentStatus: json['developmentStatus'],
    );
  }

  /// Get sensor count
  int get sensorCount => sensorIds.length;

  /// Get actuator count
  int get actuatorCount => actuatorIds.length;

  /// Get population density (people per km²)
  double? get populationDensity {
    if (population == null || areaKm2 == null) return null;
    return population! / areaKm2!;
  }

  /// Check if district needs immediate attention
  bool get needsAttention => metrics.hasCriticalIssues;

  /// Get overall health percentage
  double get healthPercentage => metrics.overallHealthScore;

  // Expose metrics fields for backward compatibility
  get averageTraffic => metrics.averageTraffic;
  get safetyScore => metrics.safetyScore;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistrictModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'DistrictModel(id: $id, name: $name, type: ${type.displayName}, '
      'sensors: ${sensorIds.length}, health: ${healthPercentage.toStringAsFixed(1)}%)';
}

/// Helper to parse DistrictType from string
DistrictType _districtTypeFromString(String? value) {
  if (value == null) return DistrictType.residential;
  for (final type in DistrictType.values) {
    if (type.toString().split('.').last == value) return type;
  }
  return DistrictType.residential;
}
