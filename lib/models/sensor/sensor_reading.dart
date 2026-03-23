/// Represents a single measurement from a sensor at a specific point in time
class SensorReading {
  /// The measured value
  final double value;

  /// Timestamp when the reading was taken
  final DateTime timestamp;

  /// Unit of measurement (e.g., "°C", "km/h", "ppm", "%")
  final String? unit;

  /// Quality indicator of the reading (0-100%)
  final int? quality;

  /// Raw value if different from processed value
  final double? rawValue;

  /// Whether this reading triggered an alarm
  final bool isAlert;

  const SensorReading({
    required this.value,
    required this.timestamp,
    this.unit,
    this.quality = 100,
    this.rawValue,
    this.isAlert = false,
  });

  /// Create a copy with optional field overrides
  SensorReading copyWith({
    double? value,
    DateTime? timestamp,
    String? unit,
    int? quality,
    double? rawValue,
    bool? isAlert,
  }) {
    return SensorReading(
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      unit: unit ?? this.unit,
      quality: quality ?? this.quality,
      rawValue: rawValue ?? this.rawValue,
      isAlert: isAlert ?? this.isAlert,
    );
  }

  /// Convert to JSON for API serialization
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      'unit': unit,
      'quality': quality,
      'rawValue': rawValue,
      'isAlert': isAlert,
    };
  }

  /// Create from JSON response
  factory SensorReading.fromJson(Map<String, dynamic> json) {
    // Handle value which could be num or bool
    double value = 0.0;
    final jsonValue = json['value'];
    if (jsonValue is num) {
      value = jsonValue.toDouble();
    } else if (jsonValue is bool) {
      value = jsonValue ? 1.0 : 0.0;
    }

    return SensorReading(
      value: value,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      unit: json['unit'],
      quality: json['quality'] ?? 100,
      rawValue: (json['rawValue'] as num?)?.toDouble(),
      isAlert: json['isAlert'] ?? false,
    );
  }

  /// Get time elapsed since reading was taken
  Duration get timeSinceReading => DateTime.now().difference(timestamp);

  /// Check if reading is stale (older than 5 minutes)
  bool get isStale => timeSinceReading.inMinutes > 5;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorReading &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          timestamp == other.timestamp;

  @override
  int get hashCode => value.hashCode ^ timestamp.hashCode;

  @override
  String toString() =>
      'SensorReading(value: $value$unit, timestamp: ${timestamp.hour}:${timestamp.minute}, alert: $isAlert)';
}
