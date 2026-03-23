import 'package:urban_os/loader/mock_data_loader.dart';
import 'package:urban_os/models/actuator/actuator_model.dart';
import 'package:urban_os/models/actuator/actuator_state.dart';
import 'package:urban_os/models/infrastructure/building_model.dart';
import 'package:urban_os/models/infrastructure/building_status.dart';
import 'package:urban_os/models/infrastructure/road_model.dart';
import 'package:urban_os/models/infrastructure/road_status.dart';
import 'package:urban_os/models/infrastructure/zone_model.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';

class InfrastructureService {
  final Map<String, BuildingModel> _buildings = {};
  final Map<String, RoadModel> _roads = {};
  final Map<String, ZoneModel> _zones = {};
  final Map<String, Map<String, ActuatorState>> _buildingActuatorStates = {};
  final Map<String, Map<String, ActuatorState>> _roadActuatorStates = {};

  /// ==========================================================
  /// ZONE MANAGEMENT
  /// ==========================================================

  void addZone(ZoneModel zone) {
    if (_zones.containsKey(zone.id)) {
      throw Exception("Zone ${zone.id} already exists.");
    }
    _zones[zone.id] = zone;
  }

  void removeZone(String zoneId) {
    final zone = _getZone(zoneId);

    // Remove associated buildings & roads
    for (final bId in zone.buildingIds) {
      _buildings.remove(bId);
    }
    for (final rId in zone.roadIds) {
      _roads.remove(rId);
    }

    _zones.remove(zoneId);
  }

  ZoneModel getZone(String id) => _getZone(id);

  List<ZoneModel> get zones => _zones.values.toList();

  void updateZoneStatus(String zoneId, ZoneModel updatedZone) {
    _zones[zoneId] = updatedZone;
  }

  void updateZoneRiskAndSafety(
    String zoneId, {
    double? environmentalRisk,
    double? safetyScore,
  }) {
    final zone = _getZone(zoneId);

    _zones[zoneId] = zone.copyWith(
      environmentalRisk: environmentalRisk,
      safetyScore: safetyScore,
    );
  }

  /// ==========================================================
  /// BUILDING MANAGEMENT
  /// ==========================================================

  void addBuilding(BuildingModel building) {
    if (_buildings.containsKey(building.id)) {
      throw Exception("Building ${building.id} already exists.");
    }

    _buildingActuatorStates[building.id] = {
      for (var actuator in building.actuators)
        actuator.id: ActuatorState.disabled, // default state
    };

    final zone = _getZone(building.zoneId);

    _buildings[building.id] = building;

    // Update zone building reference
    _zones[zone.id] = zone
        .copyWith(status: zone.status)
        .copyWith(
          environmentalRisk: zone.environmentalRisk,
          safetyScore: zone.safetyScore,
        );

    _zones[zone.id] = ZoneModel(
      id: zone.id,
      name: zone.name,
      districtId: zone.districtId,
      type: zone.type,
      status: zone.status,
      buildingIds: [...zone.buildingIds, building.id],
      roadIds: zone.roadIds,
      areaSize: zone.areaSize,
      populationDensity: zone.populationDensity,
      environmentalRisk: zone.environmentalRisk,
      safetyScore: zone.safetyScore,
    );
  }

  void removeBuilding(String buildingId) {
    final building = _getBuilding(buildingId);
    final zone = _getZone(building.zoneId);

    _buildings.remove(buildingId);

    _zones[zone.id] = ZoneModel(
      id: zone.id,
      name: zone.name,
      districtId: zone.districtId,
      type: zone.type,
      status: zone.status,
      buildingIds: zone.buildingIds.where((id) => id != buildingId).toList(),
      roadIds: zone.roadIds,
      areaSize: zone.areaSize,
      populationDensity: zone.populationDensity,
      environmentalRisk: zone.environmentalRisk,
      safetyScore: zone.safetyScore,
    );
  }

  BuildingModel getBuilding(String id) => _getBuilding(id);

  List<BuildingModel> get buildings => _buildings.values.toList();

  void updateBuildingOperationalState(
    String buildingId, {
    int? occupancy,
    double? energy,
    double? water,
    double? gas,
    double? risk,
    BuildingStatus? status,
  }) {
    final building = _getBuilding(buildingId);

    final updated = building.copyWith(
      currentOccupancy: occupancy?.clamp(0, building.maxOccupancy),
      energyUsage: energy,
      waterUsage: water,
      gasUsage: gas,
      riskLevel: risk?.clamp(0, 100),
      status: status,
    );

    _buildings[buildingId] = updated;
  }

  List<BuildingModel> getCriticalBuildings() =>
      _buildings.values.where((b) => b.isCritical).toList();

  List<BuildingModel> getBuildingsByDistrict(String districtId) =>
      _buildings.values.where((b) => b.districtId == districtId).toList();

  /// ==========================================================
  /// ROAD MANAGEMENT
  /// ==========================================================

  void addRoad(RoadModel road) {
    if (_roads.containsKey(road.id)) {
      throw Exception("Road ${road.id} already exists.");
    }
    _roadActuatorStates[road.id] = {
      for (var actuator in road.actuators)
        actuator.id: ActuatorState.disabled, // default state
    };

    final zone = _getZone(road.zoneId);

    _roads[road.id] = road;

    _zones[zone.id] = ZoneModel(
      id: zone.id,
      name: zone.name,
      districtId: zone.districtId,
      type: zone.type,
      status: zone.status,
      buildingIds: zone.buildingIds,
      roadIds: [...zone.roadIds, road.id],
      areaSize: zone.areaSize,
      populationDensity: zone.populationDensity,
      environmentalRisk: zone.environmentalRisk,
      safetyScore: zone.safetyScore,
    );
  }

  void removeRoad(String roadId) {
    final road = _getRoad(roadId);
    final zone = _getZone(road.zoneId);

    _roads.remove(roadId);

    _zones[zone.id] = ZoneModel(
      id: zone.id,
      name: zone.name,
      districtId: zone.districtId,
      type: zone.type,
      status: zone.status,
      buildingIds: zone.buildingIds,
      roadIds: zone.roadIds.where((id) => id != roadId).toList(),
      areaSize: zone.areaSize,
      populationDensity: zone.populationDensity,
      environmentalRisk: zone.environmentalRisk,
      safetyScore: zone.safetyScore,
    );
  }

  RoadModel getRoad(String id) => _getRoad(id);

  List<RoadModel> get roads => _roads.values.toList();

  void updateRoadOperationalState(
    String roadId, {
    double? density,
    double? congestion,
    double? accidentRisk,
    RoadStatus? status,
  }) {
    final road = _getRoad(roadId);

    final updated = road.copyWith(
      vehicleDensity: density,
      congestionLevel: congestion?.clamp(0, 1),
      accidentRisk: accidentRisk?.clamp(0, 100),
      status: status,
    );

    _roads[roadId] = updated;
  }

  /// ==========================================================
  /// SENSOR / ACTUATOR LOOKUP
  /// ==========================================================

  List<String> getAllSensors() => [
    ..._buildings.values.expand((b) => b.sensors.map((s) => s.id)),
    ..._roads.values.expand((r) => r.sensors.map((s) => s.id)),
  ];

  List<String> getAllActuators() => [
    ..._buildings.values.expand((b) => b.actuators.map((a) => a.id)),
    ..._roads.values.expand((r) => r.actuators.map((a) => a.id)),
  ];

  /// ==========================================================
  /// AGGREGATED ANALYTICS
  /// ==========================================================

  int get totalPopulation =>
      _buildings.values.fold(0, (sum, b) => sum + b.currentOccupancy);

  double get totalEnergyUsage =>
      _buildings.values.fold(0, (sum, b) => sum + b.energyUsage);

  double get totalWaterUsage =>
      _buildings.values.fold(0, (sum, b) => sum + b.waterUsage);

  double get totalGasUsage =>
      _buildings.values.fold(0, (sum, b) => sum + b.gasUsage);

  double get averageBuildingRisk => _buildings.isEmpty
      ? 0
      : _buildings.values.map((b) => b.riskLevel).reduce((a, b) => a + b) /
            _buildings.length;

  double get averageRoadCongestion => _roads.isEmpty
      ? 0
      : _roads.values.map((r) => r.congestionLevel).reduce((a, b) => a + b) /
            _roads.length;

  double get averageEnvironmentalRisk => _zones.isEmpty
      ? 0
      : _zones.values.map((z) => z.environmentalRisk).reduce((a, b) => a + b) /
            _zones.length;

  /// Infrastructure Health Index (Composite KPI)

  double calculateInfrastructureHealthIndex() {
    final buildingHealth = 100 - averageBuildingRisk;
    final trafficHealth = 100 - (averageRoadCongestion * 100);
    final environmentalHealth = 100 - averageEnvironmentalRisk;

    return (buildingHealth * 0.4) +
        (trafficHealth * 0.3) +
        (environmentalHealth * 0.3);
  }

  /// ==========================================================
  /// INTERNAL SAFE ACCESS
  /// ==========================================================

  BuildingModel _getBuilding(String id) {
    final building = _buildings[id];
    if (building == null) {
      throw Exception("Building $id not found.");
    }
    return building;
  }

  RoadModel _getRoad(String id) {
    final road = _roads[id];
    if (road == null) {
      throw Exception("Road $id not found.");
    }
    return road;
  }

  void updateActuatorState(String actuatorId, ActuatorState newState) {
    // Search in buildings
    for (final entry in _buildingActuatorStates.entries) {
      if (entry.value.containsKey(actuatorId)) {
        entry.value[actuatorId] = newState;
        return;
      }
    }

    // Search in roads
    for (final entry in _roadActuatorStates.entries) {
      if (entry.value.containsKey(actuatorId)) {
        entry.value[actuatorId] = newState;
        return;
      }
    }

    throw Exception("Actuator $actuatorId not found.");
  }

  ZoneModel _getZone(String id) {
    final zone = _zones[id];
    if (zone == null) {
      throw Exception("Zone $id not found.");
    }
    return zone;
  }

  // Get full sensor by ID
  SensorModel? getSensor(String sensorId) {
    for (final building in _buildings.values) {
      try {
        return building.sensors.firstWhere((s) => s.id == sensorId);
      } catch (e) {
        // Not found in this building, continue
      }
    }
    for (final road in _roads.values) {
      try {
        return road.sensors.firstWhere((s) => s.id == sensorId);
      } catch (e) {
        // Not found in this road, continue
      }
    }
    return null;
  }

  // Get full actuator by ID
  ActuatorModel? getActuator(String actuatorId) {
    for (final building in _buildings.values) {
      try {
        return building.actuators.firstWhere((a) => a.id == actuatorId);
      } catch (e) {
        // Not found in this building, continue
      }
    }
    for (final road in _roads.values) {
      try {
        return road.actuators.firstWhere((a) => a.id == actuatorId);
      } catch (e) {
        // Not found in this road, continue
      }
    }
    return null;
  }

  void updateActuator(ActuatorModel updatedActuator) {
    // Check buildings
    for (final entry in _buildings.entries) {
      final building = entry.value;
      final index = building.actuators.indexWhere(
        (a) => a.id == updatedActuator.id,
      );
      if (index != -1) {
        final newActuators = List<ActuatorModel>.from(building.actuators);
        newActuators[index] = updatedActuator;

        _buildings[building.id] = building.copyWith(actuators: newActuators);
        _buildingActuatorStates[building.id]?[updatedActuator.id] =
            updatedActuator.state;
        return;
      }
    }

    // Check roads
    for (final entry in _roads.entries) {
      final road = entry.value;
      final index = road.actuators.indexWhere(
        (a) => a.id == updatedActuator.id,
      );
      if (index != -1) {
        final newActuators = List<ActuatorModel>.from(road.actuators);
        newActuators[index] = updatedActuator;

        _roads[road.id] = road.copyWith(actuators: newActuators);
        _roadActuatorStates[road.id]?[updatedActuator.id] =
            updatedActuator.state;
        return;
      }
    }

    throw Exception(
      "Actuator ${updatedActuator.id} not found in infrastructure.",
    );
  }

  /// Load all mock data
  Future<void> loadMockData() async {
    final loader = MockDataLoader();

    // 1. Load zones
    final zones = await loader.loadZones();
    for (final z in zones) {
      addZone(z);
    }

    // 2. Load buildings
    final buildings = await loader.loadBuildings();
    for (final b in buildings) {
      addBuilding(b);
    }

    // 3. Load roads
    final roads = await loader.loadRoads();
    for (final r in roads) {
      addRoad(r);
    }
    print('[InfrastructureService] Mock data loaded.');
  }
}
