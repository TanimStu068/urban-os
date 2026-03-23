/// Comprehensive metrics for a district's operational health
class DistrictMetrics {
  /// Average traffic level (0-100%, 0 is free flow)
  final double averageTraffic;

  /// Total energy consumption in MWh
  final double energyConsumption;

  /// Air quality index (0-500, lower is better)
  final double airQualityIndex;

  /// Overall safety score (0-100, 100 is safest)
  final double safetyScore;

  /// Average temperature in Celsius
  final double? averageTemperature;

  /// Average humidity percentage (0-100)
  final double? averageHumidity;

  /// Noise level in decibels (dB)
  final double? noiseLevelDb;

  /// Water consumption in cubic meters
  final double? waterConsumption;

  /// Percentage of green space
  final double? greenSpacePercentage;

  /// Number of active incidents/emergencies
  final int activeIncidents;

  /// Public satisfaction score (0-100)
  final double? satisfactionScore;

  /// Waste generation in tons per day
  final double? wasteGeneration;

  /// Renewable energy percentage (0-100)
  final double? renewableEnergyPercent;

  /// When these metrics were last updated
  final DateTime? lastUpdated;

  const DistrictMetrics({
    required this.averageTraffic,
    required this.energyConsumption,
    required this.airQualityIndex,
    required this.safetyScore,
    this.averageTemperature,
    this.averageHumidity,
    this.noiseLevelDb,
    this.waterConsumption,
    this.greenSpacePercentage,
    this.activeIncidents = 0,
    this.satisfactionScore,
    this.wasteGeneration,
    this.renewableEnergyPercent,
    this.lastUpdated,
  });

  /// Create a copy with optional field overrides
  DistrictMetrics copyWith({
    double? averageTraffic,
    double? energyConsumption,
    double? airQualityIndex,
    double? safetyScore,
    double? averageTemperature,
    double? averageHumidity,
    double? noiseLevelDb,
    double? waterConsumption,
    double? greenSpacePercentage,
    int? activeIncidents,
    double? satisfactionScore,
    double? wasteGeneration,
    double? renewableEnergyPercent,
    DateTime? lastUpdated,
  }) {
    return DistrictMetrics(
      averageTraffic: averageTraffic ?? this.averageTraffic,
      energyConsumption: energyConsumption ?? this.energyConsumption,
      airQualityIndex: airQualityIndex ?? this.airQualityIndex,
      safetyScore: safetyScore ?? this.safetyScore,
      averageTemperature: averageTemperature ?? this.averageTemperature,
      averageHumidity: averageHumidity ?? this.averageHumidity,
      noiseLevelDb: noiseLevelDb ?? this.noiseLevelDb,
      waterConsumption: waterConsumption ?? this.waterConsumption,
      greenSpacePercentage: greenSpacePercentage ?? this.greenSpacePercentage,
      activeIncidents: activeIncidents ?? this.activeIncidents,
      satisfactionScore: satisfactionScore ?? this.satisfactionScore,
      wasteGeneration: wasteGeneration ?? this.wasteGeneration,
      renewableEnergyPercent:
          renewableEnergyPercent ?? this.renewableEnergyPercent,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'averageTraffic': averageTraffic,
      'energyConsumption': energyConsumption,
      'airQualityIndex': airQualityIndex,
      'safetyScore': safetyScore,
      'averageTemperature': averageTemperature,
      'averageHumidity': averageHumidity,
      'noiseLevelDb': noiseLevelDb,
      'waterConsumption': waterConsumption,
      'greenSpacePercentage': greenSpacePercentage,
      'activeIncidents': activeIncidents,
      'satisfactionScore': satisfactionScore,
      'wasteGeneration': wasteGeneration,
      'renewableEnergyPercent': renewableEnergyPercent,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory DistrictMetrics.fromJson(Map<String, dynamic> json) {
    return DistrictMetrics(
      averageTraffic: (json['averageTraffic'] as num?)?.toDouble() ?? 0.0,
      energyConsumption: (json['energyConsumption'] as num?)?.toDouble() ?? 0.0,
      airQualityIndex: (json['airQualityIndex'] as num?)?.toDouble() ?? 0.0,
      safetyScore: (json['safetyScore'] as num?)?.toDouble() ?? 0.0,
      averageTemperature: (json['averageTemperature'] as num?)?.toDouble(),
      averageHumidity: (json['averageHumidity'] as num?)?.toDouble(),
      noiseLevelDb: (json['noiseLevelDb'] as num?)?.toDouble(),
      waterConsumption: (json['waterConsumption'] as num?)?.toDouble(),
      greenSpacePercentage: (json['greenSpacePercentage'] as num?)?.toDouble(),
      activeIncidents: json['activeIncidents'] ?? 0,
      satisfactionScore: (json['satisfactionScore'] as num?)?.toDouble(),
      wasteGeneration: (json['wasteGeneration'] as num?)?.toDouble(),
      renewableEnergyPercent: (json['renewableEnergyPercent'] as num?)
          ?.toDouble(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  /// Get overall health score (weighted average of key metrics)
  double get overallHealthScore {
    var score = 0.0;
    score += (100 - averageTraffic) * 0.2; // Lower traffic is better
    score += (100 - airQualityIndex.clamp(0, 100)) * 0.2; // Better air quality
    score += safetyScore * 0.3; // Safety is most important
    score += (satisfactionScore ?? 70) * 0.2; // Citizen satisfaction
    score += (greenSpacePercentage ?? 50) * 0.1; // Green space quality
    return score.clamp(0, 100);
  }

  /// Check if district is in good health
  bool get isHealthy => overallHealthScore >= 70;

  /// Check if district has critical issues
  bool get hasCriticalIssues =>
      safetyScore < 50 || airQualityIndex > 300 || averageTraffic > 90;

  @override
  String toString() =>
      'DistrictMetrics(traffic: $averageTraffic%, safety: $safetyScore, '
      'aqi: $airQualityIndex, health: ${overallHealthScore.toStringAsFixed(1)})';
}
