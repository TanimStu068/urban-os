import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:urban_os/models/city/city_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/models/actuator/actuator_model.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/models/logs/event_log.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/providers/automation/automation_provider.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/services/infrastructure/infrastructure_service.dart';
import 'package:urban_os/services/simulation/sensor_simulator.dart';
import 'package:urban_os/services/simulation/simulation_engine.dart';

/// Fully integrated CityProvider with sensors, actuators, automation, and health
class CityProvider with ChangeNotifier {
  final InfrastructureService _infrastructure;
  final LogProvider _logProvider;
  final SimulationEngine _simulationEngine;

  CityModel? _city;
  List<SensorModel> _sensors = [];
  List<ActuatorModel> _actuators = [];
  List<AutomationRule> _automationRules = [];

  late final SensorSimulator _simulator;
  late final AutomationProvider _automationProvider;

  Timer? _healthTimer;
  final Random _random = Random();

  CityProvider(
    this._infrastructure,
    this._logProvider,
    this._simulationEngine,
  ) {
    // Initialize AutomationProvider
    _automationProvider = AutomationProvider(
      infrastructure: _infrastructure,
      simulationEngine: _simulationEngine,
    );

    // Initialize SensorSimulator
    _simulator = SensorSimulator(
      infrastructure: _infrastructure,
      simulationEngine: _simulationEngine,
      publisher: _onSensorUpdate,
      seed: _random.nextInt(10000),
    );
  }

  /// -------------------------------
  /// GETTERS
  /// -------------------------------
  CityModel? get city => _city;
  List<SensorModel> get sensors => List.unmodifiable(_sensors);
  List<ActuatorModel> get actuators => List.unmodifiable(_actuators);
  List<AutomationRule> get automationRules =>
      List.unmodifiable(_automationRules);

  DistrictModel? getDistrict(String id) =>
      _city?.districts.firstWhereOrNull((d) => d.id == id);

  double? get populationDensity =>
      (_city?.population != null && _city?.areaKm2 != null)
      ? _city!.population! / _city!.areaKm2!
      : null;

  int get criticalDistrictCount =>
      _city?.districts.where((d) => d.safetyScore < 60).length ?? 0;

  /// -------------------------------
  /// LOAD CITY DATA
  /// -------------------------------
  Future<void> loadCityData({
    required CityModel city,
    List<AutomationRule>? automationRules,
  }) async {
    _city = city;

    // Load sensors
    _sensors = _infrastructure
        .getAllSensors()
        .map(_infrastructure.getSensor)
        .whereType<SensorModel>()
        .toList();

    // Load actuators
    _actuators = _infrastructure
        .getAllActuators()
        .map(_infrastructure.getActuator)
        .whereType<ActuatorModel>()
        .toList();

    // Load automation rules
    _automationRules = automationRules ?? [];

    // Start periodic health monitoring
    _startHealthMonitoring();

    // Start sensor simulation
    _startSimulation();

    notifyListeners();
  }

  /// -------------------------------
  /// SENSOR UPDATES
  /// -------------------------------
  void _onSensorUpdate(SensorModel updated) {
    final index = _sensors.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _sensors[index] = updated;
      notifyListeners();

      // Log sensor event
      _logProvider.addEvent(
        EventLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message:
              'Sensor ${updated.name} updated: ${updated.latestReading?.value}',
          timestamp: DateTime.now(),
          level: EventLogLevel.info,
          source: 'CityProvider',
          resourceId: updated.id,
          category: 'sensor_data',
        ),
      );

      // Generate alerts based on thresholds
      _generateSensorAlerts(updated);

      // Execute automation rules that depend on this sensor
      _automationProvider.executeAll(
        sensorValues: {updated.id: updated.latestReading?.value ?? 0},
      );
    }
  }

  void _generateSensorAlerts(SensorModel sensor) {
    if (sensor.type == SensorType.fireAlarm &&
        sensor.latestReading?.value == 1) {
      _logProvider.addAlert(
        AlertLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Fire Detected',
          description: 'Fire alarm triggered on sensor ${sensor.name}',
          severity: RulePriority.critical,
          timestamp: DateTime.now(),
          createdAt: DateTime.now(),
          resourceId: sensor.id,
          resourceType: 'sensor',
        ),
      );
    }

    if (sensor.type == SensorType.powerConsumption &&
        (sensor.latestReading?.value ?? 0) > 400) {
      _logProvider.addAlert(
        AlertLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'High Power Consumption',
          description:
              'Power consumption exceeded threshold on sensor ${sensor.name}',
          severity: RulePriority.high,
          timestamp: DateTime.now(),
          createdAt: DateTime.now(),
          resourceId: sensor.id,
          resourceType: 'sensor',
        ),
      );
    }
  }

  /// -------------------------------
  /// ACTUATOR UPDATES
  /// -------------------------------
  void updateActuator(ActuatorModel updated) {
    final index = _actuators.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      _actuators[index] = updated;
      notifyListeners();

      _logProvider.addEvent(
        EventLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: 'Actuator ${updated.name} updated: ${updated.healthStatus}',
          timestamp: DateTime.now(),
          level: EventLogLevel.info,
          source: 'CityProvider',
          resourceId: updated.id,
          category: 'actuator_data',
        ),
      );
    }
  }

  /// -------------------------------
  /// SENSOR SIMULATION
  /// -------------------------------
  void _startSimulation() {
    _simulator.startSimulation(_sensors);
  }

  void stopSimulation() {
    _simulator.stopSimulation();
  }

  /// -------------------------------
  /// HEALTH MONITORING
  /// -------------------------------
  void _startHealthMonitoring({
    Duration interval = const Duration(seconds: 5),
  }) {
    _healthTimer?.cancel();
    _healthTimer = Timer.periodic(interval, (_) => _updateCityHealth());
  }

  void _updateCityHealth() {
    if (_city == null) return;

    final criticalDistricts = _city!.districts
        .where((d) => d.safetyScore < 60)
        .length;

    final activeAlerts = _logProvider.alerts.length;

    _city = _city!.copyWith(
      health: _city!.health.copyWith(
        activeAlerts: activeAlerts,
        criticalDistricts: criticalDistricts,
      ),
    );

    notifyListeners();

    _logProvider.addEvent(
      EventLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message:
            'City health updated: activeAlerts=$activeAlerts, criticalDistricts=$criticalDistricts',
        timestamp: DateTime.now(),
        level: EventLogLevel.info,
        source: 'CityProvider',
        resourceId: _city!.id,
        category: 'city_health',
      ),
    );
  }

  /// -------------------------------
  /// CLEANUP
  /// -------------------------------
  void disposeProvider() {
    _healthTimer?.cancel();
    stopSimulation();
  }

  @override
  void dispose() {
    disposeProvider();
    super.dispose();
  }
}
