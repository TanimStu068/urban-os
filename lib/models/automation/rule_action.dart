import 'package:urban_os/models/actuator/actuator_state.dart';

/// Types of actions that can be performed by automation rules
enum ActionType {
  /// Change the state of an actuator
  setActuatorState,

  /// Set a numeric value for an actuator (dimming, speed, etc)
  setActuatorValue,

  /// Send a notification/alert
  sendNotification,

  /// Log an event in the system
  logEvent,

  /// Trigger another automation rule
  triggerRule,

  /// Execute a custom script/webhook
  executeWebhook,
}

/// Extension for ActionType utilities
extension ActionTypeExtension on ActionType {
  /// Get human-readable action name
  String get displayName {
    const nameMap = {
      ActionType.setActuatorState: 'Set Actuator State',
      ActionType.setActuatorValue: 'Set Actuator Value',
      ActionType.sendNotification: 'Send Notification',
      ActionType.logEvent: 'Log Event',
      ActionType.triggerRule: 'Trigger Rule',
      ActionType.executeWebhook: 'Execute Webhook',
    };
    return nameMap[this] ?? 'Unknown Action';
  }
}

/// Represents an action to be executed when a rule's conditions are met
///
/// Actions are the THEN part of an IF-THEN rule
class RuleAction {
  /// Unique identifier for the action
  final String id;

  /// Type of action to perform
  final ActionType type;

  /// ID of the target actuator (for setActuatorState/setActuatorValue)
  final String? actuatorId;

  /// Target state for the actuator
  final ActuatorState? targetState;

  /// Target value (0-100) for actuators that support gradual control
  final double? targetValue;

  /// Duration for the action (how long to keep the command active)
  final Duration? duration;

  /// Optional delay before executing the action
  final Duration? delay;

  /// Notification message (for sendNotification action)
  final String? notificationMessage;

  /// Notification severity (info, warning, alert, critical)
  final String? notificationSeverity;

  /// Event description (for logEvent action)
  final String? eventDescription;

  /// Custom webhook URL or script identifier
  final String? webhookUrl;

  /// Custom parameters/payload for webhook
  final Map<String, dynamic>? webhookPayload;

  /// Rule ID to trigger (for triggerRule action)
  final String? triggerRuleId;

  /// Description of what this action does
  final String? description;

  /// Whether this action should execute
  final bool isEnabled;

  const RuleAction({
    required this.id,
    required this.type,
    this.actuatorId,
    this.targetState,
    this.targetValue,
    this.duration,
    this.delay,
    this.notificationMessage,
    this.notificationSeverity,
    this.eventDescription,
    this.webhookUrl,
    this.webhookPayload,
    this.triggerRuleId,
    this.description,
    this.isEnabled = true,
  });

  /// Create a copy with optional field overrides
  RuleAction copyWith({
    String? id,
    ActionType? type,
    String? actuatorId,
    ActuatorState? targetState,
    double? targetValue,
    Duration? duration,
    Duration? delay,
    String? notificationMessage,
    String? notificationSeverity,
    String? eventDescription,
    String? webhookUrl,
    Map<String, dynamic>? webhookPayload,
    String? triggerRuleId,
    String? description,
    bool? isEnabled,
  }) {
    return RuleAction(
      id: id ?? this.id,
      type: type ?? this.type,
      actuatorId: actuatorId ?? this.actuatorId,
      targetState: targetState ?? this.targetState,
      targetValue: targetValue ?? this.targetValue,
      duration: duration ?? this.duration,
      delay: delay ?? this.delay,
      notificationMessage: notificationMessage ?? this.notificationMessage,
      notificationSeverity: notificationSeverity ?? this.notificationSeverity,
      eventDescription: eventDescription ?? this.eventDescription,
      webhookUrl: webhookUrl ?? this.webhookUrl,
      webhookPayload: webhookPayload ?? this.webhookPayload,
      triggerRuleId: triggerRuleId ?? this.triggerRuleId,
      description: description ?? this.description,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'actuatorId': actuatorId,
      'targetState': targetState?.toString().split('.').last,
      'targetValue': targetValue,
      'duration': duration?.inSeconds,
      'delay': delay?.inSeconds,
      'notificationMessage': notificationMessage,
      'notificationSeverity': notificationSeverity,
      'eventDescription': eventDescription,
      'webhookUrl': webhookUrl,
      'webhookPayload': webhookPayload,
      'triggerRuleId': triggerRuleId,
      'description': description,
      'isEnabled': isEnabled,
    };
  }

  /// Create from JSON
  factory RuleAction.fromJson(Map<String, dynamic> json) {
    return RuleAction(
      id: json['id'] ?? '',
      type: _actionTypeFromString(json['type']),
      actuatorId: json['actuatorId'],
      targetState: json['targetState'] != null
          ? _parseActuatorState(json['targetState'])
          : null,
      targetValue: (json['targetValue'] as num?)?.toDouble(),
      duration: json['duration'] != null
          ? Duration(seconds: json['duration'] as int)
          : null,
      delay: json['delay'] != null
          ? Duration(seconds: json['delay'] as int)
          : null,
      notificationMessage: json['notificationMessage'],
      notificationSeverity: json['notificationSeverity'],
      eventDescription: json['eventDescription'],
      webhookUrl: json['webhookUrl'],
      webhookPayload: json['webhookPayload'] != null
          ? Map<String, dynamic>.from(json['webhookPayload'] as Map)
          : null,
      triggerRuleId: json['triggerRuleId'],
      description: json['description'],
      isEnabled: json['isEnabled'] ?? true,
    );
  }

  /// Get human-readable action description
  String getReadableDescription() {
    switch (type) {
      case ActionType.setActuatorState:
        return 'Set $actuatorId to $targetState';
      case ActionType.setActuatorValue:
        return 'Set $actuatorId to ${targetValue?.toStringAsFixed(1)}%';
      case ActionType.sendNotification:
        return 'Send Notification: $notificationMessage';
      case ActionType.logEvent:
        return 'Log Event: $eventDescription';
      case ActionType.triggerRule:
        return 'Trigger Rule: $triggerRuleId';
      case ActionType.executeWebhook:
        return 'Execute Webhook: $webhookUrl';
    }
  }

  @override
  String toString() => 'Action: ${type.displayName}';
}

/// Helper to parse ActionType from string
ActionType _actionTypeFromString(String? value) {
  if (value == null) return ActionType.setActuatorState;
  for (final type in ActionType.values) {
    if (type.toString().split('.').last == value) return type;
  }
  return ActionType.setActuatorState;
}

/// Helper to parse ActuatorState from string (handles both enum names and on/off)
ActuatorState? _parseActuatorState(dynamic value) {
  if (value == null) return null;

  final strValue = value.toString().toLowerCase();

  // Handle simple on/off values
  if (strValue == 'on') return ActuatorState.enabled;
  if (strValue == 'off') return ActuatorState.disabled;

  // Handle enum names
  for (final state in ActuatorState.values) {
    if (state.toString().split('.').last == strValue) return state;
  }

  return null;
}

/// Helper to parse ActuatorState from string (re-use from actuator_state.dart)
ActuatorState? _actuatorStateFromString(String? value) {
  if (value == null) return null;
  for (final state in ActuatorState.values) {
    if (state.toString().split('.').last == value) return state;
  }
  return null;
}
