import 'dart:async';

/// ===============================================================
/// URBAN OS — EVENT BUS SERVICE
/// Central Hub for All System Events
/// ===============================================================

/// Event priority levels
enum EventPriority { low, normal, high, critical }

/// Base class for all events
abstract class UrbanEvent {
  final String source; // Which engine or service generated this
  final EventPriority priority;
  final Map<String, dynamic>? metadata;

  UrbanEvent({
    required this.source,
    this.priority = EventPriority.normal,
    this.metadata,
  });
}

/// ===============================================================
/// CENTRAL EVENT BUS
/// ===============================================================
class EventBus {
  final Map<Type, StreamController<dynamic>> _controllers = {};

  /// Publish an event
  void publish<T extends UrbanEvent>(T event) {
    final controller = _controllers[T];
    if (controller != null && !controller.isClosed) {
      controller.add(event);
    }
  }

  /// Subscribe to events of type T
  Stream<T> on<T extends UrbanEvent>() {
    if (!_controllers.containsKey(T)) {
      _controllers[T] = StreamController<T>.broadcast();
    }
    return _controllers[T]!.stream as Stream<T>;
  }

  /// Close all streams and clean up
  Future<void> dispose() async {
    for (final controller in _controllers.values) {
      await controller.close();
    }
    _controllers.clear();
  }
}

/// ===============================================================
/// COMMON EVENTS
/// ===============================================================

/// Sensor update
class SensorUpdatedEvent extends UrbanEvent {
  final String sensorId;
  final double value;

  SensorUpdatedEvent({
    required this.sensorId,
    required this.value,
    required super.source,
    super.priority,
    super.metadata,
  });
}

/// Actuator state changed
class ActuatorStateChangedEvent extends UrbanEvent {
  final String actuatorId;
  final String actuatorName;
  final dynamic newState;

  ActuatorStateChangedEvent({
    required this.actuatorId,
    required this.actuatorName,
    required this.newState,
    required super.source,
    super.priority = EventPriority.normal,
    super.metadata,
  });
}

/// Scenario or emergency event
class ScenarioEvent extends UrbanEvent {
  final String description;
  final String districtId;

  ScenarioEvent({
    required this.description,
    required this.districtId,
    required super.source,
    super.priority = EventPriority.high,
    super.metadata,
  });
}

/// Simulation tick / heartbeat
class SimulationTickEvent extends UrbanEvent {
  final int currentMinute;

  SimulationTickEvent({
    required this.currentMinute,
    required super.source,
    super.priority = EventPriority.low,
    super.metadata,
  });
}

/// Optional: extend this with new events as your system grows
