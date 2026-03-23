import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/rule_condition.dart';

typedef C = AppColors;
//  SIMULATION MODELS

enum SimPhase { idle, running, paused, completed }

enum SimSpeed { slow, normal, fast, instant }

enum SimScenario { custom, rampUp, pulse, stress }

enum SimLogLevel { info, success, warning, error, trigger }

extension SimPhaseX on SimPhase {
  String get label {
    switch (this) {
      case SimPhase.idle:
        return '◉ IDLE';
      case SimPhase.running:
        return '▶ RUNNING';
      case SimPhase.paused:
        return '⏸ PAUSED';
      case SimPhase.completed:
        return '✓ DONE';
    }
  }

  Color get color {
    switch (this) {
      case SimPhase.idle:
        return C.mutedLt;
      case SimPhase.running:
        return C.green;
      case SimPhase.paused:
        return C.amber;
      case SimPhase.completed:
        return C.teal;
    }
  }
}

extension SimSpeedX on SimSpeed {
  String get label =>
      const ['0.5×', '1×', '2×', '∞'][SimSpeed.values.indexOf(this)];
  int get tickMs => const [2000, 1000, 500, 50][SimSpeed.values.indexOf(this)];
  Color get color =>
      [C.sky, C.green, C.amber, C.red][SimSpeed.values.indexOf(this)];
}

extension SimScenarioX on SimScenario {
  String get label => const [
    'CUSTOM',
    'RAMP↑',
    'PULSE',
    'STRESS',
  ][SimScenario.values.indexOf(this)];
  Color get color =>
      [C.mutedLt, C.amber, C.cyan, C.red][SimScenario.values.indexOf(this)];
}

extension SimLogLevelX on SimLogLevel {
  Color get color => [
    C.mutedLt,
    C.green,
    C.amber,
    C.red,
    C.violet,
  ][SimLogLevel.values.indexOf(this)];
  String get prefix => [
    '[INFO]',
    '[OK]',
    '[WARN]',
    '[ERR]',
    '[FIRE]',
  ][SimLogLevel.values.indexOf(this)];
  IconData get icon => [
    Icons.info_outline_rounded,
    Icons.check_circle_outline_rounded,
    Icons.warning_amber_rounded,
    Icons.error_outline_rounded,
    Icons.bolt_rounded,
  ][SimLogLevel.values.indexOf(this)];
}

class SimSensor {
  final String sensorId;
  double value;
  bool manualOverride;
  final double minRange;
  final double maxRange;
  final RuleCondition condition;

  SimSensor({
    required this.sensorId,
    required this.value,
    required this.minRange,
    required this.maxRange,
    required this.condition,
    this.manualOverride = false,
  });
}

class SimActuator {
  final String id;
  bool triggered;
  int triggerCount;
  SimActuator({
    required this.id,
    this.triggered = false,
    this.triggerCount = 0,
  });
}

class SimTick {
  final int tick;
  final Map<String, double> sensorValues;
  final bool conditionsMet;
  final bool ruleTriggered;
  SimTick({
    required this.tick,
    required this.sensorValues,
    required this.conditionsMet,
    required this.ruleTriggered,
  });
}

class SimLogEntry {
  final String time;
  final String message;
  final SimLogLevel level;
  SimLogEntry({required this.time, required this.message, required this.level});
}
