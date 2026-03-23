import 'package:urban_os/models/actuator/actuator_model.dart';
import 'package:urban_os/models/infrastructure/road_status.dart';
import 'package:urban_os/models/infrastructure/road_type.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';

/// Represents a road segment in the traffic network
class RoadModel {
  final String id;
  final String name;
  final String districtId;
  final String zoneId;
  final RoadType type;
  final RoadStatus status;
  final int laneCount;
  final double speedLimit; // km/h
  final double vehicleDensity; // vehicles per minute
  final double congestionLevel; // 0-100%
  final double accidentRisk; // 0-100%
  final List<SensorModel> sensors;
  final List<ActuatorModel> actuators;
  final double? length; // km
  final List<String>? connectedRoadIds;
  final DateTime? lastStatusUpdate;

  const RoadModel({
    required this.id,
    required this.name,
    required this.districtId,
    required this.zoneId,
    required this.type,
    required this.status,
    required this.laneCount,
    required this.speedLimit,
    required this.vehicleDensity,
    required this.congestionLevel,
    required this.accidentRisk,
    this.sensors = const [],
    this.actuators = const [],
    this.length,
    this.connectedRoadIds,
    this.lastStatusUpdate,
  });

  RoadModel copyWith({
    RoadStatus? status,
    List<SensorModel>? sensors,
    List<ActuatorModel>? actuators,
    double? vehicleDensity,
    double? congestionLevel,
    double? accidentRisk,
    DateTime? lastStatusUpdate,
  }) {
    return RoadModel(
      id: id,
      name: name,
      districtId: districtId,
      zoneId: zoneId,
      type: type,
      status: status ?? this.status,
      laneCount: laneCount,
      speedLimit: speedLimit,
      vehicleDensity: vehicleDensity ?? this.vehicleDensity,
      congestionLevel: congestionLevel ?? this.congestionLevel,
      accidentRisk: accidentRisk ?? this.accidentRisk,
      sensors: sensors ?? this.sensors,
      actuators: actuators ?? this.actuators,
      length: length,
      connectedRoadIds: connectedRoadIds,
      lastStatusUpdate: lastStatusUpdate ?? this.lastStatusUpdate,
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
      'laneCount': laneCount,
      'speedLimit': speedLimit,
      'vehicleDensity': vehicleDensity,
      'congestionLevel': congestionLevel,
      'accidentRisk': accidentRisk,
      'length': length,
      'connectedRoadIds': connectedRoadIds,
      'lastStatusUpdate': lastStatusUpdate?.toIso8601String(),
    };
  }

  /// Get traffic flow health (0-100)
  double get trafficHealth {
    final healthScore = 100 - congestionLevel;
    return (healthScore * (1 - (accidentRisk / 100))).clamp(0, 100);
  }

  /// Check if road is safe for travel
  bool get isSafe => status.isPassable && accidentRisk < 30;

  @override
  String toString() =>
      'RoadModel(id: $id, name: $name, status: ${status.displayName}, '
      'congestion: ${congestionLevel.toStringAsFixed(1)}%)';

  factory RoadModel.fromJson(Map<String, dynamic> json) {
    return RoadModel(
      id: json['id'] as String,
      name: json['name'] as String,
      districtId: json['districtId'] as String,
      zoneId: json['zoneId'] as String,
      type: RoadType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => RoadType.local,
      ),
      status: RoadStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => RoadStatus.open,
      ),
      laneCount: json['laneCount'] as int,
      speedLimit: (json['speedLimit'] as num).toDouble(),
      vehicleDensity: (json['vehicleDensity'] as num).toDouble(),
      congestionLevel: (json['congestionLevel'] as num).toDouble(),
      accidentRisk: (json['accidentRisk'] as num).toDouble(),
      length: (json['length'] as num?)?.toDouble(),
      connectedRoadIds: (json['connectedRoadIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      lastStatusUpdate: json['lastStatusUpdate'] != null
          ? DateTime.parse(json['lastStatusUpdate'])
          : null,
    );
  }
}
