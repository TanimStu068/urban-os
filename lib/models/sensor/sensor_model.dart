import 'package:urban_os/models/sensor/sensor_reading.dart';
import 'package:urban_os/models/sensor/sensor_state.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';

/// Represents a physical IoT sensor device in the UrbanOS system
///
/// Sensors continuously measure environmental and infrastructure metrics
/// across the city, feeding data into the central monitoring system.
class SensorModel {
  /// Unique identifier for the sensor
  final String id;

  /// Human-readable sensor name (e.g., "Main Street Traffic Flow Sensor")
  final String name;

  /// Type of sensor (determines what it measures)
  final SensorType type;

  /// Current operational state (online/offline/error)
  final SensorState state;

  /// ID of the district this sensor monitors
  final String districtId;

  /// ID of the zone this sensor is located in (optional)
  final String? zoneId;

  /// Geographic coordinates (latitude) if available
  final double? latitude;

  /// Geographic coordinates (longitude) if available
  final double? longitude;

  /// Location description (e.g., "Downtown Intersection")
  final String? location;

  /// Latest sensor reading with timestamp
  final SensorReading? latestReading;

  /// When the sensor was installed (ISO 8601 format)
  final DateTime? installedDate;

  /// Last time sensor was serviced/calibrated
  final DateTime? lastMaintenanceDate;

  /// Battery percentage if sensor is battery-powered (0-100)
  final int? batteryPercentage;

  /// Signal strength if sensor is wireless (RSSI for WiFi/BLE)
  final int? signalStrength;

  const SensorModel({
    required this.id,
    required this.name,
    required this.type,
    required this.state,
    required this.districtId,
    this.zoneId,
    this.latitude,
    this.longitude,
    this.location,
    this.latestReading,
    this.installedDate,
    this.lastMaintenanceDate,
    this.batteryPercentage,
    this.signalStrength,
  });

  /// Create a copy of this sensor with optional field overrides
  SensorModel copyWith({
    String? id,
    String? name,
    SensorType? type,
    SensorState? state,
    String? districtId,
    String? zoneId,
    double? latitude,
    double? longitude,
    String? location,
    SensorReading? latestReading,
    DateTime? installedDate,
    DateTime? lastMaintenanceDate,
    int? batteryPercentage,
    int? signalStrength,
  }) {
    return SensorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      state: state ?? this.state,
      districtId: districtId ?? this.districtId,
      zoneId: zoneId ?? this.zoneId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      location: location ?? this.location,
      latestReading: latestReading ?? this.latestReading,
      installedDate: installedDate ?? this.installedDate,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      batteryPercentage: batteryPercentage ?? this.batteryPercentage,
      signalStrength: signalStrength ?? this.signalStrength,
    );
  }

  /// Convert to JSON for API serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'state': state.toString().split('.').last,
      'districtId': districtId,
      'zoneId': zoneId,
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'latestReading': latestReading?.toJson(),
      'installedDate': installedDate?.toIso8601String(),
      'lastMaintenanceDate': lastMaintenanceDate?.toIso8601String(),
      'batteryPercentage': batteryPercentage,
      'signalStrength': signalStrength,
    };
  }

  /// Create from JSON response
  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: _sensorTypeFromString(json['type']),
      state: _sensorStateFromString(json['state']),
      districtId: json['districtId'] ?? '',
      zoneId: json['zoneId'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      location: json['location'],
      latestReading: json['latestReading'] != null
          ? SensorReading.fromJson(json['latestReading'])
          : null,
      installedDate: json['installedDate'] != null
          ? DateTime.parse(json['installedDate'])
          : null,
      lastMaintenanceDate: json['lastMaintenanceDate'] != null
          ? DateTime.parse(json['lastMaintenanceDate'])
          : null,
      batteryPercentage: (json['batteryPercentage'] as num?)?.toInt(),
      signalStrength: (json['signalStrength'] as num?)?.toInt(),
    );
  }

  /// Check if sensor is healthy (online and no critical errors)
  bool get isHealthy => state == SensorState.online;

  /// Check if sensor needs maintenance (low battery or old readings)
  bool get needsMaintenance {
    if (batteryPercentage != null && batteryPercentage! < 20) return true;
    if (lastMaintenanceDate != null) {
      final daysSinceMaintenance = DateTime.now()
          .difference(lastMaintenanceDate!)
          .inDays;
      return daysSinceMaintenance > 180; // 6 months
    }
    return false;
  }

  /// Get health status string for UI display
  String get healthStatus {
    if (!isHealthy) return 'Offline';
    if (needsMaintenance) return 'Needs Service';
    if (batteryPercentage != null && batteryPercentage! < 50) {
      return 'Low Battery';
    }
    return 'Healthy';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          state == other.state &&
          districtId == other.districtId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      state.hashCode ^
      districtId.hashCode;

  @override
  String toString() =>
      'SensorModel(id: $id, name: $name, type: $type, state: $state, '
      'batteryPercentage: $batteryPercentage%)';
}

/// Helper to parse SensorType from string
SensorType _sensorTypeFromString(String? value) {
  if (value == null) return SensorType.temperatureSensor;
  for (final type in SensorType.values) {
    if (type.toString().split('.').last == value) return type;
  }
  return SensorType.temperatureSensor;
}

/// Helper to parse SensorState from string
SensorState _sensorStateFromString(String? value) {
  if (value == null) return SensorState.offline;
  for (final state in SensorState.values) {
    if (state.toString().split('.').last == value) return state;
  }
  return SensorState.offline;
}
