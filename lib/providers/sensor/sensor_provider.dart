import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:urban_os/loader/mock_data_loader.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/models/logs/event_log.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/services/infrastructure/infrastructure_service.dart';
import 'package:urban_os/services/simulation/sensor_simulator.dart';
import 'package:urban_os/services/simulation/simulation_engine.dart';

class SensorProvider with ChangeNotifier {
  final InfrastructureService _infrastructure;
  final LogProvider _logProvider;
  late final SensorSimulator _simulator;

  final Random _random = Random();
  Timer? _timer;
  List<SensorModel> _sensors = [];

  SensorProvider(this._infrastructure, this._logProvider) {
    // Initialize simulator with a publisher callback
    _simulator = SensorSimulator(
      infrastructure: _infrastructure,
      simulationEngine: SimulationEngine(
        infrastructureService: _infrastructure,
      ),
      publisher: _updateSensor, // matches SensorPublisher type
      seed: _random.nextInt(10000),
    );

    // Load mock sensors and start simulation
    _loadMockSensors();
  }

  List<SensorModel> get sensors => List.unmodifiable(_sensors);

  SensorModel? getSensor(String id) =>
      _sensors.firstWhereOrNull((s) => s.id == id);

  /// ---------------------------
  /// Load mock sensors directly from mock data
  /// ---------------------------
  Future<void> _loadMockSensors() async {
    try {
      // Load sensors directly from mock data
      _sensors = await const MockDataLoader().loadSensors();
      print(
        '[SensorProvider] Loaded ${_sensors.length} sensors from mock data',
      );
    } catch (e) {
      print('[SensorProvider] Error loading sensors: $e');
      _sensors = [];
    }

    // Start live simulation
    _startSimulation();

    // Notify listeners that sensors have been loaded
    notifyListeners();
  }

  /// ---------------------------
  /// Update sensor and generate logs
  /// ---------------------------
  void _updateSensor(SensorModel updated) {
    final index = _sensors.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _sensors[index] = updated;
      notifyListeners();

      // -----------------------
      // Generate EventLog
      // -----------------------
      _logProvider.addEvent(
        EventLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message:
              'Sensor ${updated.name} updated: ${updated.latestReading?.value}',
          timestamp: DateTime.now(),
          level: EventLogLevel.info,
          source: 'SensorProvider',
          resourceId: updated.id,
          category: 'sensor_data',
        ),
      );

      // -----------------------
      // Generate AlertLog for specific conditions
      // -----------------------
      if (updated.type == SensorType.fireAlarm &&
          updated.latestReading?.value == 1) {
        _logProvider.addAlert(
          AlertLog(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'Fire Detected',
            description: 'Fire alarm triggered on sensor ${updated.name}',
            severity: RulePriority.critical,
            timestamp: DateTime.now(),
            createdAt: DateTime.now(),
            resourceId: updated.id,
            resourceType: 'sensor',
          ),
        );
      }

      if (updated.type == SensorType.powerConsumption &&
          (updated.latestReading?.value ?? 0) > 400) {
        _logProvider.addAlert(
          AlertLog(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'High Power Consumption',
            description:
                'Power consumption exceeded threshold on sensor ${updated.name}',
            severity: RulePriority.high,
            timestamp: DateTime.now(),
            createdAt: DateTime.now(),
            resourceId: updated.id,
            resourceType: 'sensor',
          ),
        );
      }
    }
  }

  /// ---------------------------
  /// Start periodic simulation every second
  /// ---------------------------
  void _startSimulation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _simulator.simulate(_sensors);
    });
  }

  /// Stop simulation
  void stopSimulation() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopSimulation();
    super.dispose();
  }
}
