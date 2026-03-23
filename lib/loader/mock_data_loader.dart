import 'dart:convert';
import 'package:flutter/services.dart';

// Import all your models
import 'package:urban_os/models/actuator/actuator_model.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/city/city_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/infrastructure/building_model.dart';
import 'package:urban_os/models/infrastructure/road_model.dart';
import 'package:urban_os/models/infrastructure/zone_model.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';

class MockDataLoader {
  const MockDataLoader();

  /// Helper to load JSON from assets
  Future<List<Map<String, dynamic>>> _loadJsonList(String path) async {
    final jsonStr = await rootBundle.loadString('assets/mock_data/$path');
    final decoded = json.decode(jsonStr) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  /// Load actuators
  Future<List<ActuatorModel>> loadActuators() async {
    final list = await _loadJsonList('actuators.json');
    return list.map((e) => ActuatorModel.fromJson(e)).toList();
  }

  /// Load automation rules
  Future<List<AutomationRule>> loadAutomationRules() async {
    final list = await _loadJsonList('automation_rules.json');
    return list.map((e) => AutomationRule.fromJson(e)).toList();
  }

  /// Load buildings
  Future<List<BuildingModel>> loadBuildings() async {
    final list = await _loadJsonList('building.json');
    return list.map((e) => BuildingModel.fromJson(e)).toList();
  }

  /// Load roads
  Future<List<RoadModel>> loadRoads() async {
    final list = await _loadJsonList('roads.json');
    return list.map((e) => RoadModel.fromJson(e)).toList();
  }

  /// Load zones
  Future<List<ZoneModel>> loadZones() async {
    final list = await _loadJsonList('zones.json');
    return list.map((e) => ZoneModel.fromJson(e)).toList();
  }

  /// Load districts
  Future<List<DistrictModel>> loadDistricts() async {
    final list = await _loadJsonList('districts.json');
    return list.map((e) => DistrictModel.fromJson(e)).toList();
  }

  /// Load cities
  Future<List<CityModel>> loadCities() async {
    final list = await _loadJsonList('city.json');
    return list.map((e) => CityModel.fromJson(e)).toList();
  }

  /// Load sensors
  Future<List<SensorModel>> loadSensors() async {
    final list = await _loadJsonList('sensors.json');
    return list.map((e) => SensorModel.fromJson(e)).toList();
  }
}
