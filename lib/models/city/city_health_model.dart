import 'package:urban_os/models/city/city_status.dart';

/// Comprehensive health assessment of the city
///
/// Combines multiple metrics to provide an overall picture of city wellbeing
class CityHealthModel {
  /// Overall health score (0-100)
  final double overallScore;

  /// Current operational status
  final CityStatus status;

  /// Traffic system health (0-100)
  final double? trafficHealth;

  /// Energy system health (0-100)
  final double? energyHealth;

  /// Environmental quality score (0-100)
  final double? environmentalHealth;

  /// Public safety score (0-100)
  final double? safetyScore;

  /// Air quality index (0-500, lower is better)
  final double? airQualityIndex;

  /// Average temperature in Celsius
  final double? averageTemperature;

  /// Average humidity percentage (0-100)
  final double? averageHumidity;

  /// Number of active incidents/alerts
  final int activeAlerts;

  /// Number of districts with critical issues
  final int criticalDistricts;

  /// Last time health was assessed
  final DateTime? lastAssessmentTime;

  /// When this health model was created/updated
  final DateTime? timestamp;

  const CityHealthModel({
    required this.overallScore,
    required this.status,
    this.trafficHealth,
    this.energyHealth,
    this.environmentalHealth,
    this.safetyScore,
    this.airQualityIndex,
    this.averageTemperature,
    this.averageHumidity,
    this.activeAlerts = 0,
    this.criticalDistricts = 0,
    this.lastAssessmentTime,
    this.timestamp,
  });

  /// Create a copy with optional field overrides
  CityHealthModel copyWith({
    double? overallScore,
    CityStatus? status,
    double? trafficHealth,
    double? energyHealth,
    double? environmentalHealth,
    double? safetyScore,
    double? airQualityIndex,
    double? averageTemperature,
    double? averageHumidity,
    int? activeAlerts,
    int? criticalDistricts,
    DateTime? lastAssessmentTime,
    DateTime? timestamp,
  }) {
    return CityHealthModel(
      overallScore: overallScore ?? this.overallScore,
      status: status ?? this.status,
      trafficHealth: trafficHealth ?? this.trafficHealth,
      energyHealth: energyHealth ?? this.energyHealth,
      environmentalHealth: environmentalHealth ?? this.environmentalHealth,
      safetyScore: safetyScore ?? this.safetyScore,
      airQualityIndex: airQualityIndex ?? this.airQualityIndex,
      averageTemperature: averageTemperature ?? this.averageTemperature,
      averageHumidity: averageHumidity ?? this.averageHumidity,
      activeAlerts: activeAlerts ?? this.activeAlerts,
      criticalDistricts: criticalDistricts ?? this.criticalDistricts,
      lastAssessmentTime: lastAssessmentTime ?? this.lastAssessmentTime,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'overallScore': overallScore,
      'status': status.toString().split('.').last,
      'trafficHealth': trafficHealth,
      'energyHealth': energyHealth,
      'environmentalHealth': environmentalHealth,
      'safetyScore': safetyScore,
      'airQualityIndex': airQualityIndex,
      'averageTemperature': averageTemperature,
      'averageHumidity': averageHumidity,
      'activeAlerts': activeAlerts,
      'criticalDistricts': criticalDistricts,
      'lastAssessmentTime': lastAssessmentTime?.toIso8601String(),
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory CityHealthModel.fromJson(Map<String, dynamic> json) {
    return CityHealthModel(
      overallScore: (json['overallScore'] as num?)?.toDouble() ?? 0.0,
      status: _statusFromString(json['status']),
      trafficHealth: (json['trafficHealth'] as num?)?.toDouble(),
      energyHealth: (json['energyHealth'] as num?)?.toDouble(),
      environmentalHealth: (json['environmentalHealth'] as num?)?.toDouble(),
      safetyScore: (json['safetyScore'] as num?)?.toDouble(),
      airQualityIndex: (json['airQualityIndex'] as num?)?.toDouble(),
      averageTemperature: (json['averageTemperature'] as num?)?.toDouble(),
      averageHumidity: (json['averageHumidity'] as num?)?.toDouble(),
      activeAlerts: json['activeAlerts'] ?? 0,
      criticalDistricts: json['criticalDistricts'] ?? 0,
      lastAssessmentTime: json['lastAssessmentTime'] != null
          ? DateTime.parse(json['lastAssessmentTime'])
          : null,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }

  /// Get a visual health rating (A-F)
  String get healthRating {
    if (overallScore >= 90) return 'A (Excellent)';
    if (overallScore >= 80) return 'B (Good)';
    if (overallScore >= 70) return 'C (Fair)';
    if (overallScore >= 60) return 'D (Poor)';
    return 'F (Critical)';
  }

  /// Check if health has improved since last assessment
  bool get isImproving {
    // This would typically compare with previous health snapshot
    // For now, just return true if status is better
    return status != CityStatus.critical;
  }

  @override
  String toString() =>
      'CityHealth(score: $overallScore, status: ${status.displayName}, '
      'alerts: $activeAlerts, rating: $healthRating)';
}

/// Helper to parse CityStatus from string
CityStatus _statusFromString(String? value) {
  if (value == null) return CityStatus.normal;
  for (final status in CityStatus.values) {
    if (status.toString().split('.').last == value) return status;
  }
  return CityStatus.normal;
}
