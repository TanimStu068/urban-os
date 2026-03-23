import 'dart:async';
import 'dart:math';

import 'package:urban_os/models/infrastructure/building_status.dart';
import 'package:urban_os/models/infrastructure/road_status.dart';
import 'package:urban_os/services/infrastructure/infrastructure_service.dart';

//Urban OS simulation engine
//Premium industrial digital twin engine

class SimulationEngine {
  final InfrastructureService _infrastructure;
  final Random _random = Random();

  Timer? _timer;

  bool _isRunning = false;
  bool _isPaused = false;

  Duration tickInterval;
  double simulationSpeed;
  int _simulationMinute = 0;

  SimulationEngine({
    required InfrastructureService infrastructureService,
    this.tickInterval = const Duration(seconds: 3),
    this.simulationSpeed = 1.0,
  }) : _infrastructure = infrastructureService;

  //lifecycle control
  void start() {
    if (!_isRunning) return;
    _isRunning = true;
    _isPaused = false;

    _timer = Timer.periodic(tickInterval, (_) => _tick());
  }

  void pause() {
    if (!_isRunning) return;
    _isPaused = true;
  }

  void resume() {
    if (!_isRunning) return;
    _isPaused = false;
  }

  void stop() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
  }

  void setSpeed(double speedMultiplier) {
    simulationSpeed = speedMultiplier.clamp(0.5, 10.0);
  }

  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;

  //core tick loop
  void _tick() {
    if (_isPaused) return;

    _advanceTime();
    _simulateBuildings();
    _simulateRoads();
    _simulateZones();
    _injectRandomIncidents();
  }

  //time system
  void _advanceTime() {
    _simulationMinute += (1 * simulationSpeed).round();
    if (_simulationMinute >= 1440) {
      _simulationMinute = 0;
    }
  }

  int get hour => _simulationMinute ~/ 60;
  bool get isNight => hour >= 22 || hour < 6;
  bool get isRushHour => (hour >= 7 && hour <= 9) || (hour >= 17 && hour <= 19);

  //building simulation
  void _simulateBuildings() {
    for (final building in _infrastructure.buildings) {
      int newOccupancy = building.currentOccupancy;

      if (!isNight) {
        newOccupancy += _random.nextInt(5);
      } else {
        newOccupancy -= _random.nextInt(3);
      }

      newOccupancy = newOccupancy.clamp(0, building.maxOccupancy);
      double energy = building.energyUsage + (newOccupancy * 0.05);

      if (isNight) energy *= 0.8;

      double water = building.waterUsage + (newOccupancy * 0.02);
      double gas = building.gasUsage + (newOccupancy * 0.01);
      double risk =
          building.riskLevel + (newOccupancy / building.maxOccupancy) * 2;

      if (building.status == BuildingStatus.emergency) {
        risk += 5;
      }

      _infrastructure.updateBuildingOperationalState(
        building.id,
        occupancy: newOccupancy,
        energy: energy,
        water: water,
        gas: gas,
        risk: risk.clamp(0, 100),
      );
    }
  }

  //road simulation
  void _simulateRoads() {
    for (final road in _infrastructure.roads) {
      double density = road.vehicleDensity;

      if (isRushHour) {
        density += _random.nextDouble() * 5;
      } else {
        density -= _random.nextDouble() * 2;
      }

      density = density.clamp(0, 200);
      double congestion = (density / (road.laneCount * 50)).clamp(0, 1);
      double accidentRisk = congestion * 100 + _random.nextDouble() * 5;

      _infrastructure.updateRoadOperationalState(
        road.id,
        density: density,
        congestion: congestion,
        accidentRisk: accidentRisk.clamp(0, 100),
      );
    }
  }

  //zone simulation
  void _simulateZones() {
    for (final zone in _infrastructure.zones) {
      final buildings = zone.buildingIds.map(
        (id) => _infrastructure.getBuilding(id),
      );

      double avgRisk = 0;
      if (zone.buildingIds.isNotEmpty) {
        avgRisk =
            buildings.map((b) => b.riskLevel).reduce((a, b) => a + b) /
            zone.buildingIds.length;
      }

      double environmentalRisk = zone.environmentalRisk + (avgRisk * 0.02);
      double safeScore = (100 - environmentalRisk).clamp(0, 100);
      _infrastructure.updateZoneRiskAndSafety(
        zone.id,
        environmentalRisk: environmentalRisk.clamp(0, 100),
        safetyScore: safeScore,
      );
    }
  }

  //incident engine(industrial random events)
  void _injectRandomIncidents() {
    if (_random.nextDouble() < 0.02) {
      final buildings = _infrastructure.buildings;
      if (buildings.isNotEmpty) {
        final target = buildings[_random.nextInt(buildings.length)];

        _infrastructure.updateBuildingOperationalState(
          target.id,
          risk: 95,
          status: BuildingStatus.emergency,
        );
      }
    }

    if (_random.nextDouble() < 0.015) {
      final roads = _infrastructure.roads;
      if (roads.isNotEmpty) {
        final target = roads[_random.nextInt(roads.length)];

        _infrastructure.updateRoadOperationalState(
          target.id,
          accidentRisk: 90,
          status: RoadStatus.closed,
        );
      }
    }
  }

  //metrics
  double get infrastructureHealth =>
      _infrastructure.calculateInfrastructureHealthIndex();
  int get currentSimulationMinute => _simulationMinute;
}
