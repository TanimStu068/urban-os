import 'package:flutter/foundation.dart';
import 'package:urban_os/services/infrastructure/infrastructure_service.dart';
import 'package:urban_os/models/infrastructure/building_model.dart';
import 'package:urban_os/models/infrastructure/road_model.dart';
import 'package:urban_os/models/infrastructure/zone_model.dart';
import 'package:urban_os/models/actuator/actuator_model.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';

class InfrastructureProvider with ChangeNotifier {
  final InfrastructureService _service;

  InfrastructureProvider(this._service);

  // ────────────── ZONES ──────────────
  List<ZoneModel> get zones => _service.zones;
  ZoneModel getZone(String id) => _service.getZone(id);

  // ────────────── BUILDINGS ──────────────
  List<BuildingModel> get buildings => _service.buildings;
  BuildingModel getBuilding(String id) => _service.getBuilding(id);

  // ────────────── ROADS ──────────────
  List<RoadModel> get roads => _service.roads;
  RoadModel getRoad(String id) => _service.getRoad(id);

  // ────────────── ACTUATORS ──────────────
  List<ActuatorModel> get actuators => _service
      .getAllActuators()
      .map(_service.getActuator)
      .whereType<ActuatorModel>()
      .toList();

  ActuatorModel? getActuator(String id) => _service.getActuator(id);

  // ────────────── SENSORS ──────────────
  List<SensorModel> get sensors => _service
      .getAllSensors()
      .map(_service.getSensor)
      .whereType<SensorModel>()
      .toList();

  SensorModel? getSensor(String id) => _service.getSensor(id);

  // ────────────── INFRA METRICS ──────────────
  double get infrastructureHealth =>
      _service.calculateInfrastructureHealthIndex();
  double get averageRoadCongestion => _service.averageRoadCongestion;
  double get averageBuildingRisk => _service.averageBuildingRisk;

  // ────────────── UPDATES ──────────────
  void updateActuatorState(String id, dynamic state) {
    _service.updateActuatorState(id, state);
    notifyListeners();
  }

  void updateBuildingState(String id, {int? occupancy, double? energy}) {
    _service.updateBuildingOperationalState(
      id,
      occupancy: occupancy,
      energy: energy,
    );
    notifyListeners();
  }
}
