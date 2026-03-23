import 'dart:async';
import 'package:urban_os/loader/mock_data_loader.dart';
import 'package:urban_os/models/actuator/actuator_model.dart';
import 'package:urban_os/models/actuator/actuator_state.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/automation/rule_action.dart';
import 'package:collection/collection.dart';

/// Singleton Automation Engine
class AutomationEngine {
  AutomationEngine._privateConstructor();
  static final AutomationEngine instance =
      AutomationEngine._privateConstructor();

  final List<AutomationRule> _rules = [];
  final List<ActuatorModel> _actuators = [];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    final loader = MockDataLoader();

    // Load actuators from mock data
    _actuators.clear();
    final loadedActuators = await loader.loadActuators();
    _actuators.addAll(loadedActuators);
    print('[AutomationEngine] Loaded ${_actuators.length} actuators.');

    // Load automation rules from mock data
    _rules.clear();
    final loadedRules = await loader.loadAutomationRules();
    _rules.addAll(loadedRules);
    print('[AutomationEngine] Loaded ${_rules.length} automation rules.');

    _initialized = true;
  }

  List<AutomationRule> getRules() => List.unmodifiable(_rules);
  List<ActuatorModel> getActuators() => List.unmodifiable(_actuators);

  AutomationRule? getRuleById(String id) =>
      _rules.firstWhereOrNull((r) => r.id == id);
  ActuatorModel? getActuatorById(String id) =>
      _actuators.firstWhereOrNull((a) => a.id == id);

  /// Simulate rule evaluation with given sensor values
  bool simulateRule(String ruleId, Map<String, double> sensorValues) {
    final rule = getRuleById(ruleId);
    if (rule == null) return false;

    final conditionsMet = rule.areConditionsSatisfied(sensorValues);
    final canExecute = rule.canExecute();

    print(
      '[Simulation] Rule: ${rule.name}, Conditions Met: $conditionsMet, Can Execute: $canExecute',
    );
    return conditionsMet && canExecute;
  }

  /// Execute all rules based on current sensor data
  Future<void> executeAllRules(Map<String, double> sensorValues) async {
    for (final rule in _rules) {
      if (rule.areConditionsSatisfied(sensorValues) && rule.canExecute()) {
        await _executeRuleActions(rule);
        _updateRuleTrigger(rule);
      }
    }
  }

  // ─────────────── Internal helpers ───────────────
  Future<void> _executeRuleActions(AutomationRule rule) async {
    for (final action in rule.actions) {
      if (!action.isEnabled) continue;

      switch (action.type) {
        case ActionType.setActuatorState:
          _executeSetActuatorState(action);
          break;
        case ActionType.setActuatorValue:
          _executeSetActuatorValue(action);
          break;
        case ActionType.sendNotification:
          _sendNotification(action);
          break;
        case ActionType.logEvent:
          _logEvent(action);
          break;
        case ActionType.triggerRule:
          await _triggerOtherRule(action);
          break;
        case ActionType.executeWebhook:
          _executeWebhook(action);
          break;
      }
    }
  }

  void _executeSetActuatorState(RuleAction action) {
    final actuator = getActuatorById(action.actuatorId ?? '');
    if (actuator == null) return;

    final newState = action.targetState ?? actuator.state;
    print(
      '[Action] Setting actuator "${actuator.name}" state to ${newState.displayName}',
    );
    // Simulate actuator state update
    actuator.copyWith(state: newState);
  }

  void _executeSetActuatorValue(RuleAction action) {
    final actuator = getActuatorById(action.actuatorId ?? '');
    if (actuator == null || action.targetValue == null) return;

    print(
      '[Action] Setting actuator "${actuator.name}" value to ${action.targetValue}',
    );
    // Simulate actuator value update
    actuator.copyWith(currentValue: action.targetValue);
  }

  void _sendNotification(RuleAction action) {
    print(
      '[Notification] ${action.notificationSeverity ?? 'INFO'}: ${action.notificationMessage ?? ''}',
    );
  }

  void _logEvent(RuleAction action) {
    print('[LogEvent] ${action.eventDescription ?? 'No description'}');
  }

  Future<void> _triggerOtherRule(RuleAction action) async {
    final targetRule = getRuleById(action.triggerRuleId ?? '');
    if (targetRule == null) return;
    print('[Trigger] Executing triggered rule: ${targetRule.name}');
    // Simulate trigger recursively
    await _executeRuleActions(targetRule);
  }

  void _executeWebhook(RuleAction action) {
    print('[Webhook] Executing ${action.webhookUrl ?? 'Unknown URL'}');
    print('[Webhook] Payload: ${action.webhookPayload ?? {}}');
  }

  void _updateRuleTrigger(AutomationRule rule) {
    final index = _rules.indexWhere((r) => r.id == rule.id);
    if (index == -1) return;

    final updatedRule = rule.copyWith(
      triggerCount: rule.triggerCount + 1,
      lastTriggeredDate: DateTime.now(),
    );
    _rules[index] = updatedRule;
    print(
      '[RuleTrigger] Rule "${rule.name}" triggered. Count: ${updatedRule.triggerCount}',
    );
  }
}
