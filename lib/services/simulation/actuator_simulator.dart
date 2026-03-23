import 'dart:async';
import 'dart:math';

import 'package:urban_os/models/actuator/actuator_model.dart';
import 'package:urban_os/models/actuator/actuator_state.dart';
import 'package:urban_os/models/actuator/actuator_type.dart';
import 'package:urban_os/services/infrastructure/infrastructure_service.dart';

typedef ActuatorUpdatePublisher = void Function(ActuatorModel updated);

abstract class ActuatorExecutionStrategy {
  ActuatorModel execute(ActuatorModel actuator, ActuatorState targetState);
}

/// ===============================
/// ACTUATOR SIMULATOR
/// ===============================

class ActuatorSimulator {
  final InfrastructureService _infrastructure;
  final ActuatorUpdatePublisher _publisher;
  final Random _random;

  final Duration transitionDelay;
  final Duration cooldownDuration;

  final Map<ActuatorType, ActuatorExecutionStrategy> _strategies = {};
  final Map<String, DateTime> _lastExecutionTime = {};

  // metrics
  int totalExecutions = 0;
  int failedExecutions = 0;

  ActuatorSimulator({
    required InfrastructureService infrastructure,
    required ActuatorUpdatePublisher publisher,
    this.transitionDelay = const Duration(milliseconds: 250),
    this.cooldownDuration = const Duration(seconds: 2),
    int? seed,
  }) : _infrastructure = infrastructure,
       _publisher = publisher,
       _random = Random(seed) {
    _registerStrategies();
  }

  void _registerStrategies() {
    _strategies[ActuatorType.trafficLight] = TrafficLightStrategy();
    _strategies[ActuatorType.powerSwitch] = PowerSwitchStrategy();
    _strategies[ActuatorType.backupGenerator] = GeneratorStrategy();
    _strategies[ActuatorType.emergencySiren] = EmergencySirenStrategy();
    _strategies[ActuatorType.airFilter] = EnvironmentControlStrategy();
    _strategies[ActuatorType.irrigationSystem] = EnvironmentControlStrategy();
    _strategies[ActuatorType.pollutionControl] = EnvironmentControlStrategy();

    // fallback strategy for others
  }

  /// MAIN ENTRY POINT
  Future<void> execute({
    required String actuatorId,
    required ActuatorState targetState,
  }) async {
    final actuator = _infrastructure.getActuator(actuatorId);
    if (actuator == null) return;

    if (!_validate(actuator, targetState)) return;
    if (!_checkCooldown(actuator)) return;

    await _applyDelay();

    if (_injectFailure()) {
      failedExecutions++;
      final faulted = actuator.copyWith(state: ActuatorState.error);
      _updateInfrastructure(faulted);
      return;
    }

    final strategy = _strategies[actuator.type] ?? DefaultActuatorStrategy();

    final updated = strategy.execute(actuator, targetState);

    _updateInfrastructure(updated);
    _lastExecutionTime[actuator.id] = DateTime.now();
    totalExecutions++;
  }

  /// ===============================
  /// INTERNAL HELPERS
  /// ===============================

  bool _validate(ActuatorModel actuator, ActuatorState targetState) {
    if (actuator.state == ActuatorState.error) return false;
    if (actuator.state == targetState) return false;
    return true;
  }

  bool _checkCooldown(ActuatorModel actuator) {
    final last = _lastExecutionTime[actuator.id];
    if (last == null) return true;

    return DateTime.now().difference(last) > cooldownDuration;
  }

  Future<void> _applyDelay() async {
    await Future.delayed(transitionDelay);
  }

  bool _injectFailure() {
    return _random.nextDouble() < 0.002; // rare hardware failure
  }

  void _updateInfrastructure(ActuatorModel updated) {
    _infrastructure.updateActuator(updated);
    _publisher(updated);
  }
}

/// ===============================
/// STRATEGIES
/// ===============================

class DefaultActuatorStrategy implements ActuatorExecutionStrategy {
  @override
  ActuatorModel execute(ActuatorModel actuator, ActuatorState targetState) {
    return actuator.copyWith(state: targetState);
  }
}

class TrafficLightStrategy implements ActuatorExecutionStrategy {
  @override
  ActuatorModel execute(ActuatorModel actuator, ActuatorState targetState) {
    // traffic lights must pass standby before switching
    if (targetState == ActuatorState.enabled) {
      return actuator.copyWith(state: ActuatorState.enabled);
    }
    return actuator.copyWith(state: ActuatorState.standby);
  }
}

class PowerSwitchStrategy implements ActuatorExecutionStrategy {
  @override
  ActuatorModel execute(ActuatorModel actuator, ActuatorState targetState) {
    return actuator.copyWith(state: targetState);
  }
}

class GeneratorStrategy implements ActuatorExecutionStrategy {
  @override
  ActuatorModel execute(ActuatorModel actuator, ActuatorState targetState) {
    if (targetState == ActuatorState.enabled) {
      return actuator.copyWith(state: ActuatorState.enabled);
    }
    return actuator.copyWith(state: ActuatorState.standby);
  }
}

class EmergencySirenStrategy implements ActuatorExecutionStrategy {
  @override
  ActuatorModel execute(ActuatorModel actuator, ActuatorState targetState) {
    if (targetState == ActuatorState.enabled) {
      return actuator.copyWith(state: ActuatorState.enabled);
    }
    return actuator.copyWith(state: ActuatorState.disabled);
  }
}

class EnvironmentControlStrategy implements ActuatorExecutionStrategy {
  @override
  ActuatorModel execute(ActuatorModel actuator, ActuatorState targetState) {
    return actuator.copyWith(state: targetState);
  }
}
