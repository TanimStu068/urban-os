import 'package:flutter/foundation.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/models/logs/event_log.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/services/automation/automation_engine.dart';
import 'package:urban_os/services/infrastructure/infrastructure_service.dart';
import 'package:urban_os/services/simulation/simulation_engine.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/actuator/actuator_model.dart';

class AutomationProvider with ChangeNotifier {
  final AutomationEngine _engine;
  final InfrastructureService _infrastructure;
  final SimulationEngine? _simulation;

  final List<String> _logs = [];
  final List<AutomationRule> _rules = [];

  AutomationProvider({
    required InfrastructureService infrastructure,
    SimulationEngine? simulationEngine,
  }) : _infrastructure = infrastructure,
       _simulation = simulationEngine,
       _engine = AutomationEngine.instance;

  List<AutomationRule> get rules => List.unmodifiable(_rules);
  List<ActuatorModel> get actuators => _engine.getActuators();
  List<String> get logs => List.unmodifiable(_logs);

  void log(String message) {
    _logs.add('[${DateTime.now()}] $message');
    notifyListeners();
  }

  Future<void> initialize() async {
    await _engine.init();
    _rules.clear();
    _rules.addAll(_engine.getRules());
    log('Automation Engine Initialized with ${_rules.length} rules.');
    notifyListeners();
  }

  /// Toggle a rule's enabled state
  void toggleRule(AutomationRule rule) {
    final index = _rules.indexWhere((r) => r.id == rule.id);
    if (index != -1) {
      final updated = rule.copyWith(isEnabled: !rule.isEnabled);
      _rules[index] = updated;
      log(
        'Rule ${rule.id} toggled to ${updated.isEnabled ? 'enabled' : 'disabled'}',
      );
      notifyListeners();
    }
  }

  /// Delete a rule
  void deleteRule(AutomationRule rule) {
    if (rule.isSystem) {
      log('Cannot delete system rule ${rule.id}');
      return;
    }
    _rules.removeWhere((r) => r.id == rule.id);
    log('Rule ${rule.id} deleted');
    notifyListeners();
  }

  /// Duplicate a rule
  AutomationRule? duplicateRule(AutomationRule rule) {
    // Generate a new ID
    final newId = 'AR-${(_rules.length + 100).toString().padLeft(3, '0')}';

    final newRule = AutomationRule(
      id: newId,
      name: '${rule.name} (Copy)',
      description: rule.description,
      category: rule.category,
      priority: rule.priority,
      isEnabled: false,
      conditions: rule.conditions,
      conditionLogic: rule.conditionLogic,
      actions: rule.actions,
      district: rule.district,
      createdBy: rule.createdBy,
      triggerCount: 0,
      isSystem: false,
      triggerHistory: [0, 0, 0, 0, 0, 0, 0],
      createdDate: DateTime.now(),
      modifiedDate: DateTime.now(),
    );

    _rules.add(newRule);
    log('Rule duplicated as $newId');
    notifyListeners();
    return newRule;
  }

  /// Test a rule (simulate execution)
  Future<void> testRule(
    String ruleId, {
    Map<String, double>? sensorValues,
  }) async {
    final rule = _engine.getRuleById(ruleId);
    if (rule == null) return;

    final sensors = sensorValues ?? {};
    final success = _engine.simulateRule(ruleId, sensors);

    log('Rule $ruleId test: ${success ? 'SUCCESS' : 'FAILED'}');
    notifyListeners();
  }

  bool executeRule(
    String ruleId, {
    Map<String, double>? sensorValues,
    required LogProvider logProvider,
  }) {
    final sensors = sensorValues ?? {};
    final success = _engine.simulateRule(ruleId, sensors);

    logProvider.addEvent(
      EventLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: 'Rule $ruleId executed: ${success ? "SUCCESS" : "FAILED"}',
        timestamp: DateTime.now(),
        level: success ? EventLogLevel.info : EventLogLevel.warning,
        source: 'AutomationProvider',
        category: 'automation_rule',
        metadata: sensors,
      ),
    );

    // Example: Generate alert if automation fails
    if (!success) {
      logProvider.addAlert(
        AlertLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Automation Rule Failed',
          description: 'Rule $ruleId failed during execution',
          severity: RulePriority.high,
          timestamp: DateTime.now(),
          createdAt: DateTime.now(),
          ruleId: ruleId,
        ),
      );
    }

    notifyListeners();
    return success;
  }

  /// Execute all rules based on current infrastructure/simulation sensor values
  Future<void> executeAll({Map<String, double>? sensorValues}) async {
    final sensors =
        sensorValues ??
        _infrastructure.getAllSensors().fold<Map<String, double>>({}, (
          map,
          id,
        ) {
          final sensor = _infrastructure.getSensor(id);
          if (sensor?.latestReading != null) {
            map[id] = sensor!.latestReading!.value;
          }
          return map;
        });

    await _engine.executeAllRules(sensors);
    log('Executed all rules.');
    notifyListeners();
  }
}
