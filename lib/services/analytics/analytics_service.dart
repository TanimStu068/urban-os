import 'package:urban_os/models/actuator/actuator_model.dart';
import 'package:urban_os/models/infrastructure/building_model.dart';
import 'package:urban_os/models/infrastructure/road_model.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/services/infrastructure/infrastructure_service.dart';

/// AnalyticsService: computes KPIs, aggregated metrics, health indices
/// and provides detailed analysis for the UrbanOS system.
class AnalyticsService {
  final InfrastructureService _infra;

  AnalyticsService(this._infra);

  /// ==========================================================
  /// BUILDING ANALYTICS
  /// ==========================================================

  int get totalPopulation =>
      _infra.buildings.fold(0, (sum, b) => sum + (b.currentOccupancy));

  double get totalEnergyUsage =>
      _infra.buildings.fold(0, (sum, b) => sum + (b.energyUsage));

  double get totalWaterUsage =>
      _infra.buildings.fold(0, (sum, b) => sum + (b.waterUsage));

  double get totalGasUsage =>
      _infra.buildings.fold(0, (sum, b) => sum + (b.gasUsage));

  double get averageBuildingRisk => _infra.buildings.isEmpty
      ? 0
      : _infra.buildings.map((b) => b.riskLevel).reduce((a, b) => a + b) /
            _infra.buildings.length;

  List<BuildingModel> getCriticalBuildings() => _infra.getCriticalBuildings();

  /// ==========================================================
  /// ROAD ANALYTICS
  /// ==========================================================

  double get averageRoadCongestion => _infra.roads.isEmpty
      ? 0
      : _infra.roads.map((r) => r.congestionLevel).reduce((a, b) => a + b) /
            _infra.roads.length;

  double get averageAccidentRisk => _infra.roads.isEmpty
      ? 0
      : _infra.roads.map((r) => r.accidentRisk).reduce((a, b) => a + b) /
            _infra.roads.length;

  double get averageTrafficFlow {
    if (_infra.roads.isEmpty) return 0;
    final totalHealth = _infra.roads
        .map((r) => r.trafficHealth)
        .reduce((a, b) => a + b);
    return totalHealth / _infra.roads.length;
  }

  /// ==========================================================
  /// SENSOR ANALYTICS
  /// ==========================================================

  int get totalSensors => _infra.getAllSensors().length;

  int get onlineSensors =>
      _infra.buildings
          .expand((b) => b.sensors)
          .where((s) => s.isHealthy)
          .length +
      _infra.roads.expand((r) => r.sensors).where((s) => s.isHealthy).length;

  int get offlineSensors => totalSensors - onlineSensors;

  double get sensorHealthPercentage =>
      totalSensors == 0 ? 0 : (onlineSensors / totalSensors) * 100;

  List<SensorModel> getSensorsNeedingMaintenance() {
    final buildingSensors = _infra.buildings
        .expand((b) => b.sensors)
        .where((s) => s.needsMaintenance);
    final roadSensors = _infra.roads
        .expand((r) => r.sensors)
        .where((s) => s.needsMaintenance);
    return [...buildingSensors, ...roadSensors].toList();
  }

  /// ==========================================================
  /// ACTUATOR ANALYTICS
  /// ==========================================================

  int get totalActuators => _infra.getAllActuators().length;

  int get healthyActuators =>
      _infra.buildings
          .expand((b) => b.actuators)
          .where((a) => a.isHealthy)
          .length +
      _infra.roads.expand((r) => r.actuators).where((a) => a.isHealthy).length;

  int get unresponsiveActuators => totalActuators - healthyActuators;

  List<ActuatorModel> getActuatorsNeedingMaintenance() {
    final buildingActuators = _infra.buildings
        .expand((b) => b.actuators)
        .where((a) => a.needsMaintenance);
    final roadActuators = _infra.roads
        .expand((r) => r.actuators)
        .where((a) => a.needsMaintenance);
    return [...buildingActuators, ...roadActuators].toList();
  }

  /// ==========================================================
  /// ZONE ANALYTICS
  /// ==========================================================

  double get averageEnvironmentalRisk => _infra.zones.isEmpty
      ? 0
      : _infra.zones.map((z) => z.environmentalRisk).reduce((a, b) => a + b) /
            _infra.zones.length;

  double get averageSafetyScore => _infra.zones.isEmpty
      ? 0
      : _infra.zones.map((z) => z.safetyScore).reduce((a, b) => a + b) /
            _infra.zones.length;

  /// ==========================================================
  /// COMPOSITE KPIs
  /// ==========================================================

  /// Infrastructure Health Index (0-100)
  double calculateInfrastructureHealthIndex() {
    final buildingHealth = 100 - averageBuildingRisk;
    final trafficHealth = averageTrafficFlow;
    final environmentalHealth = 100 - averageEnvironmentalRisk;

    // Weighted composite: 40% buildings, 30% traffic, 30% environment
    return (buildingHealth * 0.4) +
        (trafficHealth * 0.3) +
        (environmentalHealth * 0.3);
  }

  /// Overall City Risk Index
  double calculateCityRiskIndex() {
    final riskFactors = [
      averageBuildingRisk,
      averageRoadCongestion * 100,
      averageAccidentRisk,
      averageEnvironmentalRisk,
    ];
    return riskFactors.reduce((a, b) => a + b) / riskFactors.length;
  }

  /// ==========================================================
  /// DETAILED ANALYSIS METHODS
  /// ==========================================================

  Map<String, dynamic> generateBuildingReport() {
    return {
      'totalBuildings': _infra.buildings.length,
      'totalPopulation': totalPopulation,
      'energyUsage': totalEnergyUsage,
      'waterUsage': totalWaterUsage,
      'gasUsage': totalGasUsage,
      'averageRisk': averageBuildingRisk,
      'criticalBuildings': getCriticalBuildings()
          .map((b) => {'id': b.id, 'name': b.name})
          .toList(),
    };
  }

  Map<String, dynamic> generateRoadReport() {
    return {
      'totalRoads': _infra.roads.length,
      'averageCongestion': averageRoadCongestion,
      'averageAccidentRisk': averageAccidentRisk,
      'averageTrafficHealth': averageTrafficFlow,
    };
  }

  Map<String, dynamic> generateSensorReport() {
    return {
      'totalSensors': totalSensors,
      'onlineSensors': onlineSensors,
      'offlineSensors': offlineSensors,
      'healthPercentage': sensorHealthPercentage,
      'sensorsNeedingMaintenance': getSensorsNeedingMaintenance()
          .map((s) => s.id)
          .toList(),
    };
  }

  Map<String, dynamic> generateActuatorReport() {
    return {
      'totalActuators': totalActuators,
      'healthyActuators': healthyActuators,
      'unresponsiveActuators': unresponsiveActuators,
      'actuatorsNeedingMaintenance': getActuatorsNeedingMaintenance()
          .map((a) => a.id)
          .toList(),
    };
  }

  Map<String, dynamic> generateZoneReport() {
    return {
      'totalZones': _infra.zones.length,
      'averageEnvironmentalRisk': averageEnvironmentalRisk,
      'averageSafetyScore': averageSafetyScore,
    };
  }

  Map<String, dynamic> generateCityReport() {
    return {
      'buildings': generateBuildingReport(),
      'roads': generateRoadReport(),
      'sensors': generateSensorReport(),
      'actuators': generateActuatorReport(),
      'zones': generateZoneReport(),
      'infrastructureHealthIndex': calculateInfrastructureHealthIndex(),
      'cityRiskIndex': calculateCityRiskIndex(),
    };
  }

  /// ==========================================================
  /// REAL-TIME / ON-DEMAND ANALYSIS
  /// ==========================================================

  /// Get top N congested roads
  List<RoadModel> topCongestedRoads(int n) {
    final sorted = List<RoadModel>.from(_infra.roads)
      ..sort((a, b) => b.congestionLevel.compareTo(a.congestionLevel));
    return sorted.take(n).toList();
  }

  /// Get top N risky buildings
  List<BuildingModel> topRiskyBuildings(int n) {
    final sorted = List<BuildingModel>.from(_infra.buildings)
      ..sort((a, b) => (b.riskLevel).compareTo(a.riskLevel));
    return sorted.take(n).toList();
  }

  /// Get sensors with lowest battery
  List<SensorModel> lowBatterySensors(int threshold) {
    final allSensors = [
      ..._infra.buildings.expand((b) => b.sensors),
      ..._infra.roads.expand((r) => r.sensors),
    ];
    return allSensors
        .where((s) => (s.batteryPercentage ?? 100) < threshold)
        .toList();
  }

  /// ==========================================================
  /// FULL ANALYSIS FROM JSON MOCK DATA
  /// ==========================================================

  /// Load mock data and perform full analysis
  static Future<Map<String, dynamic>> analyzeFromMockData(
    InfrastructureService infra,
  ) async {
    await infra.loadMockData();
    final service = AnalyticsService(infra);
    return service.generateCityReport();
  }
}
