import 'package:flutter/foundation.dart';
import 'package:urban_os/models/logs/event_log.dart';
import 'package:urban_os/models/logs/system_log.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/services/simulation/simulation_engine.dart';
import 'package:urban_os/services/infrastructure/infrastructure_service.dart';
import 'package:urban_os/services/simulation/sensor_simulator.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';

class SimulationProvider with ChangeNotifier {
  final SimulationEngine _engine;
  final SensorSimulator _sensorSimulator;

  SimulationProvider({
    required InfrastructureService infrastructure,
    required SensorPublisher sensorPublisher,
    Duration tickInterval = const Duration(seconds: 3),
  }) : _engine = SimulationEngine(
         infrastructureService: infrastructure,
         tickInterval: tickInterval,
       ),
       _sensorSimulator = SensorSimulator(
         infrastructure: infrastructure,
         simulationEngine: SimulationEngine(
           infrastructureService: infrastructure,
         ),
         publisher: sensorPublisher,
       );

  bool get isRunning => _engine.isRunning;
  bool get isPaused => _engine.isPaused;
  double get speed => _engine.simulationSpeed;

  void start(LogProvider logProvider) {
    _engine.start();
    notifyListeners();

    logProvider.addSystemLog(
      SystemLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        topic: 'Simulation',
        message: 'Simulation started',
        timestamp: DateTime.now(),
        status: 'running',
      ),
    );
  }

  void stop(LogProvider logProvider) {
    _engine.stop();
    notifyListeners();

    logProvider.addSystemLog(
      SystemLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        topic: 'Simulation',
        message: 'Simulation stopped',
        timestamp: DateTime.now(),
        status: 'stopped',
      ),
    );
  }

  void simulateSensors(List<SensorModel> sensors, LogProvider logProvider) {
    _sensorSimulator.simulate(sensors);
    notifyListeners();

    logProvider.addEvent(
      EventLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: 'Simulation tick: ${_engine.currentSimulationMinute} min',
        timestamp: DateTime.now(),
        level: EventLogLevel.debug,
        source: 'SimulationProvider',
        category: 'simulation_tick',
      ),
    );
  }

  void pause() {
    _engine.pause();
    notifyListeners();
  }

  void resume() {
    _engine.resume();
    notifyListeners();
  }

  void setSpeed(double newSpeed) {
    _engine.setSpeed(newSpeed);
    notifyListeners();
  }

  int get currentMinute => _engine.currentSimulationMinute;
  double get infrastructureHealth => _engine.infrastructureHealth;
}
