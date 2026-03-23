import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/parking_analytics/prediction.dart';

typedef C = AppColors;
const kAccent = C.cyan;

// ─────────────────────────────────────────
//  MODELS
// ─────────────────────────────────────────
enum ParkingStatus { available, filling, full, reserved, closed }

extension ParkingStatusX on ParkingStatus {
  Color get color {
    switch (this) {
      case ParkingStatus.available:
        return C.green;
      case ParkingStatus.filling:
        return C.amber;
      case ParkingStatus.full:
        return C.red;
      case ParkingStatus.reserved:
        return C.violet;
      case ParkingStatus.closed:
        return C.mutedLt;
    }
  }

  String get label {
    switch (this) {
      case ParkingStatus.available:
        return 'AVAILABLE';
      case ParkingStatus.filling:
        return 'FILLING';
      case ParkingStatus.full:
        return 'FULL';
      case ParkingStatus.reserved:
        return 'RESERVED';
      case ParkingStatus.closed:
        return 'CLOSED';
    }
  }
}

class ParkingLot {
  final String id, name, district, type;
  final int totalSpaces, occupied, reserved, disabled;
  final bool hasEV, hasCCTV, hasBarrier, hasRooftop;
  final double pricePerHour;
  final Color color;
  final List<double> occupancy24h; // hourly occupancy %
  final List<double> revenue7d; // daily revenue
  final List<ParkingFloor> floors;
  final List<ParkingEvent> recentEvents;

  const ParkingLot({
    required this.id,
    required this.name,
    required this.district,
    required this.type,
    required this.totalSpaces,
    required this.occupied,
    required this.reserved,
    required this.disabled,
    required this.hasEV,
    required this.hasCCTV,
    required this.hasBarrier,
    required this.hasRooftop,
    required this.pricePerHour,
    required this.color,
    required this.occupancy24h,
    required this.revenue7d,
    required this.floors,
    required this.recentEvents,
  });

  int get available => totalSpaces - occupied - reserved;
  double get occupancyRate => occupied / totalSpaces;
  ParkingStatus get status {
    if (occupancyRate >= 0.95) return ParkingStatus.full;
    if (occupancyRate >= 0.70) return ParkingStatus.filling;
    return ParkingStatus.available;
  }

  double get totalRevenue => revenue7d.fold(0, (a, b) => a + b);
}

class ParkingFloor {
  final String label;
  final int total, occupied;
  final bool hasEV;
  const ParkingFloor({
    required this.label,
    required this.total,
    required this.occupied,
    required this.hasEV,
  });
  double get rate => occupied / total;
}

class ParkingEvent {
  final String type, plate, time, space;
  final bool isEntry;
  const ParkingEvent({
    required this.type,
    required this.plate,
    required this.time,
    required this.space,
    required this.isEntry,
  });
}

// ─────────────────────────────────────────
//  MOCK DATA
// ─────────────────────────────────────────
const lots = [
  ParkingLot(
    id: 'PK-A',
    name: 'Lot A — Plant Entry',
    district: 'Industrial District',
    type: 'SURFACE',
    totalSpaces: 220,
    occupied: 198,
    reserved: 12,
    disabled: 8,
    hasEV: true,
    hasCCTV: true,
    hasBarrier: true,
    hasRooftop: false,
    pricePerHour: 2.50,
    color: C.red,
    occupancy24h: [
      15,
      12,
      10,
      9,
      12,
      22,
      58,
      82,
      90,
      91,
      90,
      88,
      86,
      88,
      90,
      92,
      91,
      89,
      85,
      78,
      62,
      44,
      28,
      18,
    ],
    revenue7d: [420, 480, 510, 390, 530, 610, 580],
    floors: [
      ParkingFloor(label: 'GROUND', total: 120, occupied: 112, hasEV: true),
      ParkingFloor(label: 'LEVEL 1', total: 100, occupied: 86, hasEV: false),
    ],
    recentEvents: [
      ParkingEvent(
        type: 'ENTRY',
        plate: 'BD-2941',
        time: '10:42',
        space: 'A-112',
        isEntry: true,
      ),
      ParkingEvent(
        type: 'EXIT',
        plate: 'BD-1847',
        time: '10:38',
        space: 'A-088',
        isEntry: false,
      ),
      ParkingEvent(
        type: 'ENTRY',
        plate: 'BD-3302',
        time: '10:35',
        space: 'A-095',
        isEntry: true,
      ),
      ParkingEvent(
        type: 'EXIT',
        plate: 'BD-0571',
        time: '10:31',
        space: 'A-043',
        isEntry: false,
      ),
    ],
  ),
  ParkingLot(
    id: 'PK-B',
    name: 'Lot B — Admin Block',
    district: 'Government Zone',
    type: 'MULTI-STOREY',
    totalSpaces: 150,
    occupied: 87,
    reserved: 18,
    disabled: 6,
    hasEV: true,
    hasCCTV: true,
    hasBarrier: true,
    hasRooftop: true,
    pricePerHour: 1.80,
    color: C.amber,
    occupancy24h: [
      8,
      6,
      5,
      5,
      8,
      16,
      40,
      62,
      68,
      66,
      64,
      60,
      58,
      62,
      66,
      68,
      66,
      63,
      58,
      50,
      38,
      28,
      18,
      10,
    ],
    revenue7d: [210, 240, 260, 180, 270, 310, 295],
    floors: [
      ParkingFloor(label: 'GROUND', total: 40, occupied: 28, hasEV: false),
      ParkingFloor(label: 'LEVEL 1', total: 40, occupied: 26, hasEV: true),
      ParkingFloor(label: 'LEVEL 2', total: 40, occupied: 22, hasEV: false),
      ParkingFloor(label: 'ROOFTOP', total: 30, occupied: 11, hasEV: false),
    ],
    recentEvents: [
      ParkingEvent(
        type: 'ENTRY',
        plate: 'BD-5521',
        time: '10:44',
        space: 'B-214',
        isEntry: true,
      ),
      ParkingEvent(
        type: 'ENTRY',
        plate: 'BD-4419',
        time: '10:40',
        space: 'B-311',
        isEntry: true,
      ),
      ParkingEvent(
        type: 'EXIT',
        plate: 'BD-2278',
        time: '10:33',
        space: 'B-108',
        isEntry: false,
      ),
    ],
  ),
  ParkingLot(
    id: 'PK-C',
    name: 'Lot C — Freight Depot',
    district: 'Industrial District',
    type: 'SURFACE',
    totalSpaces: 80,
    occupied: 42,
    reserved: 8,
    disabled: 4,
    hasEV: false,
    hasCCTV: true,
    hasBarrier: false,
    hasRooftop: false,
    pricePerHour: 3.20,
    color: C.green,
    occupancy24h: [
      18,
      16,
      14,
      14,
      20,
      32,
      48,
      56,
      60,
      58,
      56,
      54,
      52,
      56,
      58,
      60,
      58,
      55,
      50,
      44,
      36,
      28,
      22,
      18,
    ],
    revenue7d: [320, 350, 380, 290, 400, 460, 440],
    floors: [
      ParkingFloor(label: 'GROUND', total: 80, occupied: 42, hasEV: false),
    ],
    recentEvents: [
      ParkingEvent(
        type: 'ENTRY',
        plate: 'BD-7741',
        time: '10:41',
        space: 'C-041',
        isEntry: true,
      ),
      ParkingEvent(
        type: 'EXIT',
        plate: 'BD-6612',
        time: '10:29',
        space: 'C-022',
        isEntry: false,
      ),
    ],
  ),
  ParkingLot(
    id: 'PK-D',
    name: 'Lot D — Visitor Center',
    district: 'Green Zone',
    type: 'SURFACE',
    totalSpaces: 60,
    occupied: 54,
    reserved: 4,
    disabled: 4,
    hasEV: true,
    hasCCTV: false,
    hasBarrier: true,
    hasRooftop: false,
    pricePerHour: 1.50,
    color: C.red,
    occupancy24h: [
      5,
      4,
      3,
      3,
      5,
      10,
      25,
      44,
      52,
      54,
      54,
      52,
      50,
      52,
      54,
      56,
      54,
      52,
      48,
      40,
      30,
      20,
      12,
      7,
    ],
    revenue7d: [90, 110, 120, 80, 130, 145, 138],
    floors: [
      ParkingFloor(label: 'GROUND', total: 60, occupied: 54, hasEV: true),
    ],
    recentEvents: [
      ParkingEvent(
        type: 'ENTRY',
        plate: 'BD-9923',
        time: '10:43',
        space: 'D-055',
        isEntry: true,
      ),
      ParkingEvent(
        type: 'ENTRY',
        plate: 'BD-8814',
        time: '10:39',
        space: 'D-057',
        isEntry: true,
      ),
      ParkingEvent(
        type: 'EXIT',
        plate: 'BD-7712',
        time: '10:35',
        space: 'D-048',
        isEntry: false,
      ),
    ],
  ),
  ParkingLot(
    id: 'PK-E',
    name: 'Lot E — Medical Hub',
    district: 'Medical District',
    type: 'UNDERGROUND',
    totalSpaces: 180,
    occupied: 94,
    reserved: 22,
    disabled: 12,
    hasEV: true,
    hasCCTV: true,
    hasBarrier: true,
    hasRooftop: false,
    pricePerHour: 2.00,
    color: C.violet,
    occupancy24h: [
      20,
      18,
      15,
      14,
      18,
      28,
      50,
      68,
      74,
      72,
      70,
      68,
      66,
      70,
      72,
      74,
      72,
      70,
      66,
      58,
      46,
      36,
      26,
      22,
    ],
    revenue7d: [380, 410, 430, 340, 460, 520, 495],
    floors: [
      ParkingFloor(label: 'LEVEL B1', total: 90, occupied: 50, hasEV: true),
      ParkingFloor(label: 'LEVEL B2', total: 90, occupied: 44, hasEV: false),
    ],
    recentEvents: [
      ParkingEvent(
        type: 'ENTRY',
        plate: 'BD-1134',
        time: '10:45',
        space: 'E-B1-78',
        isEntry: true,
      ),
      ParkingEvent(
        type: 'EXIT',
        plate: 'BD-0992',
        time: '10:40',
        space: 'E-B2-31',
        isEntry: false,
      ),
      ParkingEvent(
        type: 'ENTRY',
        plate: 'BD-2267',
        time: '10:37',
        space: 'E-B1-55',
        isEntry: true,
      ),
    ],
  ),
];

List<Prediction> getPredictions(ParkingLot lot, double rate) {
  final preds = <Prediction>[];
  if (rate > 0.9) {
    preds.add(
      Prediction(
        text:
            'Lot will reach full capacity within ~15 minutes at current arrival rate',
        icon: Icons.warning_amber_rounded,
        color: C.red,
        tag: 'URGENT',
      ),
    );
    preds.add(
      Prediction(
        text:
            'Reroute incoming vehicles to Lot C (52% occupancy) via dynamic signage',
        icon: Icons.alt_route_rounded,
        color: kAccent,
        tag: 'ACTION',
      ),
    );
  } else if (rate > 0.7) {
    preds.add(
      Prediction(
        text:
            'Peak hour load expected 08:00–10:00 — pre-allocate overflow capacity',
        icon: Icons.access_time_rounded,
        color: C.amber,
        tag: 'FORECAST',
      ),
    );
    preds.add(
      Prediction(
        text:
            'Revenue opportunity: increase rate to ৳${(lot.pricePerHour * 1.2).toStringAsFixed(2)}/hr during peak',
        icon: Icons.attach_money_rounded,
        color: C.teal,
        tag: 'INSIGHT',
      ),
    );
  } else {
    preds.add(
      Prediction(
        text: 'Occupancy is within normal parameters — no action required',
        icon: Icons.check_circle_outline_rounded,
        color: C.green,
        tag: 'OK',
      ),
    );
  }
  preds.add(
    Prediction(
      text:
          'Projected 7-day revenue: ৳${(lot.totalRevenue * 1.05).toStringAsFixed(0)} (+5% trend)',
      icon: Icons.trending_up_rounded,
      color: C.teal,
      tag: 'FORECAST',
    ),
  );
  if (lot.hasEV) {
    preds.add(
      Prediction(
        text:
            'EV charging bays showing 80% utilisation — consider adding 4 more units',
        icon: Icons.ev_station_rounded,
        color: kAccent,
        tag: 'INSIGHT',
      ),
    );
  }
  return preds;
}
