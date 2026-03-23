import 'package:urban_os/models/actuator/actuator_model.dart';
import 'package:urban_os/models/infrastructure/building_status.dart';
import 'package:urban_os/models/infrastructure/building_type.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';

/// Represents a building in the urban infrastructure
class BuildingModel {
  final String id;
  final String name;
  final String districtId;
  final String zoneId;
  final BuildingType type;
  final BuildingStatus status;
  final int maxOccupancy;
  final int currentOccupancy;
  final double energyUsage; // kWh
  final double waterUsage; // m³
  final double gasUsage; // m³
  final double riskLevel; // 0-100
  final bool isCritical;
  final List<SensorModel> sensors;
  final List<ActuatorModel> actuators;
  final double? latitude;
  final double? longitude;
  final int? yearBuilt;
  final DateTime? lastInspectionDate;
  final String? address;

  const BuildingModel({
    required this.id,
    required this.name,
    required this.districtId,
    required this.zoneId,
    required this.type,
    required this.status,
    required this.maxOccupancy,
    required this.currentOccupancy,
    required this.energyUsage,
    required this.waterUsage,
    required this.gasUsage,
    required this.riskLevel,
    required this.isCritical,
    this.sensors = const [],
    this.actuators = const [],
    this.latitude,
    this.longitude,
    this.yearBuilt,
    this.lastInspectionDate,
    this.address,
  });

  BuildingModel copyWith({
    BuildingStatus? status,
    int? currentOccupancy,
    double? energyUsage,
    double? waterUsage,
    double? gasUsage,
    double? riskLevel,
    List<SensorModel>? sensors,
    List<ActuatorModel>? actuators,
    DateTime? lastInspectionDate,
  }) {
    return BuildingModel(
      id: id,
      name: name,
      districtId: districtId,
      zoneId: zoneId,
      type: type,
      status: status ?? this.status,
      maxOccupancy: maxOccupancy,
      currentOccupancy: currentOccupancy ?? this.currentOccupancy,
      energyUsage: energyUsage ?? this.energyUsage,
      waterUsage: waterUsage ?? this.waterUsage,
      gasUsage: gasUsage ?? this.gasUsage,
      riskLevel: riskLevel ?? this.riskLevel,
      isCritical: isCritical,
      sensors: sensors ?? this.sensors,
      actuators: actuators ?? this.actuators,
      latitude: latitude,
      longitude: longitude,
      yearBuilt: yearBuilt,
      lastInspectionDate: lastInspectionDate ?? this.lastInspectionDate,
      address: address,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'districtId': districtId,
      'zoneId': zoneId,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'maxOccupancy': maxOccupancy,
      'currentOccupancy': currentOccupancy,
      'energyUsage': energyUsage,
      'waterUsage': waterUsage,
      'gasUsage': gasUsage,
      'riskLevel': riskLevel,
      'isCritical': isCritical,
      'latitude': latitude,
      'longitude': longitude,
      'yearBuilt': yearBuilt,
      'lastInspectionDate': lastInspectionDate?.toIso8601String(),
      'address': address,
    };
  }

  /// Get occupancy percentage (0-100)
  double get occupancyPercent {
    if (maxOccupancy == 0) return 0;
    return ((currentOccupancy / maxOccupancy) * 100).clamp(0, 100);
  }

  /// Check if building is overcrowded
  bool get isOvercrowded => occupancyPercent > 90;

  /// Get building age in years
  int? get ageYears {
    if (yearBuilt == null) return null;
    return DateTime.now().year - yearBuilt!;
  }

  /// Check if building needs inspection
  bool get needsInspection {
    if (lastInspectionDate == null) return true;
    final daysSinceInspection = DateTime.now()
        .difference(lastInspectionDate!)
        .inDays;
    return daysSinceInspection > 365;
  }

  @override
  String toString() =>
      'BuildingModel(id: $id, name: $name, type: ${type.displayName}, '
      'occupancy: ${occupancyPercent.toStringAsFixed(1)}%, status: ${status.displayName})';

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      districtId: json['districtId'] as String,
      zoneId: json['zoneId'] as String,
      type: BuildingType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => BuildingType.office,
      ),
      status: BuildingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => BuildingStatus.operational,
      ),
      maxOccupancy: json['maxOccupancy'] as int,
      currentOccupancy: json['currentOccupancy'] as int,
      energyUsage: (json['energyUsage'] as num).toDouble(),
      waterUsage: (json['waterUsage'] as num).toDouble(),
      gasUsage: (json['gasUsage'] as num).toDouble(),
      riskLevel: (json['riskLevel'] as num).toDouble(),
      isCritical: json['isCritical'] as bool,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      yearBuilt: json['yearBuilt'] as int?,
      lastInspectionDate: json['lastInspectionDate'] != null
          ? DateTime.parse(json['lastInspectionDate'])
          : null,
      address: json['address'] as String?,
    );
  }
}
