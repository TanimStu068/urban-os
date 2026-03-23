import 'package:urban_os/models/actuator/actuator_state.dart';
import 'package:urban_os/models/actuator/actuator_type.dart';

/// Represents a controllable device/actuator in the UrbanOS system
///
/// Actuators are devices that can be commanded to perform actions
/// (e.g., turn on/off, adjust speed, open/close, etc).
class ActuatorModel {
  /// Unique identifier for the actuator
  final String id;

  /// Human-readable name (e.g., "Main Street Traffic Light 1")
  final String name;

  /// Type of actuator (determines its control capabilities)
  final ActuatorType type;

  /// Current operational state
  final ActuatorState state;

  /// ID of the district this actuator serves
  final String districtId;

  /// ID of the zone this actuator is located in (optional)
  final String? zoneId;

  /// Geographic coordinates (latitude) if available
  final double? latitude;

  /// Geographic coordinates (longitude) if available
  final double? longitude;

  /// Location description (e.g., "Downtown Intersection Main & 5th")
  final String? location;

  /// Current control value (0-100 for dimmers, on/off for switches, etc)
  final double? currentValue;

  /// Whether this actuator is responding to commands
  final bool isResponsive;

  /// Last command sent to this actuator
  final String? lastCommandId;

  /// When the last command was sent
  final DateTime? lastCommandTime;

  /// Power consumption in watts (if applicable)
  final double? powerConsumption;

  /// When the actuator was installed
  final DateTime? installedDate;

  /// Last time the actuator was serviced
  final DateTime? lastMaintenanceDate;

  /// ID of the automation rule currently controlling this actuator
  final String? activeRuleId;

  const ActuatorModel({
    required this.id,
    required this.name,
    required this.type,
    required this.state,
    required this.districtId,
    this.zoneId,
    this.latitude,
    this.longitude,
    this.location,
    this.currentValue,
    this.isResponsive = true,
    this.lastCommandId,
    this.lastCommandTime,
    this.powerConsumption,
    this.installedDate,
    this.lastMaintenanceDate,
    this.activeRuleId,
  });

  /// Create a copy of this actuator with optional field overrides
  ActuatorModel copyWith({
    String? id,
    String? name,
    ActuatorType? type,
    ActuatorState? state,
    String? districtId,
    String? zoneId,
    double? latitude,
    double? longitude,
    String? location,
    double? currentValue,
    bool? isResponsive,
    String? lastCommandId,
    DateTime? lastCommandTime,
    double? powerConsumption,
    DateTime? installedDate,
    DateTime? lastMaintenanceDate,
    String? activeRuleId,
  }) {
    return ActuatorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      state: state ?? this.state,
      districtId: districtId ?? this.districtId,
      zoneId: zoneId ?? this.zoneId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      location: location ?? this.location,
      currentValue: currentValue ?? this.currentValue,
      isResponsive: isResponsive ?? this.isResponsive,
      lastCommandId: lastCommandId ?? this.lastCommandId,
      lastCommandTime: lastCommandTime ?? this.lastCommandTime,
      powerConsumption: powerConsumption ?? this.powerConsumption,
      installedDate: installedDate ?? this.installedDate,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      activeRuleId: activeRuleId ?? this.activeRuleId,
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
      'currentValue': currentValue,
      'isResponsive': isResponsive,
      'lastCommandId': lastCommandId,
      'lastCommandTime': lastCommandTime?.toIso8601String(),
      'powerConsumption': powerConsumption,
      'installedDate': installedDate?.toIso8601String(),
      'lastMaintenanceDate': lastMaintenanceDate?.toIso8601String(),
      'activeRuleId': activeRuleId,
    };
  }

  /// Create from JSON response
  factory ActuatorModel.fromJson(Map<String, dynamic> json) {
    return ActuatorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: _actuatorTypeFromString(json['type']),
      state: _actuatorStateFromString(json['state']),
      districtId: json['districtId'] ?? '',
      zoneId: json['zoneId'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      location: json['location'],
      currentValue: json['currentValue']?.toDouble(),
      isResponsive: json['isResponsive'] ?? true,
      lastCommandId: json['lastCommandId'],
      lastCommandTime: json['lastCommandTime'] != null
          ? DateTime.parse(json['lastCommandTime'])
          : null,
      powerConsumption: json['powerConsumption']?.toDouble(),
      installedDate: json['installedDate'] != null
          ? DateTime.parse(json['installedDate'])
          : null,
      lastMaintenanceDate: json['lastMaintenanceDate'] != null
          ? DateTime.parse(json['lastMaintenanceDate'])
          : null,
      activeRuleId: json['activeRuleId'],
    );
  }

  /// Check if actuator is healthy (operational and responsive)
  bool get isHealthy => state == ActuatorState.enabled && isResponsive;

  /// Check if actuator needs maintenance
  bool get needsMaintenance {
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
    if (!isResponsive) return 'Unresponsive';
    if (state == ActuatorState.error) return 'Error';
    if (needsMaintenance) return 'Needs Service';
    if (state.hasIssues) return 'Under Maintenance';
    return 'Healthy';
  }

  /// Check if time since last command exceeds threshold
  bool get isIdleCommand {
    if (lastCommandTime == null) return true;
    return DateTime.now().difference(lastCommandTime!).inMinutes > 60;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActuatorModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          districtId == other.districtId;

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ districtId.hashCode;

  @override
  String toString() =>
      'ActuatorModel(id: $id, name: $name, type: $type, state: $state, '
      'responsive: $isResponsive, value: $currentValue)';
}

/// Helper to parse ActuatorType from string
ActuatorType _actuatorTypeFromString(String? value) {
  if (value == null) return ActuatorType.genericSwitch;
  for (final type in ActuatorType.values) {
    if (type.toString().split('.').last == value) return type;
  }
  return ActuatorType.genericSwitch;
}

/// Helper to parse ActuatorState from string
ActuatorState _actuatorStateFromString(String? value) {
  if (value == null) return ActuatorState.disabled;
  for (final state in ActuatorState.values) {
    if (state.toString().split('.').last == value) return state;
  }
  return ActuatorState.disabled;
}
