/// Represents a system/operational log entry
///
/// SystemLogs record operational metrics, performance data,
/// and system state changes for diagnostics and analytics
class SystemLog {
  /// Unique identifier for the log entry
  final String id;

  /// Name/topic of what was logged (e.g., "API_CALL", "DATABASE_QUERY", "MEMORY_USAGE")
  final String topic;

  /// Short message describing the log entry
  final String message;

  /// When the log entry was created
  final DateTime timestamp;

  /// Duration of the operation (if applicable) in milliseconds
  final int? durationMs;

  /// Numeric value being logged (e.g., response time, memory usage, CPU %, etc)
  final double? value;

  /// Unit of measurement for the value (ms, MB, %, requests/sec, etc)
  final String? unit;

  /// Status of the operation (success, failed, timeout, etc)
  final String? status;

  /// Component that generated this log (e.g., "AuthService", "SensorDataProcessor")
  final String? component;

  /// Additional contextual data
  final Map<String, dynamic>? data;

  /// Whether this log represents normal operation or anomaly
  final bool isAnomaly;

  /// Performance rating: 1-5 (5 is best, used for slow operations)
  final int? performanceRating;

  const SystemLog({
    required this.id,
    required this.topic,
    required this.message,
    required this.timestamp,
    this.durationMs,
    this.value,
    this.unit,
    this.status,
    this.component,
    this.data,
    this.isAnomaly = false,
    this.performanceRating,
  });

  /// Create a copy with optional field overrides
  SystemLog copyWith({
    String? id,
    String? topic,
    String? message,
    DateTime? timestamp,
    int? durationMs,
    double? value,
    String? unit,
    String? status,
    String? component,
    Map<String, dynamic>? data,
    bool? isAnomaly,
    int? performanceRating,
  }) {
    return SystemLog(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      durationMs: durationMs ?? this.durationMs,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      component: component ?? this.component,
      data: data ?? this.data,
      isAnomaly: isAnomaly ?? this.isAnomaly,
      performanceRating: performanceRating ?? this.performanceRating,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'durationMs': durationMs,
      'value': value,
      'unit': unit,
      'status': status,
      'component': component,
      'data': data,
      'isAnomaly': isAnomaly,
      'performanceRating': performanceRating,
    };
  }

  /// Create from JSON
  factory SystemLog.fromJson(Map<String, dynamic> json) {
    return SystemLog(
      id: json['id'] ?? '',
      topic: json['topic'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      durationMs: json['durationMs'],
      value: (json['value'] as num?)?.toDouble(),
      unit: json['unit'],
      status: json['status'],
      component: json['component'],
      data: json['data'] as Map<String, dynamic>?,
      isAnomaly: json['isAnomaly'] ?? false,
      performanceRating: json['performanceRating'],
    );
  }

  /// Get performance description based on rating
  String get performanceDescription {
    if (performanceRating == null) return 'N/A';
    switch (performanceRating) {
      case 1:
        return 'Very Slow';
      case 2:
        return 'Slow';
      case 3:
        return 'Normal';
      case 4:
        return 'Fast';
      case 5:
        return 'Very Fast';
      default:
        return 'Unknown';
    }
  }

  /// Check if this is a slow operation (rating < 3)
  bool get isSlow => performanceRating != null && performanceRating! < 3;

  /// Get formatted value with unit
  String get formattedValue {
    if (value == null) return '';
    if (unit == null) return value.toString();
    return '$value $unit';
  }

  @override
  String toString() =>
      'SystemLog($topic, ${status ?? "n/a"}, $message, '
      '${durationMs != null ? "${durationMs}ms" : ""})';
}
