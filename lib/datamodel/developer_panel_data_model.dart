// ─────────────────────────────────────────
//  ENUMS & DATA MODELS
// ─────────────────────────────────────────
import 'package:flutter/animation.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

enum LogLevel { debug, info, warning, error, critical }

enum SystemHealthStatus { excellent, good, fair, poor, critical }

extension LogLevelX on LogLevel {
  String get label {
    switch (this) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARN';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.critical:
        return 'CRITICAL';
    }
  }

  Color get color {
    switch (this) {
      case LogLevel.debug:
        return C.cyan;
      case LogLevel.info:
        return C.teal;
      case LogLevel.warning:
        return C.orange;
      case LogLevel.error:
        return C.red;
      case LogLevel.critical:
        return C.violet;
    }
  }
}

extension SystemHealthStatusX on SystemHealthStatus {
  String get label {
    switch (this) {
      case SystemHealthStatus.excellent:
        return 'EXCELLENT';
      case SystemHealthStatus.good:
        return 'GOOD';
      case SystemHealthStatus.fair:
        return 'FAIR';
      case SystemHealthStatus.poor:
        return 'POOR';
      case SystemHealthStatus.critical:
        return 'CRITICAL';
    }
  }

  Color get color {
    switch (this) {
      case SystemHealthStatus.excellent:
        return C.green;
      case SystemHealthStatus.good:
        return C.teal;
      case SystemHealthStatus.fair:
        return C.yellow;
      case SystemHealthStatus.poor:
        return C.orange;
      case SystemHealthStatus.critical:
        return C.red;
    }
  }
}

class DebugLog {
  final String id;
  final LogLevel level;
  final String module;
  final String message;
  final DateTime timestamp;
  final String? stackTrace;

  DebugLog({
    required this.id,
    required this.level,
    required this.module,
    required this.message,
    required this.timestamp,
    this.stackTrace,
  });
}

class PerformanceMetric {
  final String name;
  final double value;
  final String unit;
  final double? threshold;
  final bool isWarning;

  PerformanceMetric({
    required this.name,
    required this.value,
    required this.unit,
    this.threshold,
    required this.isWarning,
  });
}

class SystemInfo {
  final String appVersion;
  final String buildNumber;
  final String platform;
  final String dartVersion;
  final String flutterVersion;
  final DateTime buildDate;
  final String environment;

  SystemInfo({
    required this.appVersion,
    required this.buildNumber,
    required this.platform,
    required this.dartVersion,
    required this.flutterVersion,
    required this.buildDate,
    required this.environment,
  });
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
final _rng = Random(876);
final _now = DateTime.now();

List<DebugLog> buildDebugLogs() {
  final modules = [
    'AUTH',
    'SENSOR',
    'NETWORK',
    'DATABASE',
    'UI',
    'ANIMATION',
    'CACHE',
    'LOCATION',
    'NOTIFICATION',
  ];
  final messages = [
    'Successfully authenticated user',
    'Cache invalidated for sensors',
    'Network request completed',
    'Database query executed',
    'Widget frame rendered',
    'Animation controller disposed',
    'HTTP timeout detected',
    'Permission denied for location',
    'Push notification received',
  ];

  return List.generate(18, (i) {
    final levels = [
      LogLevel.debug,
      LogLevel.info,
      LogLevel.warning,
      LogLevel.error,
      LogLevel.critical,
    ];
    final level = levels[_rng.nextInt(levels.length)];
    return DebugLog(
      id: 'LOG-${String.fromCharCode(65 + i)}${_rng.nextInt(1000)}',
      level: level,
      module: modules[_rng.nextInt(modules.length)],
      message: messages[_rng.nextInt(messages.length)],
      timestamp: _now.subtract(Duration(minutes: _rng.nextInt(60))),
      stackTrace: _rng.nextBool() ? 'Stack trace available' : null,
    );
  });
}

List<PerformanceMetric> buildMetrics() => [
  PerformanceMetric(
    name: 'Memory Usage',
    value: 145.2,
    unit: 'MB',
    threshold: 200,
    isWarning: false,
  ),
  PerformanceMetric(
    name: 'CPU Load',
    value: 38.5,
    unit: '%',
    threshold: 70,
    isWarning: false,
  ),
  PerformanceMetric(
    name: 'FPS',
    value: 58.2,
    unit: 'fps',
    threshold: 55,
    isWarning: false,
  ),
  PerformanceMetric(
    name: 'Network Latency',
    value: 45.3,
    unit: 'ms',
    threshold: 100,
    isWarning: false,
  ),
  PerformanceMetric(
    name: 'Battery Usage',
    value: 18.7,
    unit: '%/hr',
    threshold: 25,
    isWarning: false,
  ),
  PerformanceMetric(
    name: 'Storage Used',
    value: 2.34,
    unit: 'GB',
    threshold: 4,
    isWarning: false,
  ),
];

SystemInfo buildSystemInfo() => SystemInfo(
  appVersion: '2.1.0',
  buildNumber: '2024.03.07.001',
  platform: 'Flutter (Android, iOS, Web)',
  dartVersion: '3.3.0',
  flutterVersion: '3.19.0',
  buildDate: _now,
  environment: 'DEVELOPMENT',
);
