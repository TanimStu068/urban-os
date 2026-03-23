import 'dart:math';
import 'dart:async';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/models/sensor/sensor_reading.dart';
import 'package:urban_os/models/sensor/sensor_state.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/services/infrastructure/infrastructure_service.dart';
import 'package:urban_os/services/simulation/simulation_engine.dart';

typedef SensorPublisher = void Function(SensorModel updatedSensor);

abstract class SensorValueStrategy {
  double generate(
    SensorModel sensor,
    InfrastructureService infrastructure,
    SimulationEngine engine,
    Random random,
  );
}

class SensorSimulator {
  final InfrastructureService _infrastructure;
  final SimulationEngine _engine;
  final SensorPublisher _publisher;
  final Random _random;
  Timer? _timer;

  final Map<SensorType, SensorValueStrategy> _strategies;

  SensorSimulator({
    required InfrastructureService infrastructure,
    required SimulationEngine simulationEngine,
    required SensorPublisher publisher,
    int? seed,
  }) : _infrastructure = infrastructure,
       _engine = simulationEngine,
       _publisher = publisher,
       _random = Random(seed),
       _strategies = _initializeStrategies();

  static Map<SensorType, SensorValueStrategy> _initializeStrategies() {
    return {
      SensorType.vehicleCount: TrafficDensityStrategy(),
      SensorType.averageSpeed: TrafficSpeedStrategy(),
      SensorType.powerConsumption: PowerConsumptionStrategy(),
      SensorType.fireAlarm: FireDetectionStrategy(),
      // Add more progressively
    };
  }

  void simulate(List<SensorModel> sensors) {
    final now = DateTime.now();

    for (final sensor in sensors) {
      if (sensor.state != SensorState.online) continue;

      final strategy = _strategies[sensor.type];
      if (strategy == null) continue;

      double value = strategy.generate(
        sensor,
        _infrastructure,
        _engine,
        _random,
      );

      value = _injectNoise(value);

      if (_shouldFault()) {
        value = _faultValue(sensor.type);
      }

      final reading = SensorReading(value: value, timestamp: now);

      final updated = sensor.copyWith(latestReading: reading);

      _publisher(updated);
    }
  }

  double _injectNoise(double value) {
    return value + (_random.nextDouble() - 0.5) * 2;
  }

  bool _shouldFault() {
    return _random.nextDouble() < 0.002;
  }

  double _faultValue(SensorType type) {
    return 9999; // extreme anomaly
  }

  /// Start continuous simulation
  void startSimulation(
    List<SensorModel> sensors, {
    Duration interval = const Duration(seconds: 1),
  }) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => simulate(sensors));
  }

  /// Stop continuous simulation
  void stopSimulation() {
    _timer?.cancel();
    _timer = null;
  }
}

class TrafficDensityStrategy implements SensorValueStrategy {
  @override
  double generate(
    SensorModel sensor,
    InfrastructureService infrastructure,
    SimulationEngine engine,
    Random random,
  ) {
    // Example: return a random vehicle count between 0 and 100
    return random.nextInt(100).toDouble();
  }
}

class TrafficSpeedStrategy implements SensorValueStrategy {
  @override
  double generate(
    SensorModel sensor,
    InfrastructureService infrastructure,
    SimulationEngine engine,
    Random random,
  ) {
    // Example: average speed between 20 and 80 km/h
    return 20 + random.nextDouble() * 60;
  }
}

class PowerConsumptionStrategy implements SensorValueStrategy {
  @override
  double generate(
    SensorModel sensor,
    InfrastructureService infrastructure,
    SimulationEngine engine,
    Random random,
  ) {
    // Example: power consumption 0 - 500 kW
    return random.nextDouble() * 500;
  }
}

class FireDetectionStrategy implements SensorValueStrategy {
  @override
  double generate(
    SensorModel sensor,
    InfrastructureService infrastructure,
    SimulationEngine engine,
    Random random,
  ) {
    // Example: 0 = no fire, 1 = fire detected (rare)
    return random.nextDouble() < 0.01 ? 1 : 0;
  }
}
