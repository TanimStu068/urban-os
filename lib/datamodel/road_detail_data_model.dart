import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/road_detail/recommandation.dart';

typedef C = AppColors;
const kAccent = C.cyan;

//  DATA MODELS
class RoadDetailData {
  final String id, name, type, district, status;
  final int congestion, speed, speedLimit, vehicles, capacity;
  final int incidents, lanes, length;
  final double reliability;
  final Color color;
  final List<double> congestion24h;
  final List<double> volume24h;
  final List<double> speed24h;
  final List<Incident> activeIncidents;
  final List<Sensor> sensors;
  final List<LaneInfo> laneInfo;
  final List<SpeedZone> speedZones;

  const RoadDetailData({
    required this.id,
    required this.name,
    required this.type,
    required this.district,
    required this.status,
    required this.congestion,
    required this.speed,
    required this.speedLimit,
    required this.vehicles,
    required this.capacity,
    required this.incidents,
    required this.lanes,
    required this.length,
    required this.reliability,
    required this.color,
    required this.congestion24h,
    required this.volume24h,
    required this.speed24h,
    required this.activeIncidents,
    required this.sensors,
    required this.laneInfo,
    required this.speedZones,
  });
}

class Incident {
  final String id, type, description, time, severity;
  final Color color;
  final IconData icon;
  final double position;
  const Incident({
    required this.id,
    required this.type,
    required this.description,
    required this.time,
    required this.severity,
    required this.color,
    required this.icon,
    required this.position,
  });
}

class Sensor {
  final String id, type, value, unit, location;
  final Color color;
  final IconData icon;
  final bool isOnline;
  final double signalStrength;
  const Sensor({
    required this.id,
    required this.type,
    required this.value,
    required this.unit,
    required this.location,
    required this.color,
    required this.icon,
    required this.isOnline,
    required this.signalStrength,
  });
}

class LaneInfo {
  final int laneNum;
  final String direction, type;
  final int speed, vehicles;
  final double congestion;
  const LaneInfo({
    required this.laneNum,
    required this.direction,
    required this.type,
    required this.speed,
    required this.vehicles,
    required this.congestion,
  });
}

class SpeedZone {
  final String name;
  final double startKm, endKm;
  final int currentSpeed, limit;
  const SpeedZone({
    required this.name,
    required this.startKm,
    required this.endKm,
    required this.currentSpeed,
    required this.limit,
  });
}

// ─────────────────────────────────────────
//  MOCK DATA — Ring Road 4
// ─────────────────────────────────────────
final sampleRoad = RoadDetailData(
  id: 'RD-04',
  name: 'Ring Road 4',
  type: 'ARTERIAL',
  district: 'Industrial District',
  status: 'HIGH CONGESTION',
  congestion: 88,
  speed: 22,
  speedLimit: 60,
  vehicles: 1240,
  capacity: 1400,
  incidents: 1,
  lanes: 4,
  length: 7800,
  reliability: 0.74,
  color: C.red,
  congestion24h: [
    12,
    10,
    8,
    9,
    14,
    28,
    62,
    85,
    88,
    87,
    84,
    82,
    80,
    84,
    87,
    88,
    86,
    82,
    79,
    72,
    60,
    44,
    28,
    18,
  ],
  volume24h: [
    120,
    95,
    78,
    65,
    80,
    148,
    440,
    820,
    1100,
    1180,
    1150,
    1080,
    990,
    1040,
    1140,
    1220,
    1280,
    1240,
    1060,
    880,
    720,
    540,
    340,
    190,
  ],
  speed24h: [
    58,
    60,
    61,
    61,
    59,
    52,
    38,
    26,
    22,
    23,
    25,
    27,
    30,
    26,
    23,
    22,
    21,
    24,
    28,
    34,
    42,
    50,
    56,
    59,
  ],
  activeIncidents: [
    Incident(
      id: 'INC-001',
      type: 'ACCIDENT',
      description: 'Minor collision — 2 vehicles, lane 1 blocked',
      time: '09:14',
      severity: 'HIGH',
      color: C.red,
      icon: Icons.car_crash_rounded,
      position: 0.38,
    ),
  ],
  sensors: [
    Sensor(
      id: 'SEN-101',
      type: 'VEHICLE COUNT',
      value: '1,240',
      unit: 'veh/h',
      location: 'Entry Node A',
      color: kAccent,
      icon: Icons.directions_car_rounded,
      isOnline: true,
      signalStrength: 0.92,
    ),
    Sensor(
      id: 'SEN-102',
      type: 'AVG SPEED',
      value: '22',
      unit: 'km/h',
      location: 'Mid-segment',
      color: C.amber,
      icon: Icons.speed_rounded,
      isOnline: true,
      signalStrength: 0.87,
    ),
    Sensor(
      id: 'SEN-103',
      type: 'AIR QUALITY',
      value: '142',
      unit: 'AQI',
      location: 'Exit Node B',
      color: C.orange,
      icon: Icons.air_rounded,
      isOnline: true,
      signalStrength: 0.78,
    ),
    Sensor(
      id: 'SEN-104',
      type: 'NOISE LEVEL',
      value: '74',
      unit: 'dB',
      location: 'Side Node C',
      color: C.violet,
      icon: Icons.graphic_eq_rounded,
      isOnline: true,
      signalStrength: 0.95,
    ),
    Sensor(
      id: 'SEN-105',
      type: 'ACCIDENT DET.',
      value: '1',
      unit: 'event',
      location: 'KM 2.9',
      color: C.red,
      icon: Icons.warning_amber_rounded,
      isOnline: true,
      signalStrength: 0.81,
    ),
    Sensor(
      id: 'SEN-106',
      type: 'WEATHER',
      value: '29°C',
      unit: 'clear',
      location: 'Overhead Mast',
      color: C.teal,
      icon: Icons.wb_sunny_rounded,
      isOnline: false,
      signalStrength: 0.0,
    ),
  ],
  laneInfo: [
    LaneInfo(
      laneNum: 1,
      direction: 'NE',
      type: 'GENERAL',
      speed: 18,
      vehicles: 380,
      congestion: 0.94,
    ),
    LaneInfo(
      laneNum: 2,
      direction: 'NE',
      type: 'GENERAL',
      speed: 20,
      vehicles: 340,
      congestion: 0.86,
    ),
    LaneInfo(
      laneNum: 3,
      direction: 'SW',
      type: 'GENERAL',
      speed: 24,
      vehicles: 290,
      congestion: 0.78,
    ),
    LaneInfo(
      laneNum: 4,
      direction: 'SW',
      type: 'FREIGHT',
      speed: 26,
      vehicles: 230,
      congestion: 0.65,
    ),
  ],
  speedZones: [
    SpeedZone(
      name: 'Zone A — Entry',
      startKm: 0.0,
      endKm: 1.8,
      currentSpeed: 18,
      limit: 60,
    ),
    SpeedZone(
      name: 'Zone B — Mid',
      startKm: 1.8,
      endKm: 4.5,
      currentSpeed: 22,
      limit: 60,
    ),
    SpeedZone(
      name: 'Zone C — Junction',
      startKm: 4.5,
      endKm: 6.2,
      currentSpeed: 16,
      limit: 40,
    ),
    SpeedZone(
      name: 'Zone D — Exit',
      startKm: 6.2,
      endKm: 7.8,
      currentSpeed: 30,
      limit: 60,
    ),
  ],
);
final sections = const ['OVERVIEW', 'CHARTS', 'LANES', 'SENSORS', 'ZONES'];
final sectionIcons = const [
  Icons.route_rounded,
  Icons.show_chart_rounded,
  Icons.view_column_rounded,
  Icons.sensors_rounded,
  Icons.speed_rounded,
];
List<Recommendation> getRecommendations() => [
  Recommendation(
    text: 'Extend green signal duration at Ring Rd 4 × Industrial Blvd by +20s',
    icon: Icons.traffic_rounded,
    color: kAccent,
    priority: 'HIGH',
  ),
  Recommendation(
    text: 'Activate dynamic speed boards — reduce limit to 40 km/h in Zone C',
    icon: Icons.speed_rounded,
    color: C.amber,
    priority: 'HIGH',
  ),
  Recommendation(
    text: 'Recommend alternate route via South Bypass for non-freight vehicles',
    icon: Icons.alt_route_rounded,
    color: C.teal,
    priority: 'MED',
  ),
  Recommendation(
    text: 'Deploy traffic management officer at KM 2.9 collision point',
    icon: Icons.person_rounded,
    color: C.violet,
    priority: 'MED',
  ),
  Recommendation(
    text: 'Increase AQI alert threshold — current reading at 142 (Unhealthy)',
    icon: Icons.air_rounded,
    color: C.orange,
    priority: 'LOW',
  ),
];
