import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

enum AccidentSeverity { critical, high, medium, low, cleared }

extension SeverityX on AccidentSeverity {
  Color get color {
    switch (this) {
      case AccidentSeverity.critical:
        return C.red;
      case AccidentSeverity.high:
        return C.orange;
      case AccidentSeverity.medium:
        return C.amber;
      case AccidentSeverity.low:
        return C.teal;
      case AccidentSeverity.cleared:
        return C.green;
    }
  }

  String get label {
    switch (this) {
      case AccidentSeverity.critical:
        return 'CRITICAL';
      case AccidentSeverity.high:
        return 'HIGH';
      case AccidentSeverity.medium:
        return 'MEDIUM';
      case AccidentSeverity.low:
        return 'LOW';
      case AccidentSeverity.cleared:
        return 'CLEARED';
    }
  }

  IconData get icon {
    switch (this) {
      case AccidentSeverity.critical:
        return Icons.emergency_rounded;
      case AccidentSeverity.high:
        return Icons.car_crash_rounded;
      case AccidentSeverity.medium:
        return Icons.warning_amber_rounded;
      case AccidentSeverity.low:
        return Icons.info_outline_rounded;
      case AccidentSeverity.cleared:
        return Icons.check_circle_outline_rounded;
    }
  }
}

enum ResponseStatus { dispatched, onScene, clearing, closed, pending }

extension ResponseStatusX on ResponseStatus {
  Color get color {
    switch (this) {
      case ResponseStatus.dispatched:
        return C.amber;
      case ResponseStatus.onScene:
        return C.orange;
      case ResponseStatus.clearing:
        return C.teal;
      case ResponseStatus.closed:
        return C.green;
      case ResponseStatus.pending:
        return C.red;
    }
  }

  String get label {
    switch (this) {
      case ResponseStatus.dispatched:
        return 'DISPATCHED';
      case ResponseStatus.onScene:
        return 'ON SCENE';
      case ResponseStatus.clearing:
        return 'CLEARING';
      case ResponseStatus.closed:
        return 'CLOSED';
      case ResponseStatus.pending:
        return 'PENDING';
    }
  }
}

class AccidentEvent {
  final String id;
  final String road;
  final String location;
  final String district;
  final String description;
  final String time;
  final String reportedBy; // SENSOR | CAMERA | OPERATOR | PUBLIC
  AccidentSeverity severity;
  ResponseStatus responseStatus;
  final int vehiclesInvolved;
  final int injuriesReported;
  final int lanesBlocked;
  final int totalLanes;
  final double roadPosition; // 0-1 along map
  final double mapX, mapY; // normalised position on city map painter
  final List<String> dispatchedUnits; // e.g. ['AMB-04', 'POL-12', 'TOW-07']
  final List<TimelineEntry> timeline;
  final List<double> impactRadarValues; // 6 axes 0-1
  bool isSelected;

  AccidentEvent({
    required this.id,
    required this.road,
    required this.location,
    required this.district,
    required this.description,
    required this.time,
    required this.reportedBy,
    required this.severity,
    required this.responseStatus,
    required this.vehiclesInvolved,
    required this.injuriesReported,
    required this.lanesBlocked,
    required this.totalLanes,
    required this.roadPosition,
    required this.mapX,
    required this.mapY,
    required this.dispatchedUnits,
    required this.timeline,
    required this.impactRadarValues,
    this.isSelected = false,
  });
}

class TimelineEntry {
  final String time, event, actor;
  final Color color;
  const TimelineEntry({
    required this.time,
    required this.event,
    required this.actor,
    required this.color,
  });
}

// ─────────────────────────────────────────
//  MOCK DATA
// ─────────────────────────────────────────
List<AccidentEvent> buildAccidents() => [
  AccidentEvent(
    id: 'ACC-2041',
    road: 'Ring Road 4',
    location: 'KM 2.9 — Near Industrial Gate',
    district: 'Industrial District',
    description:
        'Multi-vehicle collision — 3 vehicles involved. '
        'Lane 1 & 2 completely blocked. Debris on carriageway. '
        'Two persons reported injured. Emergency services en route.',
    time: '09:14',
    reportedBy: 'CAMERA',
    severity: AccidentSeverity.critical,
    responseStatus: ResponseStatus.onScene,
    vehiclesInvolved: 3,
    injuriesReported: 2,
    lanesBlocked: 2,
    totalLanes: 4,
    roadPosition: 0.38,
    mapX: 0.42,
    mapY: 0.30,
    dispatchedUnits: [
      'AMB-04',
      'AMB-07',
      'POL-12',
      'POL-15',
      'TOW-03',
      'TOW-09',
    ],
    impactRadarValues: [0.95, 0.80, 0.90, 0.70, 0.85, 0.60],
    timeline: [
      TimelineEntry(
        time: '09:14',
        event: 'Collision detected by traffic camera TK-04',
        actor: 'AUTO',
        color: C.red,
      ),
      TimelineEntry(
        time: '09:15',
        event: 'Alert escalated to CRITICAL — 3 vehicles',
        actor: 'SYSTEM',
        color: C.orange,
      ),
      TimelineEntry(
        time: '09:16',
        event: 'AMB-04 & AMB-07 dispatched',
        actor: 'DISPATCH',
        color: C.amber,
      ),
      TimelineEntry(
        time: '09:17',
        event: 'POL-12 & POL-15 dispatched',
        actor: 'DISPATCH',
        color: C.amber,
      ),
      TimelineEntry(
        time: '09:22',
        event: 'Ring Rd signal TL-01 switched to emergency mode',
        actor: 'SYSTEM',
        color: C.cyan,
      ),
      TimelineEntry(
        time: '09:28',
        event: 'AMB-04 on scene — 2 casualties confirmed',
        actor: 'FIELD',
        color: C.red,
      ),
      TimelineEntry(
        time: '09:31',
        event: 'POL-12 on scene — lane control established',
        actor: 'FIELD',
        color: C.teal,
      ),
      TimelineEntry(
        time: '09:35',
        event: 'TOW-03 & TOW-09 dispatched',
        actor: 'DISPATCH',
        color: C.mutedLt,
      ),
    ],
    isSelected: true,
  ),
  AccidentEvent(
    id: 'ACC-2040',
    road: 'North Access',
    location: 'KM 1.2 — Junction N-Gate',
    district: 'Transport Hub',
    description:
        'Heavy vehicle rear-end collision. '
        'Freight truck struck stationary vehicle. Lane 3 blocked. '
        'Minor injuries reported. Police on scene.',
    time: '08:52',
    reportedBy: 'SENSOR',
    severity: AccidentSeverity.high,
    responseStatus: ResponseStatus.clearing,
    vehiclesInvolved: 2,
    injuriesReported: 1,
    lanesBlocked: 1,
    totalLanes: 4,
    roadPosition: 0.25,
    mapX: 0.62,
    mapY: 0.20,
    dispatchedUnits: ['AMB-02', 'POL-08', 'TOW-05'],
    impactRadarValues: [0.70, 0.55, 0.65, 0.40, 0.60, 0.45],
    timeline: [
      TimelineEntry(
        time: '08:52',
        event: 'Impact detected by road sensor SEN-27',
        actor: 'AUTO',
        color: C.orange,
      ),
      TimelineEntry(
        time: '08:53',
        event: 'Alert classified as HIGH severity',
        actor: 'SYSTEM',
        color: C.orange,
      ),
      TimelineEntry(
        time: '08:55',
        event: 'AMB-02 & POL-08 dispatched',
        actor: 'DISPATCH',
        color: C.amber,
      ),
      TimelineEntry(
        time: '09:04',
        event: 'POL-08 on scene — lane blockage confirmed',
        actor: 'FIELD',
        color: C.teal,
      ),
      TimelineEntry(
        time: '09:12',
        event: 'TOW-05 dispatched for freight truck',
        actor: 'DISPATCH',
        color: C.mutedLt,
      ),
      TimelineEntry(
        time: '09:28',
        event: 'Road partially reopened — Lane 3 still blocked',
        actor: 'FIELD',
        color: C.amber,
      ),
    ],
  ),
  AccidentEvent(
    id: 'ACC-2039',
    road: 'Industrial Blvd',
    location: 'KM 3.5 — Shoulder Lane',
    district: 'Industrial District',
    description:
        'Single vehicle breakdown escalated to minor collision. '
        'Vehicle struck guide rail. Shoulder lane only affected. '
        'Driver uninjured. Tow truck requested.',
    time: '10:03',
    reportedBy: 'OPERATOR',
    severity: AccidentSeverity.medium,
    responseStatus: ResponseStatus.dispatched,
    vehiclesInvolved: 1,
    injuriesReported: 0,
    lanesBlocked: 1,
    totalLanes: 4,
    roadPosition: 0.58,
    mapX: 0.35,
    mapY: 0.52,
    dispatchedUnits: ['POL-19', 'TOW-11'],
    impactRadarValues: [0.35, 0.20, 0.40, 0.15, 0.30, 0.25],
    timeline: [
      TimelineEntry(
        time: '10:03',
        event: 'Incident reported by control operator',
        actor: 'OPERATOR',
        color: C.amber,
      ),
      TimelineEntry(
        time: '10:05',
        event: 'Classified MEDIUM — shoulder lane only',
        actor: 'SYSTEM',
        color: C.amber,
      ),
      TimelineEntry(
        time: '10:06',
        event: 'POL-19 & TOW-11 dispatched',
        actor: 'DISPATCH',
        color: C.amber,
      ),
    ],
  ),
  AccidentEvent(
    id: 'ACC-2038',
    road: 'Freight Route F1',
    location: 'KM 5.1 — Intersection F1×Gate',
    district: 'Industrial District',
    description:
        'Minor sideswipe incident at intersection. '
        'Two light vehicles involved. No injuries. '
        'Both vehicles driveable — exchanging details.',
    time: '07:41',
    reportedBy: 'PUBLIC',
    severity: AccidentSeverity.low,
    responseStatus: ResponseStatus.closed,
    vehiclesInvolved: 2,
    injuriesReported: 0,
    lanesBlocked: 0,
    totalLanes: 2,
    roadPosition: 0.72,
    mapX: 0.55,
    mapY: 0.62,
    dispatchedUnits: ['POL-06'],
    impactRadarValues: [0.15, 0.10, 0.20, 0.05, 0.12, 0.08],
    timeline: [
      TimelineEntry(
        time: '07:41',
        event: 'Incident reported by public via app',
        actor: 'PUBLIC',
        color: C.teal,
      ),
      TimelineEntry(
        time: '07:43',
        event: 'Classified LOW severity',
        actor: 'SYSTEM',
        color: C.teal,
      ),
      TimelineEntry(
        time: '07:45',
        event: 'POL-06 dispatched',
        actor: 'DISPATCH',
        color: C.amber,
      ),
      TimelineEntry(
        time: '08:10',
        event: 'POL-06 on scene — report filed',
        actor: 'FIELD',
        color: C.teal,
      ),
      TimelineEntry(
        time: '08:22',
        event: 'Incident closed — no road impact',
        actor: 'SYSTEM',
        color: C.green,
      ),
    ],
  ),
  AccidentEvent(
    id: 'ACC-2037',
    road: 'South Bypass',
    location: 'KM 4.8 — Bypass Merge',
    district: 'Commercial District',
    description:
        'Earlier rear-end collision fully cleared. '
        'All lanes reopened. Traffic normalising. No further action.',
    time: '06:30',
    reportedBy: 'CAMERA',
    severity: AccidentSeverity.cleared,
    responseStatus: ResponseStatus.closed,
    vehiclesInvolved: 2,
    injuriesReported: 0,
    lanesBlocked: 0,
    totalLanes: 2,
    roadPosition: 0.85,
    mapX: 0.78,
    mapY: 0.72,
    dispatchedUnits: ['POL-03', 'TOW-02'],
    impactRadarValues: [0.05, 0.05, 0.08, 0.03, 0.05, 0.04],
    timeline: [
      TimelineEntry(
        time: '06:30',
        event: 'Collision detected by camera TK-09',
        actor: 'AUTO',
        color: C.amber,
      ),
      TimelineEntry(
        time: '06:32',
        event: 'Units dispatched',
        actor: 'DISPATCH',
        color: C.amber,
      ),
      TimelineEntry(
        time: '06:48',
        event: 'Scene cleared — traffic resumed',
        actor: 'FIELD',
        color: C.green,
      ),
      TimelineEntry(
        time: '07:05',
        event: 'Incident closed',
        actor: 'SYSTEM',
        color: C.green,
      ),
    ],
  ),
];
