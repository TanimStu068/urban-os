import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

//  ENUMS & DATA MODELS
enum EventType { system, user, sensor, actuator, rule, analytics, integration }

enum EventCategory {
  startup,
  shutdown,
  update,
  config,
  error,
  warning,
  info,
  success,
  authentication,
  dataSync,
  performance,
  security,
}

enum EventSeverity { trace, debug, info, warning, error, critical }

extension EventTypeX on EventType {
  String get label {
    switch (this) {
      case EventType.system:
        return 'SYSTEM';
      case EventType.user:
        return 'USER';
      case EventType.sensor:
        return 'SENSOR';
      case EventType.actuator:
        return 'ACTUATOR';
      case EventType.rule:
        return 'RULE';
      case EventType.analytics:
        return 'ANALYTICS';
      case EventType.integration:
        return 'INTEGRATION';
    }
  }

  IconData get icon {
    switch (this) {
      case EventType.system:
        return Icons.settings_rounded;
      case EventType.user:
        return Icons.person_rounded;
      case EventType.sensor:
        return Icons.sensors_rounded;
      case EventType.actuator:
        return Icons.toys_rounded;
      case EventType.rule:
        return Icons.rule_rounded;
      case EventType.analytics:
        return Icons.analytics_rounded;
      case EventType.integration:
        return Icons.api_rounded;
    }
  }

  Color get color {
    switch (this) {
      case EventType.system:
        return C.violet;
      case EventType.user:
        return C.cyan;
      case EventType.sensor:
        return C.teal;
      case EventType.actuator:
        return C.lime;
      case EventType.rule:
        return C.yellow;
      case EventType.analytics:
        return C.sky;
      case EventType.integration:
        return C.pink;
    }
  }
}

extension EventSeverityX on EventSeverity {
  String get label {
    switch (this) {
      case EventSeverity.trace:
        return 'TRACE';
      case EventSeverity.debug:
        return 'DEBUG';
      case EventSeverity.info:
        return 'INFO';
      case EventSeverity.warning:
        return 'WARNING';
      case EventSeverity.error:
        return 'ERROR';
      case EventSeverity.critical:
        return 'CRITICAL';
    }
  }

  Color get color {
    switch (this) {
      case EventSeverity.trace:
        return C.muted;
      case EventSeverity.debug:
        return C.cyan;
      case EventSeverity.info:
        return C.teal;
      case EventSeverity.warning:
        return C.amber;
      case EventSeverity.error:
        return C.orange;
      case EventSeverity.critical:
        return C.red;
    }
  }

  IconData get icon {
    switch (this) {
      case EventSeverity.trace:
        return Icons.more_horiz_rounded;
      case EventSeverity.debug:
        return Icons.bug_report_rounded;
      case EventSeverity.info:
        return Icons.info_rounded;
      case EventSeverity.warning:
        return Icons.warning_rounded;
      case EventSeverity.error:
        return Icons.error_rounded;
      case EventSeverity.critical:
        return Icons.priority_high_rounded;
    }
  }
}

class EventLog {
  final String id;
  final String title;
  final String description;
  final EventType type;
  final EventCategory category;
  final EventSeverity severity;
  final String sourceModule;
  final String? userId;
  final String? metadata;
  final DateTime timestamp;
  final int executionTime; // ms
  final bool success;

  EventLog({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.severity,
    required this.sourceModule,
    this.userId,
    this.metadata,
    required this.timestamp,
    this.executionTime = 0,
    this.success = true,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String get formattedTime {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }
}

class EventStatistics {
  final int totalEvents;
  final int eventsToday;
  final int errorCount;
  final Map<EventType, int> byType;
  final Map<EventSeverity, int> bySeverity;
  final double avgExecutionTime;

  EventStatistics({
    required this.totalEvents,
    required this.eventsToday,
    required this.errorCount,
    required this.byType,
    required this.bySeverity,
    required this.avgExecutionTime,
  });
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
final rng = Random(123);

List<EventLog> buildEventLogs() {
  final now = DateTime.now();
  final events = <EventLog>[];

  const systemTitles = [
    'System Startup Initiated',
    'Configuration Reloaded',
    'Database Migration Complete',
    'Cache Invalidated',
    'Memory Cleanup Executed',
    'Service Health Check Passed',
    'Backup Process Started',
  ];

  const sensorTitles = [
    'Sensor Reading Received',
    'Sensor Calibration Required',
    'Sensor Communication Timeout',
    'Anomalous Reading Detected',
    'Data Validation Failed',
    'Sensor Offline',
  ];

  const actuatorTitles = [
    'Actuator Command Executed',
    'Actuator State Changed',
    'Actuator Response Timeout',
    'Actuator Position Locked',
    'Emergency Stop Activated',
  ];

  const ruleTitles = [
    'Rule Engine Evaluation Complete',
    'Automation Rule Triggered',
    'Rule Conflict Detected',
    'Condition Threshold Exceeded',
    'Action Queue Processed',
  ];

  const descriptions = [
    'Operation completed successfully within expected parameters',
    'System encountered a non-critical issue that was auto-recovered',
    'User action triggered system response',
    'Scheduled maintenance task executed',
    'External API response received and processed',
    'Database query executed with results returned',
    'Background job queued for async processing',
    'Cache updated with fresh data',
    'Performance metrics logged for analysis',
  ];

  for (int i = 0; i < 35; i++) {
    final type = EventType.values[rng.nextInt(EventType.values.length)];
    final severity =
        EventSeverity.values[rng.nextInt(EventSeverity.values.length)];

    String title = '';
    if (type == EventType.system) {
      title = systemTitles[rng.nextInt(systemTitles.length)];
    } else if (type == EventType.sensor) {
      title = sensorTitles[rng.nextInt(sensorTitles.length)];
    } else if (type == EventType.actuator) {
      title = actuatorTitles[rng.nextInt(actuatorTitles.length)];
    } else if (type == EventType.rule) {
      title = ruleTitles[rng.nextInt(ruleTitles.length)];
    } else {
      title = '${type.label} Event Processed';
    }

    events.add(
      EventLog(
        id: 'EVT-${DateTime.now().millisecondsSinceEpoch}-$i',
        title: title,
        description: descriptions[rng.nextInt(descriptions.length)],
        type: type,
        category:
            EventCategory.values[rng.nextInt(EventCategory.values.length)],
        severity: severity,
        sourceModule: getModuleName(type),
        userId: rng.nextBool() ? 'USR-${rng.nextInt(999)}' : null,
        metadata: rng.nextBool()
            ? '{"duration": ${rng.nextInt(5000)}ms, "status": "ok"}'
            : null,
        timestamp: now.subtract(
          Duration(minutes: rng.nextInt(480), seconds: rng.nextInt(60)),
        ),
        executionTime: rng.nextInt(5000),
        success:
            severity != EventSeverity.error &&
            severity != EventSeverity.critical,
      ),
    );
  }

  events.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return events;
}

String getModuleName(EventType type) {
  const modules = {
    EventType.system: [
      'Core Engine',
      'Service Manager',
      'Memory Manager',
      'Configuration Service',
      'Database Layer',
    ],
    EventType.user: [
      'Authentication Service',
      'User Management',
      'Session Manager',
      'Audit Logger',
      'Permission Handler',
    ],
    EventType.sensor: [
      'Sensor Reader',
      'Data Processor',
      'Calibration Module',
      'Validation Engine',
      'Data Storage',
    ],
    EventType.actuator: [
      'Command Executor',
      'State Manager',
      'Control Interface',
      'Feedback Handler',
      'Safety Monitor',
    ],
    EventType.rule: [
      'Rule Engine',
      'Condition Evaluator',
      'Action Executor',
      'Conflict Resolver',
      'Scheduler',
    ],
    EventType.analytics: [
      'Analytics Engine',
      'Data Aggregator',
      'Report Generator',
      'Prediction Model',
      'Metrics Collector',
    ],
    EventType.integration: [
      'API Gateway',
      'Message Queue',
      'Data Transformer',
      'External Service',
      'Webhook Handler',
    ],
  };

  final typeModules = modules[type] ?? ['Unknown Module'];
  return typeModules[rng.nextInt(typeModules.length)];
}

EventStatistics buildStatistics(List<EventLog> events) {
  final byType = <EventType, int>{};
  final bySeverity = <EventSeverity, int>{};

  for (final event in events) {
    byType[event.type] = (byType[event.type] ?? 0) + 1;
    bySeverity[event.severity] = (bySeverity[event.severity] ?? 0) + 1;
  }

  final today = DateTime.now();
  final todayEvents = events.where((e) => e.timestamp.day == today.day).length;
  final errorCount = events
      .where(
        (e) =>
            e.severity == EventSeverity.error ||
            e.severity == EventSeverity.critical,
      )
      .length;
  final avgExecTime = events.isNotEmpty
      ? events.fold(0, (sum, e) => sum + e.executionTime) / events.length
      : 0.0;

  return EventStatistics(
    totalEvents: events.length,
    eventsToday: todayEvents,
    errorCount: errorCount,
    byType: byType,
    bySeverity: bySeverity,
    avgExecutionTime: avgExecTime,
  );
}
