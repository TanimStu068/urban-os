import 'dart:async';
import 'dart:math';

import 'package:urban_os/models/actuator/actuator_model.dart';
import 'package:urban_os/models/actuator/actuator_type.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/services/infrastructure/infrastructure_service.dart';
import 'package:urban_os/services/simulation/actuator_simulator.dart';
import 'package:urban_os/models/actuator/actuator_state.dart';

typedef ScenarioLogger = void Function(String message);

class ScenarioEngine {
  final InfrastructureService _infrastructure;
  final ActuatorSimulator _actuatorSimulator;
  final ScenarioLogger logger;

  final Random _random = Random();

  final Duration tickInterval;
  Timer? _timer;

  bool _isRunning = false;

  ScenarioEngine({
    required InfrastructureService infrastructure,
    required ActuatorSimulator actuatorSimulator,
    required this.logger,
    this.tickInterval = const Duration(seconds: 2),
  }) : _infrastructure = infrastructure,
       _actuatorSimulator = actuatorSimulator;

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(tickInterval, (_) => _tick());
  }

  void stop() {
    _timer?.cancel();
    _isRunning = false;
  }

  bool get isRunning => _isRunning;

  /// Core tick
  void _tick() {
    _evaluateSensors();
    _injectRandomScenarios();
  }

  /// Evaluate all sensors and take actions
  void _evaluateSensors() {
    for (final building in _infrastructure.buildings) {
      for (final sensor in building.sensors) {
        if (sensor.latestReading == null) continue;
        _processSensor(building.districtId, sensor);
      }
    }

    for (final road in _infrastructure.roads) {
      for (final sensor in road.sensors) {
        if (sensor.latestReading == null) continue;
        _processSensor(road.zoneId, sensor);
      }
    }
  }

  void _processSensor(String districtId, SensorModel sensor) {
    final value = sensor.latestReading!.value;

    switch (sensor.type) {
      case SensorType.airQuality:
        if (value > 150) {
          _triggerActuatorByType(districtId, ActuatorType.airFilter);
          _triggerActuatorByType(districtId, ActuatorType.pollutionControl);
          logger("Air Quality Alert in $districtId, AQI=$value");
        }
        break;
      case SensorType.vehicleCount:
        if (value > 80) {
          _triggerActuatorByType(districtId, ActuatorType.trafficLight);
          logger("Traffic Alert in $districtId, Vehicles=$value");
        }
        break;

      case SensorType.fireAlarm:
        if (value > 0) {
          _triggerActuatorByType(districtId, ActuatorType.emergencySiren);
          logger("Fire Alert in $districtId!");
        }
        break;

      default:
        break;
    }
  }

  /// Trigger actuator in district by type
  void _triggerActuatorByType(String districtId, ActuatorType type) {
    final actuators = _infrastructure
        .getAllActuators()
        .map((id) => _infrastructure.getActuator(id))
        .where((a) => a != null && a.type == type)
        .cast<ActuatorModel>()
        .toList();

    for (final actuator in actuators) {
      if (actuator.districtId == districtId) {
        _actuatorSimulator.execute(
          actuatorId: actuator.id,
          targetState: ActuatorState.enabled,
        );
      }
    }
  }

  /// Random scenario injection for testing/demo
  void _injectRandomScenarios() {
    if (_random.nextDouble() < 0.01) {
      final buildings = _infrastructure.buildings;
      if (buildings.isEmpty) return;

      final building = buildings[_random.nextInt(buildings.length)];
      _triggerActuatorByType(building.districtId, ActuatorType.emergencySiren);
      logger("Random Emergency in ${building.districtId}");
    }
  }
}
