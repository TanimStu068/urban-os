import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;
// ─────────────────────────────────────────
//  MOCK DATA MODELS
// ─────────────────────────────────────────

class RoadSegment {
  final String id, name, type;
  final int congestion; // 0-100 %
  final int speed; // km/h
  final int vehicles; // veh/h
  final int incidents;
  final Color color;
  final List<double> history24h; // 24 hourly congestion values
  const RoadSegment({
    required this.id,
    required this.name,
    required this.type,
    required this.congestion,
    required this.speed,
    required this.vehicles,
    required this.incidents,
    required this.color,
    required this.history24h,
  });
}

class TrafficLight {
  final String id, intersection;
  String phase; // 'GREEN' | 'YELLOW' | 'RED'
  int phaseTimer; // seconds remaining
  final int cycleTime;
  bool isAdaptive;
  TrafficLight({
    required this.id,
    required this.intersection,
    required this.phase,
    required this.phaseTimer,
    required this.cycleTime,
    required this.isAdaptive,
  });
}

class TrafficIncident {
  final String id, type, road, description;
  final Color color;
  final IconData icon;
  final String time;
  final String severity;
  bool isActive;
  TrafficIncident({
    required this.id,
    required this.type,
    required this.road,
    required this.description,
    required this.color,
    required this.icon,
    required this.time,
    required this.severity,
    required this.isActive,
  });
}

class ParkingZone {
  final String id, name;
  final int total, occupied;
  final Color color;
  const ParkingZone({
    required this.id,
    required this.name,
    required this.total,
    required this.occupied,
    required this.color,
  });
  double get occupancyRate => occupied / total;
}

// ─────────────────────────────────────────
//  MOCK DATA
// ─────────────────────────────────────────

const roads = [
  RoadSegment(
    id: 'RD-04',
    name: 'Ring Road 4',
    type: 'ARTERIAL',
    congestion: 88,
    speed: 22,
    vehicles: 1240,
    incidents: 1,
    color: C.red,
    history24h: [
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
  ),
  RoadSegment(
    id: 'RD-11',
    name: 'Industrial Blvd',
    type: 'MAJOR',
    congestion: 72,
    speed: 34,
    vehicles: 980,
    incidents: 0,
    color: C.amber,
    history24h: [
      8,
      7,
      6,
      6,
      10,
      22,
      48,
      72,
      74,
      71,
      68,
      66,
      64,
      68,
      72,
      73,
      71,
      68,
      64,
      58,
      44,
      32,
      20,
      12,
    ],
  ),
  RoadSegment(
    id: 'RD-18',
    name: 'Freight Route F1',
    type: 'FREIGHT',
    congestion: 61,
    speed: 42,
    vehicles: 760,
    incidents: 0,
    color: C.amber,
    history24h: [
      22,
      20,
      18,
      20,
      28,
      38,
      52,
      62,
      64,
      62,
      60,
      58,
      56,
      58,
      62,
      63,
      61,
      59,
      54,
      48,
      40,
      34,
      28,
      24,
    ],
  ),
  RoadSegment(
    id: 'RD-22',
    name: 'Gate Road',
    type: 'LOCAL',
    congestion: 35,
    speed: 54,
    vehicles: 420,
    incidents: 0,
    color: C.green,
    history24h: [
      10,
      8,
      6,
      7,
      12,
      20,
      28,
      36,
      38,
      36,
      34,
      32,
      30,
      32,
      36,
      37,
      35,
      33,
      30,
      26,
      22,
      18,
      14,
      11,
    ],
  ),
  RoadSegment(
    id: 'RD-27',
    name: 'North Access',
    type: 'ACCESS',
    congestion: 91,
    speed: 18,
    vehicles: 1480,
    incidents: 2,
    color: C.red,
    history24h: [
      20,
      18,
      15,
      16,
      22,
      45,
      78,
      88,
      91,
      92,
      90,
      88,
      86,
      88,
      91,
      92,
      90,
      88,
      84,
      78,
      64,
      50,
      36,
      24,
    ],
  ),
  RoadSegment(
    id: 'RD-33',
    name: 'South Bypass',
    type: 'BYPASS',
    congestion: 28,
    speed: 68,
    vehicles: 340,
    incidents: 0,
    color: C.green,
    history24h: [
      8,
      6,
      5,
      6,
      10,
      16,
      22,
      28,
      30,
      28,
      26,
      24,
      22,
      24,
      28,
      30,
      28,
      26,
      24,
      20,
      18,
      15,
      12,
      9,
    ],
  ),
];

List<TrafficLight> buildLights() => [
  TrafficLight(
    id: 'TL-01',
    intersection: 'Ring Rd × Industrial Blvd',
    phase: 'GREEN',
    phaseTimer: 38,
    cycleTime: 90,
    isAdaptive: true,
  ),
  TrafficLight(
    id: 'TL-02',
    intersection: 'Ring Rd × Freight F1',
    phase: 'RED',
    phaseTimer: 52,
    cycleTime: 90,
    isAdaptive: true,
  ),
  TrafficLight(
    id: 'TL-03',
    intersection: 'Gate Rd × North Access',
    phase: 'YELLOW',
    phaseTimer: 4,
    cycleTime: 60,
    isAdaptive: false,
  ),
  TrafficLight(
    id: 'TL-04',
    intersection: 'Industrial Blvd × South',
    phase: 'GREEN',
    phaseTimer: 21,
    cycleTime: 75,
    isAdaptive: true,
  ),
  TrafficLight(
    id: 'TL-05',
    intersection: 'Freight F1 × Gate Rd',
    phase: 'RED',
    phaseTimer: 14,
    cycleTime: 60,
    isAdaptive: false,
  ),
  TrafficLight(
    id: 'TL-06',
    intersection: 'North Access × Ring Rd 4',
    phase: 'GREEN',
    phaseTimer: 44,
    cycleTime: 120,
    isAdaptive: true,
  ),
];

List<TrafficIncident> buildIncidents() => [
  TrafficIncident(
    id: 'INC-001',
    type: 'ACCIDENT',
    road: 'Ring Road 4',
    description: 'Minor collision — 2 vehicles, lane 1 blocked',
    color: C.red,
    icon: Icons.car_crash_rounded,
    time: '09:14',
    severity: 'HIGH',
    isActive: true,
  ),
  TrafficIncident(
    id: 'INC-002',
    type: 'CONGESTION',
    road: 'North Access',
    description: 'Freight convoy — unusually high vehicle density',
    color: C.amber,
    icon: Icons.traffic_rounded,
    time: '08:52',
    severity: 'HIGH',
    isActive: true,
  ),
  TrafficIncident(
    id: 'INC-003',
    type: 'ROAD WORK',
    road: 'North Access',
    description: 'Scheduled maintenance — lane 2 closed until 14:00',
    color: C.orange,
    icon: Icons.construction_rounded,
    time: '07:30',
    severity: 'MEDIUM',
    isActive: true,
  ),
  TrafficIncident(
    id: 'INC-004',
    type: 'BREAKDOWN',
    road: 'Industrial Blvd',
    description: 'Heavy vehicle breakdown — shoulder lane',
    color: C.amber,
    icon: Icons.local_shipping_rounded,
    time: '10:03',
    severity: 'LOW',
    isActive: true,
  ),
  TrafficIncident(
    id: 'INC-005',
    type: 'CLEARED',
    road: 'Freight F1',
    description: 'Earlier spill cleared — traffic normalising',
    color: C.green,
    icon: Icons.check_circle_outline_rounded,
    time: '06:45',
    severity: 'INFO',
    isActive: false,
  ),
];

const parking = [
  ParkingZone(
    id: 'PK-A',
    name: 'Lot A — Plant Entry',
    total: 220,
    occupied: 198,
    color: C.red,
  ),
  ParkingZone(
    id: 'PK-B',
    name: 'Lot B — Admin Block',
    total: 150,
    occupied: 87,
    color: C.amber,
  ),
  ParkingZone(
    id: 'PK-C',
    name: 'Lot C — Freight Depot',
    total: 80,
    occupied: 42,
    color: C.green,
  ),
  ParkingZone(
    id: 'PK-D',
    name: 'Lot D — Visitor Center',
    total: 60,
    occupied: 54,
    color: C.red,
  ),
];

// 24h peak hourly vehicle count (for main chart)
const peakHourly = [
  120.0,
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
];

const speedZoneData = [
  ('RING RD 4', 22, 60, C.red),
  ('IND BLVD', 34, 60, C.amber),
  ('FREIGHT F1', 42, 80, C.amber),
  ('GATE RD', 54, 60, C.green),
  ('N. ACCESS', 18, 50, C.red),
  ('S. BYPASS', 68, 80, C.green),
];

// ─────────────────────────────────────────
//  LIVE VEHICLE SIMULATION
// ─────────────────────────────────────────
class LiveVehicle {
  double progress;
  final int laneIdx; // which road line in the road-flow painter
  final Color color;
  final double speed;
  LiveVehicle({
    required this.progress,
    required this.laneIdx,
    required this.color,
    required this.speed,
  });
}
