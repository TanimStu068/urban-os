import 'package:urban_os/models/automation/rule_action.dart';
import 'package:urban_os/models/automation/rule_condition.dart';
import 'package:urban_os/models/automation/rule_priority.dart';

/// Represents an automated rule in the UrbanOS system
///
/// Rules are the core of the automation engine:
/// IF (conditions are met) THEN (execute actions)
///
/// Rules can be simple (single condition) or complex (multiple conditions with AND/OR logic)
class AutomationRule {
  /// Unique identifier for the rule
  final String id;

  /// Human-readable name (e.g., "Traffic Congestion Relief")
  final String name;

  /// Optional description of what this rule does
  final String? description;

  /// Conditions that must be satisfied for the rule to trigger
  final List<RuleCondition> conditions;

  /// Actions to execute when conditions are met
  final List<RuleAction> actions;

  /// Priority level (determines execution order and override behavior)
  final RulePriority priority;

  /// Whether the rule is currently enabled
  final bool isEnabled;

  /// Logic for combining multiple conditions: 'AND' (all must be true) or 'OR' (at least one)
  final String conditionLogic;

  /// Optional tag for categorizing rules (e.g., "traffic", "energy", "safety")
  final RuleCategory? category;

  /// When the rule was created
  final DateTime? createdDate;

  /// When the rule was last modified
  final DateTime? modifiedDate;

  /// ID of the user who created this rule
  final String? createdBy;

  /// Count of times this rule has been triggered
  final int triggerCount;

  /// When the rule was last triggered
  final DateTime? lastTriggeredDate;

  /// Cooldown period - minimum time between rule executions
  final Duration? cooldownPeriod;

  /// Time window in which the rule is valid (e.g., only during business hours)
  final TimeWindow? timeWindow;

  /// Optional dependencies on other rules (if these rules are critical, don't run this)
  final List<String>? dependentRuleIds;

  /// District/Zone where this rule applies
  final String district;

  /// Whether this is a system rule (cannot be deleted)
  final bool isSystem;

  /// Historical trigger counts (e.g., last 7 days)
  final List<int> triggerHistory;

  const AutomationRule({
    required this.id,
    required this.name,
    required this.conditions,
    required this.actions,
    required this.priority,
    this.description,
    this.isEnabled = true,
    this.conditionLogic = 'AND',
    this.category,
    this.createdDate,
    this.modifiedDate,
    this.createdBy,
    this.triggerCount = 0,
    this.lastTriggeredDate,
    this.cooldownPeriod,
    this.timeWindow,
    this.dependentRuleIds,
    this.district = 'All Districts',
    this.isSystem = false,
    this.triggerHistory = const [0, 0, 0, 0, 0, 0, 0],
  });

  /// Create a copy with optional field overrides
  AutomationRule copyWith({
    String? id,
    String? name,
    String? description,
    List<RuleCondition>? conditions,
    List<RuleAction>? actions,
    RulePriority? priority,
    bool? isEnabled,
    String? conditionLogic,
    // String? category,
    RuleCategory? category,
    DateTime? createdDate,
    DateTime? modifiedDate,
    String? createdBy,
    int? triggerCount,
    DateTime? lastTriggeredDate,
    Duration? cooldownPeriod,
    TimeWindow? timeWindow,
    List<String>? dependentRuleIds,
    String? district,
    bool? isSystem,
    List<int>? triggerHistory,
  }) {
    return AutomationRule(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      conditions: conditions ?? this.conditions,
      actions: actions ?? this.actions,
      priority: priority ?? this.priority,
      isEnabled: isEnabled ?? this.isEnabled,
      conditionLogic: conditionLogic ?? this.conditionLogic,
      category: category ?? this.category,
      createdDate: createdDate ?? this.createdDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      createdBy: createdBy ?? this.createdBy,
      triggerCount: triggerCount ?? this.triggerCount,
      lastTriggeredDate: lastTriggeredDate ?? this.lastTriggeredDate,
      cooldownPeriod: cooldownPeriod ?? this.cooldownPeriod,
      timeWindow: timeWindow ?? this.timeWindow,
      dependentRuleIds: dependentRuleIds ?? this.dependentRuleIds,
      district: district ?? this.district,
      isSystem: isSystem ?? this.isSystem,
      triggerHistory: triggerHistory ?? this.triggerHistory,
    );
  }

  /// Get the current status of the rule
  RuleStatus get status {
    if (!isEnabled) return RuleStatus.inactive;
    if (lastTriggeredDate != null) {
      final timeSinceLastTrigger = DateTime.now().difference(
        lastTriggeredDate!,
      );
      if (timeSinceLastTrigger.inMinutes < 5) {
        return RuleStatus.triggered;
      }
    }
    return RuleStatus.active;
  }

  /// Get last triggered time as formatted string
  String? get lastTriggered {
    if (lastTriggeredDate == null) return null;
    final now = DateTime.now();
    final diff = now.difference(lastTriggeredDate!);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return 'Long ago';
  }

  /// Get last modified time as formatted string
  String? get lastModified {
    if (modifiedDate == null) return null;
    final now = DateTime.now();
    final diff = now.difference(modifiedDate!);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return 'Long ago';
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'conditions': conditions.map((c) => c.toJson()).toList(),
      'actions': actions.map((a) => a.toJson()).toList(),
      'priority': priority.toString().split('.').last,
      'isEnabled': isEnabled,
      'conditionLogic': conditionLogic,
      'category': category?.toString().split('.').last,
      'createdDate': createdDate?.toIso8601String(),
      'modifiedDate': modifiedDate?.toIso8601String(),
      'createdBy': createdBy,
      'triggerCount': triggerCount,
      'lastTriggeredDate': lastTriggeredDate?.toIso8601String(),
      'cooldownPeriod': cooldownPeriod?.inSeconds,
      'timeWindow': timeWindow?.toJson(),
      'dependentRuleIds': dependentRuleIds,
      'district': district,
      'isSystem': isSystem,
      'triggerHistory': triggerHistory,
    };
  }

  /// Create from JSON
  factory AutomationRule.fromJson(Map<String, dynamic> json) {
    return AutomationRule(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      conditions: ((json['conditions'] ?? []) as List)
          .map((c) => RuleCondition.fromJson(c as Map<String, dynamic>))
          .toList(),
      actions: ((json['actions'] ?? []) as List)
          .map((a) => RuleAction.fromJson(a as Map<String, dynamic>))
          .toList(),
      priority: _priorityFromString(json['priority']),
      isEnabled: json['isEnabled'] ?? true,
      conditionLogic: json['conditionLogic'] ?? 'AND',
      category: _categoryFromString(json['category']),
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      modifiedDate: json['modifiedDate'] != null
          ? DateTime.parse(json['modifiedDate'])
          : null,
      createdBy: json['createdBy'],
      triggerCount: json['triggerCount'] ?? 0,
      lastTriggeredDate: json['lastTriggeredDate'] != null
          ? DateTime.parse(json['lastTriggeredDate'])
          : null,
      cooldownPeriod: json['cooldownPeriod'] != null
          ? Duration(seconds: json['cooldownPeriod'] as int)
          : null,
      timeWindow: json['timeWindow'] != null
          ? TimeWindow.fromJson(json['timeWindow'] as Map<String, dynamic>)
          : null,
      dependentRuleIds: json['dependentRuleIds'] != null
          ? List<String>.from(json['dependentRuleIds'] as List)
          : null,
      district: json['district'] ?? 'All Districts',
      isSystem: json['isSystem'] ?? false,
      triggerHistory: json['triggerHistory'] != null
          ? List<int>.from(
              (json['triggerHistory'] as List).map((x) => (x as num).toInt()),
            )
          : [0, 0, 0, 0, 0, 0, 0],
    );
  }

  /// Check if conditions are satisfied
  bool areConditionsSatisfied(Map<String, double> sensorValues) {
    if (conditions.isEmpty) return true;

    final conditionResults = conditions.map((cond) {
      final sensorValue = sensorValues[cond.sensorId];
      if (sensorValue == null) return false; // Sensor not found
      return cond.isSatisfied(sensorValue);
    }).toList();

    if (conditionLogic.toUpperCase() == 'AND') {
      return conditionResults.every((result) => result);
    } else {
      // OR logic
      return conditionResults.any((result) => result);
    }
  }

  /// Check if rule can execute (enabled, not on cooldown, respects time window)
  bool canExecute() {
    if (!isEnabled) return false;

    // Check time window if set
    if (timeWindow != null && !timeWindow!.isInWindow(DateTime.now())) {
      return false;
    }

    // Check cooldown period
    if (cooldownPeriod != null && lastTriggeredDate != null) {
      final timeSinceLastTrigger = DateTime.now().difference(
        lastTriggeredDate!,
      );
      if (timeSinceLastTrigger < cooldownPeriod!) {
        return false;
      }
    }

    return true;
  }

  /// Get human-readable summary of the rule
  String getSummary() {
    final condStr = conditions.isEmpty
        ? 'No conditions'
        : conditions.length == 1
        ? '1 condition'
        : '${conditions.length} conditions';
    final actionStr = actions.isEmpty
        ? 'No actions'
        : actions.length == 1
        ? '1 action'
        : '${actions.length} actions';
    return '$condStr, $actionStr, Priority: ${priority.label}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AutomationRule &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'AutomationRule(id: $id, name: $name, enabled: $isEnabled, '
      'conditions: ${conditions.length}, actions: ${actions.length})';
}

/// Represents a time window for rule execution (e.g., business hours)
class TimeWindow {
  /// Hour when the window starts (0-23)
  final int startHour;

  /// Hour when the window ends (0-23)
  final int endHour;

  /// Days of week when this window is active (0=Monday, 6=Sunday)
  final List<int>? activeDays;

  const TimeWindow({
    required this.startHour,
    required this.endHour,
    this.activeDays,
  });

  /// Check if current time is within the window
  bool isInWindow(DateTime dateTime) {
    final hour = dateTime.hour;

    // Check if time is within hour range
    final inTimeRange = startHour <= endHour
        ? hour >= startHour && hour < endHour
        : hour >= startHour || hour < endHour;

    if (!inTimeRange) return false;

    // Check if day is active (if specified)
    if (activeDays != null) {
      final weekday = dateTime.weekday - 1; // Convert to 0-6 (Monday=0)
      return activeDays!.contains(weekday);
    }

    return true;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'startHour': startHour,
      'endHour': endHour,
      'activeDays': activeDays,
    };
  }

  /// Create from JSON
  factory TimeWindow.fromJson(Map<String, dynamic> json) {
    return TimeWindow(
      startHour: json['startHour'] ?? 0,
      endHour: json['endHour'] ?? 23,
      activeDays: json['activeDays'] != null
          ? List<int>.from(json['activeDays'] as List)
          : null,
    );
  }

  @override
  String toString() =>
      'TimeWindow(${startHour.toString().padLeft(2, '0')}:00 - '
      '${endHour.toString().padLeft(2, '0')}:00)';
}

/// Helper to parse RulePriority from string
RulePriority _priorityFromString(String? value) {
  if (value == null) return RulePriority.medium;
  for (final priority in RulePriority.values) {
    if (priority.toString().split('.').last == value) return priority;
  }
  return RulePriority.medium;
}

/// Helper to parse RuleCategory from string
RuleCategory? _categoryFromString(String? value) {
  if (value == null) return null;
  for (final category in RuleCategory.values) {
    if (category.toString().split('.').last == value) return category;
  }
  return null;
}
