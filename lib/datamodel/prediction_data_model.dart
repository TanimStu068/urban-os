import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

enum PredictMode { anomaly, forecast, risk }

enum ConfidenceLevel { low, medium, high, critical }

extension ConfidenceLevelX on ConfidenceLevel {
  String get label => const ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'][index];
  Color get color => [
    AppColors.mutedLt,
    AppColors.cyan,
    AppColors.amber,
    AppColors.red,
  ][index];
  double get threshold => const [0.3, 0.55, 0.75, 0.9][index];
}

class Prediction {
  final String id;
  final String sensorId;
  final String district;
  final double confidence;
  final ConfidenceLevel level;
  final String summary;
  final String detail;
  final DateTime predictedAt;
  final DateTime? expectedAt;
  final List<double> signalHistory; // raw signal
  final List<double> forecastLine; // predicted values
  final List<double> upperBound;
  final List<double> lowerBound;
  final bool isAnomaly;
  final double anomalyScore;

  const Prediction({
    required this.id,
    required this.sensorId,
    required this.district,
    required this.confidence,
    required this.level,
    required this.summary,
    required this.detail,
    required this.predictedAt,
    this.expectedAt,
    required this.signalHistory,
    required this.forecastLine,
    required this.upperBound,
    required this.lowerBound,
    required this.isAnomaly,
    required this.anomalyScore,
  });
}

class RiskZone {
  final String district;
  final double score; // 0.0–1.0
  final int alertCount;
  final String topThreat;
  const RiskZone(this.district, this.score, this.alertCount, this.topThreat);
}
