/// Log levels for events
enum EventLogLevel { info, warning, error, debug, trace }

/// Represents a system event log entry
///
/// Events track all major system activities, state changes,
/// and user actions throughout the UrbanOS system
class EventLog {
  /// Unique identifier for the event
  final String id;

  /// Event message/description
  final String message;

  /// When the event occurred
  final DateTime timestamp;

  /// Log level (info, warning, error, debug, trace)
  final EventLogLevel level;

  /// Source component that generated the event (e.g., "SensorService", "AuthController")
  final String? source;

  /// Category of the event (e.g., "sensor_data", "system_health", "user_action")
  final String? category;

  /// Additional structured data associated with the event
  final Map<String, dynamic>? metadata;

  /// ID of the user who triggered this event (if applicable)
  final String? userId;

  /// ID of the resource affected by this event (sensor, actuator, district, etc)
  final String? resourceId;

  /// Stack trace if event is an error
  final String? stackTrace;

  const EventLog({
    required this.id,
    required this.message,
    required this.timestamp,
    this.level = EventLogLevel.info,
    this.source,
    this.category,
    this.metadata,
    this.userId,
    this.resourceId,
    this.stackTrace,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'level': level.toString().split('.').last,
      'source': source,
      'category': category,
      'metadata': metadata,
      'userId': userId,
      'resourceId': resourceId,
      'stackTrace': stackTrace,
    };
  }

  /// Create from JSON
  factory EventLog.fromJson(Map<String, dynamic> json) {
    return EventLog(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      level: _logLevelFromString(json['level']),
      source: json['source'],
      category: json['category'],
      metadata: json['metadata'] as Map<String, dynamic>?,
      userId: json['userId'],
      resourceId: json['resourceId'],
      stackTrace: json['stackTrace'],
    );
  }

  @override
  String toString() =>
      'EventLog($id, [$level] $message at ${timestamp.hour}:${timestamp.minute})';
}

/// Helper to parse EventLogLevel from string
EventLogLevel _logLevelFromString(String? value) {
  if (value == null) return EventLogLevel.info;
  for (final level in EventLogLevel.values) {
    if (level.toString().split('.').last == value) return level;
  }
  return EventLogLevel.info;
}
