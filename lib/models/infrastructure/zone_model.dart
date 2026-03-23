import 'zone_type.dart';
import 'zone_status.dart';

/// Represents a geographic zone within a district
class ZoneModel {
  final String id;
  final String name;
  final String districtId;
  final ZoneType type;
  final ZoneStatus status;
  final List<String> buildingIds;
  final List<String> roadIds;
  final double areaSize; // sq km
  final double populationDensity; // people per sq km
  final double environmentalRisk; // 0-100
  final double safetyScore; // 0-100
  final String? description;
  final double? latitude;
  final double? longitude;
  final DateTime? lastAuditDate;
  final String? governanceType; // Public/Private/Mixed

  const ZoneModel({
    required this.id,
    required this.name,
    required this.districtId,
    required this.type,
    required this.status,
    required this.buildingIds,
    required this.roadIds,
    required this.areaSize,
    required this.populationDensity,
    required this.environmentalRisk,
    required this.safetyScore,
    this.description,
    this.latitude,
    this.longitude,
    this.lastAuditDate,
    this.governanceType,
  });

  ZoneModel copyWith({
    ZoneStatus? status,
    double? environmentalRisk,
    double? safetyScore,
    List<String>? buildingIds,
    List<String>? roadIds,
    DateTime? lastAuditDate,
  }) {
    return ZoneModel(
      id: id,
      name: name,
      districtId: districtId,
      type: type,
      status: status ?? this.status,
      buildingIds: buildingIds ?? this.buildingIds,
      roadIds: roadIds ?? this.roadIds,
      areaSize: areaSize,
      populationDensity: populationDensity,
      environmentalRisk: environmentalRisk ?? this.environmentalRisk,
      safetyScore: safetyScore ?? this.safetyScore,
      description: description,
      latitude: latitude,
      longitude: longitude,
      lastAuditDate: lastAuditDate ?? this.lastAuditDate,
      governanceType: governanceType,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'districtId': districtId,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'buildingIds': buildingIds,
      'roadIds': roadIds,
      'areaSize': areaSize,
      'populationDensity': populationDensity,
      'environmentalRisk': environmentalRisk,
      'safetyScore': safetyScore,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'lastAuditDate': lastAuditDate?.toIso8601String(),
      'governanceType': governanceType,
    };
  }

  /// Create from JSON
  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      districtId: json['districtId'] ?? '',
      type: _zoneTypeFromString(json['type']),
      status: _zoneStatusFromString(json['status']),
      buildingIds: json['buildingIds'] != null
          ? List<String>.from(json['buildingIds'])
          : [],
      roadIds: json['roadIds'] != null
          ? List<String>.from(json['roadIds'])
          : [],
      areaSize: (json['areaSize'] as num?)?.toDouble() ?? 0.0,
      populationDensity: (json['populationDensity'] as num?)?.toDouble() ?? 0.0,
      environmentalRisk: (json['environmentalRisk'] as num?)?.toDouble() ?? 0.0,
      safetyScore: (json['safetyScore'] as num?)?.toDouble() ?? 0.0,
      description: json['description'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      lastAuditDate: json['lastAuditDate'] != null
          ? DateTime.parse(json['lastAuditDate'])
          : null,
      governanceType: json['governanceType'],
    );
  }

  /// Get total population in zone
  int get totalPopulation => (populationDensity * areaSize).toInt();

  /// Get building count
  int get buildingCount => buildingIds.length;

  /// Get road count
  int get roadCount => roadIds.length;

  /// Check if zone has compliance issues
  bool get needsAudit {
    if (lastAuditDate == null) return true;
    final daysSinceAudit = DateTime.now().difference(lastAuditDate!).inDays;
    return daysSinceAudit > 90; // Quarterly audit
  }

  /// Get overall zone health score (weighted average)
  double get healthScore {
    return (safetyScore * 0.5 + (100 - environmentalRisk) * 0.5).clamp(0, 100);
  }

  @override
  String toString() =>
      'ZoneModel(id: $id, name: $name, type: ${type.displayName}, '
      'status: ${status.displayName}, buildings: ${buildingIds.length})';
}

/// Helper to parse ZoneType from string
ZoneType _zoneTypeFromString(String? value) {
  if (value == null) return ZoneType.residential;
  for (final type in ZoneType.values) {
    if (type.toString().split('.').last == value) return type;
  }
  return ZoneType.residential;
}

/// Helper to parse ZoneStatus from string
ZoneStatus _zoneStatusFromString(String? value) {
  if (value == null) return ZoneStatus.normal;
  for (final status in ZoneStatus.values) {
    if (status.toString().split('.').last == value) return status;
  }
  return ZoneStatus.normal;
}
