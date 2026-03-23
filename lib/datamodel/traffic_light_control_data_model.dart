import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/infrastructure/road_model.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';

typedef C = AppColors;

// ─────────────────────────────────────────
//  MODELS
// ─────────────────────────────────────────
enum SignalPhase { green, yellow, red }

extension SignalPhaseX on SignalPhase {
  Color get color => this == SignalPhase.green
      ? C.green
      : this == SignalPhase.yellow
      ? C.amber
      : C.red;
  String get label => this == SignalPhase.green
      ? 'GREEN'
      : this == SignalPhase.yellow
      ? 'YELLOW'
      : 'RED';
  SignalPhase get next => this == SignalPhase.green
      ? SignalPhase.yellow
      : this == SignalPhase.yellow
      ? SignalPhase.red
      : SignalPhase.green;
  int get defaultDuration => this == SignalPhase.green
      ? 45
      : this == SignalPhase.yellow
      ? 5
      : 40;
}

class Intersection {
  final String id, name, road1, road2, district;
  final int totalVehicles;
  final bool hasCamera, hasSensor, hasPedestrian;
  SignalPhase phase;
  int timer;
  int greenDuration, yellowDuration, redDuration;
  bool isAdaptive;
  bool isEmergencyOverride;
  bool isPedestrianActive;
  int pedestrianCountdown;
  final List<int> phaseLog;
  final List<ApproachLane> approaches;

  Intersection({
    required this.id,
    required this.name,
    required this.road1,
    required this.road2,
    required this.district,
    required this.totalVehicles,
    required this.hasCamera,
    required this.hasSensor,
    required this.hasPedestrian,
    required this.phase,
    required this.timer,
    required this.greenDuration,
    required this.yellowDuration,
    required this.redDuration,
    required this.isAdaptive,
    required this.phaseLog,
    required this.approaches,
  }) : isEmergencyOverride = false,
       isPedestrianActive = false,
       pedestrianCountdown = 0;

  int get cycleDuration => greenDuration + yellowDuration + redDuration;
  double get phaseProgress => timer / _currentPhaseDuration;
  int get _currentPhaseDuration => phase == SignalPhase.green
      ? greenDuration
      : phase == SignalPhase.yellow
      ? yellowDuration
      : redDuration;
}

class ApproachLane {
  final String direction;
  final int waitingVehicles;
  final int queueLength;
  final bool hasArrow;
  const ApproachLane({
    required this.direction,
    required this.waitingVehicles,
    required this.queueLength,
    required this.hasArrow,
  });
}

// ─────────────────────────────────────────
//  HELPER: Build intersections from real provider data
// ─────────────────────────────────────────
List<Intersection> buildIntersectionsFromProviders(
  List<RoadModel> roads,
  List<SensorModel> sensors,
) {
  final intersections = <Intersection>[];
  for (int i = 0; i < roads.length && i < 5; i++) {
    final road = roads[i];
    final trafficSensors = sensors
        .where((s) => s.type == SensorType.trafficFlow)
        .toList();
    intersections.add(
      Intersection(
        id: road.id,
        name: road.name,
        road1: road.name,
        road2: 'Cross Street',
        district: road.districtId,
        totalVehicles: trafficSensors.isNotEmpty
            ? (trafficSensors.first.latestReading?.value.toInt() ?? 0)
            : 0,
        hasCamera: sensors.any((s) => s.type == SensorType.cctvActivity),
        hasSensor: trafficSensors.isNotEmpty,
        hasPedestrian: sensors.any((s) => s.type == SensorType.crowdDensity),
        phase: SignalPhase.green,
        timer: 38,
        greenDuration: 45,
        yellowDuration: 5,
        redDuration: 40,
        isAdaptive: true,
        phaseLog: [42, 45, 48, 43, 50, 45, 44, 47],
        approaches: const [
          ApproachLane(
            direction: 'N',
            waitingVehicles: 12,
            queueLength: 48,
            hasArrow: true,
          ),
          ApproachLane(
            direction: 'S',
            waitingVehicles: 8,
            queueLength: 32,
            hasArrow: true,
          ),
          ApproachLane(
            direction: 'E',
            waitingVehicles: 6,
            queueLength: 24,
            hasArrow: false,
          ),
          ApproachLane(
            direction: 'W',
            waitingVehicles: 10,
            queueLength: 40,
            hasArrow: false,
          ),
        ],
      ),
    );
  }
  return intersections.isNotEmpty ? intersections : buildIntersections();
}

// ─────────────────────────────────────────
//  MOCK DATA (Fallback)
// ─────────────────────────────────────────
List<Intersection> buildIntersections() => [
  Intersection(
    id: 'TL-01',
    name: 'Ring Rd × Industrial Blvd',
    road1: 'Ring Road 4',
    road2: 'Industrial Blvd',
    district: 'Industrial District',
    totalVehicles: 1840,
    hasCamera: true,
    hasSensor: true,
    hasPedestrian: true,
    phase: SignalPhase.green,
    timer: 38,
    greenDuration: 45,
    yellowDuration: 5,
    redDuration: 40,
    isAdaptive: true,
    phaseLog: [42, 45, 48, 43, 50, 45, 44, 47],
    approaches: const [
      ApproachLane(
        direction: 'N',
        waitingVehicles: 12,
        queueLength: 48,
        hasArrow: true,
      ),
      ApproachLane(
        direction: 'S',
        waitingVehicles: 8,
        queueLength: 32,
        hasArrow: true,
      ),
      ApproachLane(
        direction: 'E',
        waitingVehicles: 22,
        queueLength: 88,
        hasArrow: false,
      ),
      ApproachLane(
        direction: 'W',
        waitingVehicles: 18,
        queueLength: 72,
        hasArrow: false,
      ),
    ],
  ),
  Intersection(
    id: 'TL-02',
    name: 'Ring Rd × Freight F1',
    road1: 'Ring Road 4',
    road2: 'Freight Route F1',
    district: 'Industrial District',
    totalVehicles: 1560,
    hasCamera: true,
    hasSensor: true,
    hasPedestrian: false,
    phase: SignalPhase.red,
    timer: 22,
    greenDuration: 40,
    yellowDuration: 5,
    redDuration: 45,
    isAdaptive: true,
    phaseLog: [38, 40, 42, 40, 38, 41, 39, 40],
    approaches: const [
      ApproachLane(
        direction: 'N',
        waitingVehicles: 31,
        queueLength: 124,
        hasArrow: false,
      ),
      ApproachLane(
        direction: 'S',
        waitingVehicles: 27,
        queueLength: 108,
        hasArrow: false,
      ),
      ApproachLane(
        direction: 'E',
        waitingVehicles: 14,
        queueLength: 56,
        hasArrow: true,
      ),
      ApproachLane(
        direction: 'W',
        waitingVehicles: 19,
        queueLength: 76,
        hasArrow: true,
      ),
    ],
  ),
  Intersection(
    id: 'TL-03',
    name: 'Gate Rd × North Access',
    road1: 'Gate Road',
    road2: 'North Access',
    district: 'Transport Hub',
    totalVehicles: 2140,
    hasCamera: true,
    hasSensor: false,
    hasPedestrian: true,
    phase: SignalPhase.yellow,
    timer: 3,
    greenDuration: 30,
    yellowDuration: 5,
    redDuration: 55,
    isAdaptive: false,
    phaseLog: [30, 30, 30, 30, 30, 30, 30, 30],
    approaches: const [
      ApproachLane(
        direction: 'N',
        waitingVehicles: 44,
        queueLength: 176,
        hasArrow: true,
      ),
      ApproachLane(
        direction: 'S',
        waitingVehicles: 38,
        queueLength: 152,
        hasArrow: true,
      ),
      ApproachLane(
        direction: 'E',
        waitingVehicles: 6,
        queueLength: 24,
        hasArrow: false,
      ),
      ApproachLane(
        direction: 'W',
        waitingVehicles: 9,
        queueLength: 36,
        hasArrow: false,
      ),
    ],
  ),
  Intersection(
    id: 'TL-04',
    name: 'Industrial Blvd × South',
    road1: 'Industrial Blvd',
    road2: 'South Bypass',
    district: 'Commercial District',
    totalVehicles: 980,
    hasCamera: false,
    hasSensor: true,
    hasPedestrian: true,
    phase: SignalPhase.green,
    timer: 21,
    greenDuration: 35,
    yellowDuration: 5,
    redDuration: 35,
    isAdaptive: true,
    phaseLog: [33, 35, 37, 34, 36, 35, 34, 36],
    approaches: const [
      ApproachLane(
        direction: 'N',
        waitingVehicles: 5,
        queueLength: 20,
        hasArrow: false,
      ),
      ApproachLane(
        direction: 'S',
        waitingVehicles: 7,
        queueLength: 28,
        hasArrow: false,
      ),
      ApproachLane(
        direction: 'E',
        waitingVehicles: 11,
        queueLength: 44,
        hasArrow: true,
      ),
      ApproachLane(
        direction: 'W',
        waitingVehicles: 9,
        queueLength: 36,
        hasArrow: true,
      ),
    ],
  ),
  Intersection(
    id: 'TL-05',
    name: 'Freight F1 × Gate Rd',
    road1: 'Freight Route F1',
    road2: 'Gate Road',
    district: 'Industrial District',
    totalVehicles: 1120,
    hasCamera: true,
    hasSensor: true,
    hasPedestrian: false,
    phase: SignalPhase.red,
    timer: 14,
    greenDuration: 50,
    yellowDuration: 5,
    redDuration: 35,
    isAdaptive: false,
    phaseLog: [50, 50, 50, 50, 50, 50, 50, 50],
    approaches: const [
      ApproachLane(
        direction: 'N',
        waitingVehicles: 16,
        queueLength: 64,
        hasArrow: false,
      ),
      ApproachLane(
        direction: 'S',
        waitingVehicles: 20,
        queueLength: 80,
        hasArrow: false,
      ),
      ApproachLane(
        direction: 'E',
        waitingVehicles: 8,
        queueLength: 32,
        hasArrow: true,
      ),
      ApproachLane(
        direction: 'W',
        waitingVehicles: 12,
        queueLength: 48,
        hasArrow: true,
      ),
    ],
  ),
  Intersection(
    id: 'TL-06',
    name: 'North Access × Ring Rd 4',
    road1: 'North Access',
    road2: 'Ring Road 4',
    district: 'Transport Hub',
    totalVehicles: 2380,
    hasCamera: true,
    hasSensor: true,
    hasPedestrian: true,
    phase: SignalPhase.green,
    timer: 44,
    greenDuration: 60,
    yellowDuration: 5,
    redDuration: 55,
    isAdaptive: true,
    phaseLog: [58, 60, 62, 60, 59, 61, 60, 58],
    approaches: const [
      ApproachLane(
        direction: 'N',
        waitingVehicles: 38,
        queueLength: 152,
        hasArrow: true,
      ),
      ApproachLane(
        direction: 'S',
        waitingVehicles: 42,
        queueLength: 168,
        hasArrow: true,
      ),
      ApproachLane(
        direction: 'E',
        waitingVehicles: 28,
        queueLength: 112,
        hasArrow: false,
      ),
      ApproachLane(
        direction: 'W',
        waitingVehicles: 33,
        queueLength: 132,
        hasArrow: false,
      ),
    ],
  ),
];
