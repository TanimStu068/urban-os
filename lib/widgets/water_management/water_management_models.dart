import 'dart:math';
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
//  COLOR PALETTE
// ═══════════════════════════════════════════════════════════════
class C {
  static const bg = Color(0xFF020810);
  static const bgDeep = Color(0xFF020408);
  static const bgMid = Color(0xFF050C14);
  static const bgCard = Color(0xFF051525);
  static const bgCard2 = Color(0xFF071A30);
  static const bgCard3 = Color(0xFF040F1E);
  static const cyan = Color(0xFF00D4FF);
  static const cyanDim = Color(0xFF0099BB);
  static const teal = Color(0xFF00FFCC);
  static const mint = Color(0xFF6EFFC8);
  static const green = Color(0xFF00FF88);
  static const amber = Color(0xFFFFAA00);
  static const orange = Color(0xFFFF6B00);
  static const red = Color(0xFFFF2244);
  static const violet = Color(0xFF8B5CF6);
  static const pink = Color(0xFFFF4488);
  static const yellow = Color(0xFFFFE033);
  static const lime = Color(0xFFBBFF00);
  static const sky = Color(0xFF38BDF8);
  static const white = Color(0xFFE8F4F8);
  static const muted = Color(0xFF2A4560);
  static const mutedLt = Color(0xFF4A7090);
  static const mutedHi = Color(0xFF6B8CA0);
  static const gBdr = Color(0x1A00D4FF);
  static const gBg = Color(0x0A00D4FF);
  static const glassBdr = Color(0x2600D4FF);
}

enum TankStatus { normal, low, critical, filling, draining, isolated, overflow }

enum PipeStatus { flowing, reduced, closed, burst, maintenance }

enum PumpStatus { running, standby, fault, off }

enum WaterQuality { excellent, good, fair, poor, contaminated }

enum ZoneType {
  residential,
  industrial,
  medical,
  commercial,
  irrigation,
  emergency,
}

enum AlertLevel { critical, warning, info }

extension TankStatusX on TankStatus {
  Color get color => const {
    TankStatus.normal: C.cyan,
    TankStatus.low: C.amber,
    TankStatus.critical: C.red,
    TankStatus.filling: C.green,
    TankStatus.draining: C.sky,
    TankStatus.isolated: C.mutedHi,
    TankStatus.overflow: C.violet,
  }[this]!;

  String get label => const {
    TankStatus.normal: 'NORMAL',
    TankStatus.low: 'LOW',
    TankStatus.critical: 'CRITICAL',
    TankStatus.filling: 'FILLING',
    TankStatus.draining: 'DRAINING',
    TankStatus.isolated: 'ISOLATED',
    TankStatus.overflow: 'OVERFLOW',
  }[this]!;

  IconData get icon => const {
    TankStatus.normal: Icons.water_drop_rounded,
    TankStatus.low: Icons.warning_rounded,
    TankStatus.critical: Icons.error_rounded,
    TankStatus.filling: Icons.arrow_upward_rounded,
    TankStatus.draining: Icons.arrow_downward_rounded,
    TankStatus.isolated: Icons.do_not_disturb_rounded,
    TankStatus.overflow: Icons.warning_amber_rounded,
  }[this]!;

  bool get isAlert =>
      this == TankStatus.critical ||
      this == TankStatus.low ||
      this == TankStatus.overflow;
}

extension PipeStatusX on PipeStatus {
  Color get color => const {
    PipeStatus.flowing: C.cyan,
    PipeStatus.reduced: C.amber,
    PipeStatus.closed: C.mutedHi,
    PipeStatus.burst: C.red,
    PipeStatus.maintenance: C.violet,
  }[this]!;

  String get label => const {
    PipeStatus.flowing: 'FLOWING',
    PipeStatus.reduced: 'REDUCED',
    PipeStatus.closed: 'CLOSED',
    PipeStatus.burst: 'BURST',
    PipeStatus.maintenance: 'MAINT',
  }[this]!;

  bool get isActive => this == PipeStatus.flowing || this == PipeStatus.reduced;
  bool get isAlert => this == PipeStatus.burst || this == PipeStatus.reduced;
}

extension PumpStatusX on PumpStatus {
  Color get color => const {
    PumpStatus.running: C.green,
    PumpStatus.standby: C.amber,
    PumpStatus.fault: C.red,
    PumpStatus.off: C.mutedHi,
  }[this]!;

  String get label => const {
    PumpStatus.running: 'RUNNING',
    PumpStatus.standby: 'STANDBY',
    PumpStatus.fault: 'FAULT',
    PumpStatus.off: 'OFF',
  }[this]!;
}

extension WaterQualityX on WaterQuality {
  Color get color => const {
    WaterQuality.excellent: C.teal,
    WaterQuality.good: C.green,
    WaterQuality.fair: C.sky,
    WaterQuality.poor: C.amber,
    WaterQuality.contaminated: C.red,
  }[this]!;

  String get label => const {
    WaterQuality.excellent: 'EXCELLENT',
    WaterQuality.good: 'GOOD',
    WaterQuality.fair: 'FAIR',
    WaterQuality.poor: 'POOR',
    WaterQuality.contaminated: 'CONTAM',
  }[this]!;
}

extension ZoneTypeX on ZoneType {
  Color get color => const {
    ZoneType.residential: C.cyan,
    ZoneType.industrial: C.orange,
    ZoneType.medical: C.green,
    ZoneType.commercial: C.sky,
    ZoneType.irrigation: C.lime,
    ZoneType.emergency: C.red,
  }[this]!;

  String get label => const {
    ZoneType.residential: 'Residential',
    ZoneType.industrial: 'Industrial',
    ZoneType.medical: 'Medical',
    ZoneType.commercial: 'Commercial',
    ZoneType.irrigation: 'Irrigation',
    ZoneType.emergency: 'Emergency',
  }[this]!;

  IconData get icon => const {
    ZoneType.residential: Icons.home_rounded,
    ZoneType.industrial: Icons.factory_rounded,
    ZoneType.medical: Icons.local_hospital_rounded,
    ZoneType.commercial: Icons.store_rounded,
    ZoneType.irrigation: Icons.grass_rounded,
    ZoneType.emergency: Icons.emergency_rounded,
  }[this]!;
}

extension AlertLevelX on AlertLevel {
  Color get color => const {
    AlertLevel.critical: C.red,
    AlertLevel.warning: C.amber,
    AlertLevel.info: C.sky,
  }[this]!;

  String get label => const {
    AlertLevel.critical: 'CRITICAL',
    AlertLevel.warning: 'WARNING',
    AlertLevel.info: 'INFO',
  }[this]!;

  IconData get icon => const {
    AlertLevel.critical: Icons.error_rounded,
    AlertLevel.warning: Icons.warning_rounded,
    AlertLevel.info: Icons.info_rounded,
  }[this]!;
}

class WaterTank {
  final String id, name, location;
  double levelPct;
  final double capacityML;
  TankStatus status;
  double inflow, outflow;
  WaterQuality quality;
  double tempC, ph, turbidity, chlorine;
  bool autoRefill;
  final List<double> levelHistory;

  WaterTank({
    required this.id,
    required this.name,
    required this.location,
    required this.levelPct,
    required this.capacityML,
    required this.status,
    required this.inflow,
    required this.outflow,
    required this.quality,
    required this.tempC,
    required this.ph,
    required this.turbidity,
    required this.chlorine,
    required this.autoRefill,
    required this.levelHistory,
  });

  double get volumeML => capacityML * levelPct / 100;
  double get netFlow => inflow - outflow;
}

class WaterPipe {
  final String id, name, fromNode, toNode;
  double flowRate;
  final double maxFlow;
  double pressureBar;
  PipeStatus status;
  final double diameterMM, lengthM;
  bool hasLeak;
  double leakPct;

  WaterPipe({
    required this.id,
    required this.name,
    required this.fromNode,
    required this.toNode,
    required this.flowRate,
    required this.maxFlow,
    required this.pressureBar,
    required this.status,
    required this.diameterMM,
    required this.lengthM,
    required this.hasLeak,
    required this.leakPct,
  });

  double get utilPct =>
      maxFlow > 0 ? (flowRate / maxFlow * 100).clamp(0, 100) : 0;
}

class WaterPump {
  final String id, name, zone, nextMaint;
  PumpStatus status;
  double speedPct, flowRateLS, pressureBar, powerKW, effPct;
  final int runHours;
  final List<double> flowHistory;

  WaterPump({
    required this.id,
    required this.name,
    required this.zone,
    required this.nextMaint,
    required this.status,
    required this.speedPct,
    required this.flowRateLS,
    required this.pressureBar,
    required this.powerKW,
    required this.effPct,
    required this.runHours,
    required this.flowHistory,
  });
}

class DistZone {
  final String id, name;
  final ZoneType type;
  double demandLS, supplyLS, pressureBar;
  WaterQuality quality;
  final int population;
  double lpcd;
  final List<double> usageHistory;

  DistZone({
    required this.id,
    required this.name,
    required this.type,
    required this.demandLS,
    required this.supplyLS,
    required this.pressureBar,
    required this.quality,
    required this.population,
    required this.lpcd,
    required this.usageHistory,
  });

  double get ratio => demandLS > 0 ? (supplyLS / demandLS).clamp(0, 2) : 1.0;
  bool get adequate => ratio >= 0.9;
  Color get statusColor => ratio >= 1.0
      ? C.green
      : ratio >= 0.8
      ? C.amber
      : C.red;
}

class WaterAlert {
  final String id, message, source, time;
  final AlertLevel level;
  bool acked;

  WaterAlert({
    required this.id,
    required this.message,
    required this.source,
    required this.time,
    required this.level,
    this.acked = false,
  });
}

class HrUsage {
  final int h;
  final double cons, supply;
  HrUsage(this.h, this.cons, this.supply);
}

List<double> _rh(double lo, double hi, [int n = 24]) {
  final r = Random(lo.toInt() + hi.toInt() + 7);
  return List.generate(n, (_) => lo + r.nextDouble() * (hi - lo));
}

List<WaterTank> buildTanks() => [
  WaterTank(
    id: 'T-01',
    name: 'RESERVOIR ALPHA',
    location: 'North Hub',
    levelPct: 72,
    capacityML: 50,
    status: TankStatus.normal,
    inflow: 120,
    outflow: 95,
    quality: WaterQuality.excellent,
    tempC: 18.2,
    ph: 7.2,
    turbidity: .30,
    chlorine: .55,
    autoRefill: true,
    levelHistory: _rh(55, 82),
  ),
  WaterTank(
    id: 'T-02',
    name: 'STORAGE BETA',
    location: 'Industrial',
    levelPct: 26,
    capacityML: 30,
    status: TankStatus.low,
    inflow: 42,
    outflow: 58,
    quality: WaterQuality.good,
    tempC: 19.8,
    ph: 7.0,
    turbidity: .62,
    chlorine: .48,
    autoRefill: true,
    levelHistory: _rh(18, 45),
  ),
  WaterTank(
    id: 'T-03',
    name: 'MEDICAL RESERVE',
    location: 'Medical Dist.',
    levelPct: 93,
    capacityML: 10,
    status: TankStatus.filling,
    inflow: 30,
    outflow: 14,
    quality: WaterQuality.excellent,
    tempC: 17.5,
    ph: 7.4,
    turbidity: .11,
    chlorine: .72,
    autoRefill: true,
    levelHistory: _rh(70, 95),
  ),
  WaterTank(
    id: 'T-04',
    name: 'EMERGENCY SUPPLY',
    location: 'Gov Zone',
    levelPct: 11,
    capacityML: 20,
    status: TankStatus.critical,
    inflow: 0,
    outflow: 9,
    quality: WaterQuality.good,
    tempC: 20.1,
    ph: 7.1,
    turbidity: .44,
    chlorine: .50,
    autoRefill: false,
    levelHistory: _rh(4, 28),
  ),
  WaterTank(
    id: 'T-05',
    name: 'IRRIGATION TANK',
    location: 'Green Zone',
    levelPct: 54,
    capacityML: 15,
    status: TankStatus.draining,
    inflow: 10,
    outflow: 34,
    quality: WaterQuality.fair,
    tempC: 22.0,
    ph: 6.8,
    turbidity: 1.24,
    chlorine: .32,
    autoRefill: false,
    levelHistory: _rh(28, 72),
  ),
  WaterTank(
    id: 'T-06',
    name: 'SOUTH RESERVOIR',
    location: 'South Dist.',
    levelPct: 83,
    capacityML: 40,
    status: TankStatus.normal,
    inflow: 82,
    outflow: 71,
    quality: WaterQuality.good,
    tempC: 18.9,
    ph: 7.3,
    turbidity: .52,
    chlorine: .61,
    autoRefill: true,
    levelHistory: _rh(62, 90),
  ),
];

List<WaterPipe> buildPipes() => [
  WaterPipe(
    id: 'P-01',
    name: 'MAIN TRUNK NORTH',
    fromNode: 'T-01',
    toNode: 'Z-RES',
    flowRate: 88,
    maxFlow: 120,
    pressureBar: 4.2,
    status: PipeStatus.flowing,
    diameterMM: 600,
    lengthM: 2400,
    hasLeak: false,
    leakPct: 0.0,
  ),
  WaterPipe(
    id: 'P-02',
    name: 'INDUSTRIAL FEED',
    fromNode: 'T-02',
    toNode: 'Z-IND',
    flowRate: 41,
    maxFlow: 80,
    pressureBar: 3.8,
    status: PipeStatus.reduced,
    diameterMM: 400,
    lengthM: 1800,
    hasLeak: true,
    leakPct: 4.2,
  ),
  WaterPipe(
    id: 'P-03',
    name: 'MEDICAL PRIORITY',
    fromNode: 'T-03',
    toNode: 'Z-MED',
    flowRate: 14,
    maxFlow: 25,
    pressureBar: 5.1,
    status: PipeStatus.flowing,
    diameterMM: 200,
    lengthM: 900,
    hasLeak: false,
    leakPct: 0.0,
  ),
  WaterPipe(
    id: 'P-04',
    name: 'EMERGENCY LINE',
    fromNode: 'T-04',
    toNode: 'Z-EMR',
    flowRate: 0,
    maxFlow: 60,
    pressureBar: 0.0,
    status: PipeStatus.closed,
    diameterMM: 350,
    lengthM: 1200,
    hasLeak: false,
    leakPct: 0.0,
  ),
  WaterPipe(
    id: 'P-05',
    name: 'IRRIGATION SUPPLY',
    fromNode: 'T-05',
    toNode: 'Z-IRR',
    flowRate: 32,
    maxFlow: 40,
    pressureBar: 2.9,
    status: PipeStatus.flowing,
    diameterMM: 250,
    lengthM: 3200,
    hasLeak: false,
    leakPct: 0.0,
  ),
  WaterPipe(
    id: 'P-06',
    name: 'SOUTH MAIN',
    fromNode: 'T-06',
    toNode: 'Z-COM',
    flowRate: 68,
    maxFlow: 100,
    pressureBar: 4.0,
    status: PipeStatus.flowing,
    diameterMM: 500,
    lengthM: 2100,
    hasLeak: false,
    leakPct: 0.0,
  ),
  WaterPipe(
    id: 'P-07',
    name: 'INTER-CONNECT A',
    fromNode: 'T-01',
    toNode: 'T-06',
    flowRate: 22,
    maxFlow: 50,
    pressureBar: 3.5,
    status: PipeStatus.flowing,
    diameterMM: 300,
    lengthM: 800,
    hasLeak: false,
    leakPct: 0.0,
  ),
  WaterPipe(
    id: 'P-08',
    name: 'BURST SECTOR 4',
    fromNode: 'Z-IND',
    toNode: 'Z-COM',
    flowRate: 0,
    maxFlow: 45,
    pressureBar: 0.8,
    status: PipeStatus.burst,
    diameterMM: 280,
    lengthM: 600,
    hasLeak: true,
    leakPct: 100.0,
  ),
  WaterPipe(
    id: 'P-09',
    name: 'TREATMENT OUTLET',
    fromNode: 'WTP',
    toNode: 'T-01',
    flowRate: 115,
    maxFlow: 150,
    pressureBar: 4.8,
    status: PipeStatus.flowing,
    diameterMM: 700,
    lengthM: 400,
    hasLeak: false,
    leakPct: 0.0,
  ),
  WaterPipe(
    id: 'P-10',
    name: 'MAINTENANCE LINE C',
    fromNode: 'T-02',
    toNode: 'T-04',
    flowRate: 0,
    maxFlow: 30,
    pressureBar: 0.0,
    status: PipeStatus.maintenance,
    diameterMM: 200,
    lengthM: 1100,
    hasLeak: false,
    leakPct: 0.0,
  ),
];

List<WaterPump> buildPumps() => [
  WaterPump(
    id: 'PMP-01',
    name: 'BOOSTER NORTH',
    zone: 'North Hub',
    nextMaint: '2025-02-15',
    status: PumpStatus.running,
    speedPct: 82,
    flowRateLS: 95,
    pressureBar: 4.5,
    powerKW: 45,
    effPct: 88,
    runHours: 14280,
    flowHistory: _rh(70, 105),
  ),
  WaterPump(
    id: 'PMP-02',
    name: 'INDUSTRIAL MAIN',
    zone: 'Industrial',
    nextMaint: '2025-03-01',
    status: PumpStatus.running,
    speedPct: 65,
    flowRateLS: 58,
    pressureBar: 3.9,
    powerKW: 38,
    effPct: 82,
    runHours: 9840,
    flowHistory: _rh(40, 72),
  ),
  WaterPump(
    id: 'PMP-03',
    name: 'TREATMENT PUMP',
    zone: 'WTP',
    nextMaint: '2025-01-25',
    status: PumpStatus.running,
    speedPct: 90,
    flowRateLS: 118,
    pressureBar: 5.2,
    powerKW: 75,
    effPct: 91,
    runHours: 21600,
    flowHistory: _rh(88, 130),
  ),
  WaterPump(
    id: 'PMP-04',
    name: 'SOUTH BOOSTER',
    zone: 'South Dist.',
    nextMaint: '2025-04-10',
    status: PumpStatus.standby,
    speedPct: 0,
    flowRateLS: 0,
    pressureBar: 0.0,
    powerKW: 0,
    effPct: 0,
    runHours: 6200,
    flowHistory: _rh(0, 10),
  ),
  WaterPump(
    id: 'PMP-05',
    name: 'EMERGENCY PUMP',
    zone: 'Gov Zone',
    nextMaint: '2025-01-18',
    status: PumpStatus.fault,
    speedPct: 0,
    flowRateLS: 0,
    pressureBar: 0.0,
    powerKW: 0,
    effPct: 0,
    runHours: 3350,
    flowHistory: _rh(0, 6),
  ),
  WaterPump(
    id: 'PMP-06',
    name: 'IRRIGATION CTRL',
    zone: 'Green Zone',
    nextMaint: '2025-05-01',
    status: PumpStatus.running,
    speedPct: 72,
    flowRateLS: 34,
    pressureBar: 3.0,
    powerKW: 22,
    effPct: 79,
    runHours: 5400,
    flowHistory: _rh(24, 44),
  ),
];

List<DistZone> buildZones() => [
  DistZone(
    id: 'Z-RES',
    name: 'Residential',
    type: ZoneType.residential,
    demandLS: 85,
    supplyLS: 88,
    pressureBar: 4.1,
    quality: WaterQuality.excellent,
    population: 45000,
    lpcd: 162,
    usageHistory: _rh(60, 100),
  ),
  DistZone(
    id: 'Z-IND',
    name: 'Industrial',
    type: ZoneType.industrial,
    demandLS: 120,
    supplyLS: 97,
    pressureBar: 3.6,
    quality: WaterQuality.good,
    population: 0,
    lpcd: 0,
    usageHistory: _rh(80, 130),
  ),
  DistZone(
    id: 'Z-MED',
    name: 'Medical',
    type: ZoneType.medical,
    demandLS: 14,
    supplyLS: 14,
    pressureBar: 5.0,
    quality: WaterQuality.excellent,
    population: 1200,
    lpcd: 420,
    usageHistory: _rh(10, 20),
  ),
  DistZone(
    id: 'Z-COM',
    name: 'Commercial',
    type: ZoneType.commercial,
    demandLS: 65,
    supplyLS: 68,
    pressureBar: 3.9,
    quality: WaterQuality.good,
    population: 8000,
    lpcd: 85,
    usageHistory: _rh(40, 80),
  ),
  DistZone(
    id: 'Z-IRR',
    name: 'Irrigation',
    type: ZoneType.irrigation,
    demandLS: 38,
    supplyLS: 32,
    pressureBar: 2.8,
    quality: WaterQuality.fair,
    population: 0,
    lpcd: 0,
    usageHistory: _rh(20, 50),
  ),
  DistZone(
    id: 'Z-EMR',
    name: 'Emergency',
    type: ZoneType.emergency,
    demandLS: 60,
    supplyLS: 0,
    pressureBar: 0.0,
    quality: WaterQuality.good,
    population: 500,
    lpcd: 200,
    usageHistory: _rh(0, 5),
  ),
];

List<WaterAlert> buildAlerts() => [
  WaterAlert(
    id: 'WA-001',
    message: 'Pipe P-08 burst — Sector 4 offline, 100% loss',
    source: 'P-08',
    time: '10:14',
    level: AlertLevel.critical,
  ),
  WaterAlert(
    id: 'WA-002',
    message: 'Emergency tank T-04 critically low (11%)',
    source: 'T-04',
    time: '10:08',
    level: AlertLevel.critical,
  ),
  WaterAlert(
    id: 'WA-003',
    message: 'Pump PMP-05 fault in emergency response zone',
    source: 'PMP-05',
    time: '09:52',
    level: AlertLevel.critical,
  ),
  WaterAlert(
    id: 'WA-004',
    message: 'Leak detected on P-02 — 4.2% flow loss rate',
    source: 'P-02',
    time: '09:31',
    level: AlertLevel.warning,
  ),
  WaterAlert(
    id: 'WA-005',
    message: 'Tank T-02 (Industrial) below 30% threshold',
    source: 'T-02',
    time: '09:15',
    level: AlertLevel.warning,
  ),
  WaterAlert(
    id: 'WA-006',
    message: 'Industrial zone supply at 81% of demand',
    source: 'Z-IND',
    time: '08:55',
    level: AlertLevel.warning,
  ),
  WaterAlert(
    id: 'WA-007',
    message: 'Irrigation zone demand exceeding supply',
    source: 'Z-IRR',
    time: '08:40',
    level: AlertLevel.warning,
  ),
  WaterAlert(
    id: 'WA-008',
    message: 'PMP-03 scheduled maintenance in 5 days',
    source: 'PMP-03',
    time: '07:00',
    level: AlertLevel.info,
  ),
  WaterAlert(
    id: 'WA-009',
    message: 'Water treatment plant operating at normal parameters',
    source: 'WTP',
    time: '06:00',
    level: AlertLevel.info,
    acked: true,
  ),
  WaterAlert(
    id: 'WA-010',
    message: 'T-05 auto-refill disabled — manual drain in progress',
    source: 'T-05',
    time: '05:30',
    level: AlertLevel.info,
    acked: true,
  ),
];

List<HrUsage> buildHourly() {
  final r = Random(7);
  return List.generate(24, (h) {
    final pk = (h >= 6 && h <= 9)
        ? 1.55
        : (h >= 18 && h <= 21)
        ? 1.35
        : (h >= 1 && h <= 4)
        ? 0.48
        : 1.0;
    return HrUsage(
      h,
      280 * pk + (r.nextDouble() - .5) * 40,
      295 * pk + (r.nextDouble() - .5) * 30,
    );
  });
}

class KpiDef {
  final IconData icon;
  final String label, value, sub;
  final Color color;
  final Color? subColor;
  const KpiDef(
    this.icon,
    this.label,
    this.value,
    this.color,
    this.sub, [
    this.subColor,
  ]);
}

class TabDef {
  final String label;
  final IconData icon;
  const TabDef(this.label, this.icon);
}
