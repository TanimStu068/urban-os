import 'package:urban_os/models/automation/rule_priority.dart';

/// AlertSeverity levels for alerts
enum AlertSeverity {
  /// Informational alert
  info,

  /// Warning alert requires attention
  warning,

  /// Critical alert requires immediate action
  critical,

  /// Emergency alert - system emergency
  emergency,
}

/// Represents a system alert log entry
///
/// Alerts are critical events that require human attention or intervention
class AlertLog {
  /// Unique identifier for the alert
  final String id;

  /// Alert title/subject
  final String title;

  /// Detailed description of the alert
  final String description;

  /// Severity/priority level
  final RulePriority severity;

  /// When the alert was generated
  final DateTime timestamp;

  /// When the alert was created (distinct from occurrence time)
  final DateTime createdAt;

  /// User ID who acknowledged/resolved the alert
  final String? resolvedByUserId;

  /// When the alert was resolved
  final DateTime? resolvedAt;

  /// Resolution comments/notes
  final String? resolutionNotes;

  /// ID of the resource that triggered the alert (sensor, actuator, district, etc)
  final String? resourceId;

  /// Type of resource (sensor, actuator, building, road, district)
  final String? resourceType;

  /// ID of the automation rule that generated this alert (if applicable)
  final String? ruleId;

  /// Whether the alert is still active/unresolved
  final bool isActive;

  /// Number of times this same alert has been triggered
  final int occurrenceCount;

  const AlertLog({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.timestamp,
    required this.createdAt,
    this.resolvedByUserId,
    this.resolvedAt,
    this.resolutionNotes,
    this.resourceId,
    this.resourceType,
    this.ruleId,
    this.isActive = true,
    this.occurrenceCount = 1,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity': severity.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'resolvedByUserId': resolvedByUserId,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'resolutionNotes': resolutionNotes,
      'resourceId': resourceId,
      'resourceType': resourceType,
      'ruleId': ruleId,
      'isActive': isActive,
      'occurrenceCount': occurrenceCount,
    };
  }

  /// Create from JSON
  factory AlertLog.fromJson(Map<String, dynamic> json) {
    return AlertLog(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      severity: _priorityFromString(json['severity']),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      resolvedByUserId: json['resolvedByUserId'],
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'])
          : null,
      resolutionNotes: json['resolutionNotes'],
      resourceId: json['resourceId'],
      resourceType: json['resourceType'],
      ruleId: json['ruleId'],
      isActive: json['isActive'] ?? true,
      occurrenceCount: json['occurrenceCount'] ?? 1,
    );
  }

  /// Get time since alert was generated
  Duration get timeSinceCreation => DateTime.now().difference(createdAt);

  /// Get time until resolved (if resolved)
  Duration? get resolutionTime {
    if (resolvedAt == null) return null;
    return resolvedAt!.difference(createdAt);
  }

  /// Check if alert is critical/requires immediate attention
  bool get isCritical =>
      severity == RulePriority.critical || severity == RulePriority.high;

  /// Check if alert is old/stale (older than 1 day)
  bool get isStale => timeSinceCreation.inHours > 24 && isActive;

  @override
  String toString() =>
      'AlertLog($id, $title [${severity.label}] - '
      '${isActive ? "ACTIVE" : "RESOLVED"})';
}

/// Helper to parse RulePriority from string
RulePriority _priorityFromString(String? value) {
  if (value == null) return RulePriority.medium;
  final severityMap = {
    'info': RulePriority.low,
    'warning': RulePriority.medium,
    'error': RulePriority.high,
    'critical': RulePriority.critical,
    'emergency': RulePriority.critical,
  };
  return severityMap[value] ?? RulePriority.medium;
}
