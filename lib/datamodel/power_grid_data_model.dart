import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

enum NodeType { substation, transformer, distribution, zone, source }

enum LineStatus { live, overloaded, fault, offline, maintenance }

enum ZoneStatus { normal, warning, critical, offline, saving }

extension ZoneStatusX on ZoneStatus {
  Color get color {
    switch (this) {
      case ZoneStatus.normal:
        return C.green;
      case ZoneStatus.warning:
        return C.amber;
      case ZoneStatus.critical:
        return C.red;
      case ZoneStatus.offline:
        return C.mutedLt;
      case ZoneStatus.saving:
        return C.cyan;
    }
  }

  String get label {
    switch (this) {
      case ZoneStatus.normal:
        return 'NORMAL';
      case ZoneStatus.warning:
        return 'WARNING';
      case ZoneStatus.critical:
        return 'CRITICAL';
      case ZoneStatus.offline:
        return 'OFFLINE';
      case ZoneStatus.saving:
        return 'ECO MODE';
    }
  }
}

extension LineStatusX on LineStatus {
  Color get color {
    switch (this) {
      case LineStatus.live:
        return C.green;
      case LineStatus.overloaded:
        return C.red;
      case LineStatus.fault:
        return C.orange;
      case LineStatus.offline:
        return C.mutedLt;
      case LineStatus.maintenance:
        return C.amber;
    }
  }
}

extension NodeTypeX on NodeType {
  Color get color {
    switch (this) {
      case NodeType.substation:
        return C.amber;
      case NodeType.transformer:
        return C.cyan;
      case NodeType.distribution:
        return C.violet;
      case NodeType.zone:
        return C.green;
      case NodeType.source:
        return C.teal;
    }
  }

  IconData get icon {
    switch (this) {
      case NodeType.substation:
        return Icons.electric_bolt_rounded;
      case NodeType.transformer:
        return Icons.swap_vert_rounded;
      case NodeType.distribution:
        return Icons.account_tree_rounded;
      case NodeType.zone:
        return Icons.location_city_rounded;
      case NodeType.source:
        return Icons.power_rounded;
    }
  }

  String get label {
    switch (this) {
      case NodeType.substation:
        return 'SUBSTATION';
      case NodeType.transformer:
        return 'TRANSFORMER';
      case NodeType.distribution:
        return 'DISTRIBUTION';
      case NodeType.zone:
        return 'ZONE';
      case NodeType.source:
        return 'SOURCE';
    }
  }

  double get radius {
    switch (this) {
      case NodeType.substation:
        return 28;
      case NodeType.transformer:
        return 20;
      case NodeType.distribution:
        return 18;
      case NodeType.zone:
        return 16;
      case NodeType.source:
        return 22;
    }
  }
}

// ─────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────
class GridNode {
  final String id;
  final String name;
  final NodeType type;
  Offset position; // 0..1 normalized
  double loadPct;
  double voltage; // kV
  double current; // A
  double power; // kW
  ZoneStatus status;
  bool isSelected;
  final List<double> loadHistory; // 24-point

  GridNode({
    required this.id,
    required this.name,
    required this.type,
    required this.position,
    required this.loadPct,
    required this.voltage,
    required this.current,
    required this.power,
    required this.status,
    this.isSelected = false,
    required this.loadHistory,
  });
}

class GridLine {
  final String id;
  final String fromId;
  final String toId;
  LineStatus status;
  double loadPct;
  double capacityKW;
  double currentKW;
  double lengthKm;
  double lossKW;

  GridLine({
    required this.id,
    required this.fromId,
    required this.toId,
    required this.status,
    required this.loadPct,
    required this.capacityKW,
    required this.currentKW,
    required this.lengthKm,
    required this.lossKW,
  });
}

class GridAlert {
  final String id;
  final String message;
  final String nodeId;
  final Color color;
  final String time;
  bool acked;
  GridAlert({
    required this.id,
    required this.message,
    required this.nodeId,
    required this.color,
    required this.time,
    this.acked = false,
  });
}

// ─────────────────────────────────────────
//  MOCK DATA
// ─────────────────────────────────────────
final _rnd = Random(42);
List<double> _hist(double lo, double hi) =>
    List.generate(24, (_) => lo + _rnd.nextDouble() * (hi - lo));

List<GridNode> buildNodes() => [
  // ── Main Substation (centre-ish)
  GridNode(
    id: 'SS-MAIN',
    name: 'CENTRAL\nSUBSTATION',
    type: NodeType.substation,
    position: const Offset(0.50, 0.42),
    loadPct: 78,
    voltage: 220,
    current: 1840,
    power: 28400,
    status: ZoneStatus.normal,
    loadHistory: _hist(60, 85),
  ),

  // ── Sources
  GridNode(
    id: 'SRC-SOLAR',
    name: 'SOLAR\nFARM',
    type: NodeType.source,
    position: const Offset(0.14, 0.15),
    loadPct: 52,
    voltage: 33,
    current: 188,
    power: 6200,
    status: ZoneStatus.normal,
    loadHistory: _hist(0, 80),
  ),
  GridNode(
    id: 'SRC-WIND',
    name: 'WIND\nPARK',
    type: NodeType.source,
    position: const Offset(0.88, 0.12),
    loadPct: 36,
    voltage: 33,
    current: 55,
    power: 1800,
    status: ZoneStatus.saving,
    loadHistory: _hist(10, 60),
  ),
  GridNode(
    id: 'SRC-GRID',
    name: 'NATIONAL\nGRID',
    type: NodeType.source,
    position: const Offset(0.50, 0.08),
    loadPct: 71,
    voltage: 400,
    current: 710,
    power: 28400,
    status: ZoneStatus.normal,
    loadHistory: _hist(50, 90),
  ),

  // ── Transformers
  GridNode(
    id: 'TX-NORTH',
    name: 'TX NORTH',
    type: NodeType.transformer,
    position: const Offset(0.30, 0.28),
    loadPct: 64,
    voltage: 33,
    current: 420,
    power: 4800,
    status: ZoneStatus.normal,
    loadHistory: _hist(40, 75),
  ),
  GridNode(
    id: 'TX-EAST',
    name: 'TX EAST',
    type: NodeType.transformer,
    position: const Offset(0.72, 0.28),
    loadPct: 88,
    voltage: 33,
    current: 620,
    power: 8100,
    status: ZoneStatus.warning,
    loadHistory: _hist(60, 95),
  ),
  GridNode(
    id: 'TX-SOUTH',
    name: 'TX SOUTH',
    type: NodeType.transformer,
    position: const Offset(0.50, 0.68),
    loadPct: 55,
    voltage: 33,
    current: 380,
    power: 4200,
    status: ZoneStatus.normal,
    loadHistory: _hist(35, 65),
  ),
  GridNode(
    id: 'TX-WEST',
    name: 'TX WEST',
    type: NodeType.transformer,
    position: const Offset(0.18, 0.55),
    loadPct: 42,
    voltage: 33,
    current: 290,
    power: 3100,
    status: ZoneStatus.saving,
    loadHistory: _hist(30, 55),
  ),

  // ── Distribution nodes
  GridNode(
    id: 'DX-01',
    name: 'DX-01',
    type: NodeType.distribution,
    position: const Offset(0.22, 0.38),
    loadPct: 71,
    voltage: 11,
    current: 198,
    power: 2100,
    status: ZoneStatus.normal,
    loadHistory: _hist(50, 80),
  ),
  GridNode(
    id: 'DX-02',
    name: 'DX-02',
    type: NodeType.distribution,
    position: const Offset(0.62, 0.35),
    loadPct: 93,
    voltage: 11,
    current: 288,
    power: 3200,
    status: ZoneStatus.critical,
    loadHistory: _hist(75, 100),
  ),
  GridNode(
    id: 'DX-03',
    name: 'DX-03',
    type: NodeType.distribution,
    position: const Offset(0.38, 0.60),
    loadPct: 48,
    voltage: 11,
    current: 145,
    power: 1600,
    status: ZoneStatus.normal,
    loadHistory: _hist(30, 60),
  ),
  GridNode(
    id: 'DX-04',
    name: 'DX-04',
    type: NodeType.distribution,
    position: const Offset(0.76, 0.55),
    loadPct: 0,
    voltage: 0,
    current: 0,
    power: 0,
    status: ZoneStatus.offline,
    loadHistory: _hist(0, 0),
  ),

  // ── Zone endpoints
  GridNode(
    id: 'Z-RES',
    name: 'RESIDENTIAL',
    type: NodeType.zone,
    position: const Offset(0.12, 0.72),
    loadPct: 70,
    voltage: 0.4,
    current: 105,
    power: 4200,
    status: ZoneStatus.normal,
    loadHistory: _hist(50, 80),
  ),
  GridNode(
    id: 'Z-IND',
    name: 'INDUSTRIAL',
    type: NodeType.zone,
    position: const Offset(0.85, 0.70),
    loadPct: 97,
    voltage: 0.4,
    current: 243,
    power: 9700,
    status: ZoneStatus.critical,
    loadHistory: _hist(80, 100),
  ),
  GridNode(
    id: 'Z-COM',
    name: 'COMMERCIAL',
    type: NodeType.zone,
    position: const Offset(0.50, 0.85),
    loadPct: 80,
    voltage: 0.4,
    current: 140,
    power: 5600,
    status: ZoneStatus.normal,
    loadHistory: _hist(55, 85),
  ),
  GridNode(
    id: 'Z-MED',
    name: 'MEDICAL',
    type: NodeType.zone,
    position: const Offset(0.32, 0.82),
    loadPct: 77,
    voltage: 0.4,
    current: 97,
    power: 3100,
    status: ZoneStatus.saving,
    loadHistory: _hist(55, 80),
  ),
  GridNode(
    id: 'Z-EDU',
    name: 'EDUCATION',
    type: NodeType.zone,
    position: const Offset(0.68, 0.82),
    loadPct: 70,
    voltage: 0.4,
    current: 88,
    power: 1400,
    status: ZoneStatus.normal,
    loadHistory: _hist(40, 75),
  ),
];

List<GridLine> buildLines() => [
  // Grid → Main Sub
  GridLine(
    id: 'L-001',
    fromId: 'SRC-GRID',
    toId: 'SS-MAIN',
    status: LineStatus.live,
    loadPct: 71,
    capacityKW: 40000,
    currentKW: 28400,
    lengthKm: 12.4,
    lossKW: 284,
  ),
  // Solar → TX-NORTH
  GridLine(
    id: 'L-002',
    fromId: 'SRC-SOLAR',
    toId: 'TX-NORTH',
    status: LineStatus.live,
    loadPct: 52,
    capacityKW: 12000,
    currentKW: 6200,
    lengthKm: 8.1,
    lossKW: 62,
  ),
  // Wind → TX-EAST
  GridLine(
    id: 'L-003',
    fromId: 'SRC-WIND',
    toId: 'TX-EAST',
    status: LineStatus.live,
    loadPct: 36,
    capacityKW: 5000,
    currentKW: 1800,
    lengthKm: 9.7,
    lossKW: 18,
  ),
  // Main Sub → TX-NORTH
  GridLine(
    id: 'L-004',
    fromId: 'SS-MAIN',
    toId: 'TX-NORTH',
    status: LineStatus.live,
    loadPct: 64,
    capacityKW: 8000,
    currentKW: 5120,
    lengthKm: 3.2,
    lossKW: 51,
  ),
  // Main Sub → TX-EAST
  GridLine(
    id: 'L-005',
    fromId: 'SS-MAIN',
    toId: 'TX-EAST',
    status: LineStatus.overloaded,
    loadPct: 88,
    capacityKW: 10000,
    currentKW: 8800,
    lengthKm: 2.9,
    lossKW: 176,
  ),
  // Main Sub → TX-SOUTH
  GridLine(
    id: 'L-006',
    fromId: 'SS-MAIN',
    toId: 'TX-SOUTH',
    status: LineStatus.live,
    loadPct: 55,
    capacityKW: 8000,
    currentKW: 4400,
    lengthKm: 3.8,
    lossKW: 44,
  ),
  // Main Sub → TX-WEST
  GridLine(
    id: 'L-007',
    fromId: 'SS-MAIN',
    toId: 'TX-WEST',
    status: LineStatus.live,
    loadPct: 42,
    capacityKW: 6000,
    currentKW: 2520,
    lengthKm: 4.1,
    lossKW: 25,
  ),
  // TX-NORTH → DX-01
  GridLine(
    id: 'L-008',
    fromId: 'TX-NORTH',
    toId: 'DX-01',
    status: LineStatus.live,
    loadPct: 71,
    capacityKW: 3000,
    currentKW: 2130,
    lengthKm: 1.4,
    lossKW: 21,
  ),
  // TX-EAST → DX-02
  GridLine(
    id: 'L-009',
    fromId: 'TX-EAST',
    toId: 'DX-02',
    status: LineStatus.overloaded,
    loadPct: 93,
    capacityKW: 4000,
    currentKW: 3720,
    lengthKm: 1.8,
    lossKW: 112,
  ),
  // TX-SOUTH → DX-03
  GridLine(
    id: 'L-010',
    fromId: 'TX-SOUTH',
    toId: 'DX-03',
    status: LineStatus.live,
    loadPct: 48,
    capacityKW: 3500,
    currentKW: 1680,
    lengthKm: 1.2,
    lossKW: 17,
  ),
  // TX-EAST → DX-04 (offline)
  GridLine(
    id: 'L-011',
    fromId: 'TX-EAST',
    toId: 'DX-04',
    status: LineStatus.fault,
    loadPct: 0,
    capacityKW: 3000,
    currentKW: 0,
    lengthKm: 2.1,
    lossKW: 0,
  ),
  // DX-01 → Z-RES
  GridLine(
    id: 'L-012',
    fromId: 'DX-01',
    toId: 'Z-RES',
    status: LineStatus.live,
    loadPct: 70,
    capacityKW: 6000,
    currentKW: 4200,
    lengthKm: 2.3,
    lossKW: 42,
  ),
  // DX-02 → Z-IND
  GridLine(
    id: 'L-013',
    fromId: 'DX-02',
    toId: 'Z-IND',
    status: LineStatus.overloaded,
    loadPct: 97,
    capacityKW: 10000,
    currentKW: 9700,
    lengthKm: 1.5,
    lossKW: 291,
  ),
  // DX-03 → Z-COM
  GridLine(
    id: 'L-014',
    fromId: 'DX-03',
    toId: 'Z-COM',
    status: LineStatus.live,
    loadPct: 80,
    capacityKW: 7000,
    currentKW: 5600,
    lengthKm: 2.8,
    lossKW: 56,
  ),
  // TX-WEST → Z-MED
  GridLine(
    id: 'L-015',
    fromId: 'TX-WEST',
    toId: 'Z-MED',
    status: LineStatus.live,
    loadPct: 77,
    capacityKW: 4000,
    currentKW: 3080,
    lengthKm: 3.1,
    lossKW: 31,
  ),
  // TX-SOUTH → Z-EDU
  GridLine(
    id: 'L-016',
    fromId: 'TX-SOUTH',
    toId: 'Z-EDU',
    status: LineStatus.live,
    loadPct: 70,
    capacityKW: 2000,
    currentKW: 1400,
    lengthKm: 2.2,
    lossKW: 14,
  ),
  // TX-NORTH ↔ TX-EAST (tie line)
  GridLine(
    id: 'L-017',
    fromId: 'TX-NORTH',
    toId: 'TX-EAST',
    status: LineStatus.maintenance,
    loadPct: 0,
    capacityKW: 5000,
    currentKW: 0,
    lengthKm: 5.6,
    lossKW: 0,
  ),
];

List<GridAlert> buildGridAlerts() => [
  GridAlert(
    id: 'GA-01',
    message: 'DX-02 overloaded — 93% capacity',
    nodeId: 'DX-02',
    color: C.red,
    time: '10:42',
    acked: false,
  ),
  GridAlert(
    id: 'GA-02',
    message: 'Line L-011 fault — TX-EAST→DX-04',
    nodeId: 'DX-04',
    color: C.orange,
    time: '10:38',
    acked: false,
  ),
  GridAlert(
    id: 'GA-03',
    message: 'Industrial zone 97% — shedding risk',
    nodeId: 'Z-IND',
    color: C.red,
    time: '10:30',
    acked: false,
  ),
  GridAlert(
    id: 'GA-04',
    message: 'TX-EAST load > 88% — monitor',
    nodeId: 'TX-EAST',
    color: C.amber,
    time: '09:55',
    acked: true,
  ),
  GridAlert(
    id: 'GA-05',
    message: 'Tie line L-017 under maintenance',
    nodeId: 'TX-NORTH',
    color: C.amber,
    time: '08:00',
    acked: true,
  ),
];
