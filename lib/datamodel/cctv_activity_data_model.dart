import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

enum CameraStatus { online, offline, inactive, malfunction }

enum RecordingMode { continuous, motion, scheduled, off }

enum ViewMode { grid, list, map }

extension CameraStatusX on CameraStatus {
  String get label {
    switch (this) {
      case CameraStatus.online:
        return 'ONLINE';
      case CameraStatus.offline:
        return 'OFFLINE';
      case CameraStatus.inactive:
        return 'INACTIVE';
      case CameraStatus.malfunction:
        return 'MALFUNCTION';
    }
  }

  Color get color {
    switch (this) {
      case CameraStatus.online:
        return C.green;
      case CameraStatus.offline:
        return C.red;
      case CameraStatus.inactive:
        return C.mutedLt;
      case CameraStatus.malfunction:
        return C.orange;
    }
  }

  IconData get icon {
    switch (this) {
      case CameraStatus.online:
        return Icons.videocam_rounded;
      case CameraStatus.offline:
        return Icons.videocam_off_rounded;
      case CameraStatus.inactive:
        return Icons.pause_circle_outline_rounded;
      case CameraStatus.malfunction:
        return Icons.camera_alt_outlined;
    }
  }
}

extension RecordingModeX on RecordingMode {
  String get label {
    switch (this) {
      case RecordingMode.continuous:
        return 'CONTINUOUS';
      case RecordingMode.motion:
        return 'MOTION';
      case RecordingMode.scheduled:
        return 'SCHEDULED';
      case RecordingMode.off:
        return 'OFF';
    }
  }

  Color get color {
    switch (this) {
      case RecordingMode.continuous:
        return C.red;
      case RecordingMode.motion:
        return C.yellow;
      case RecordingMode.scheduled:
        return C.cyan;
      case RecordingMode.off:
        return C.mutedLt;
    }
  }
}

class CCTVCamera {
  final String id;
  final String name;
  final String location;
  final String zone;
  CameraStatus status;
  RecordingMode recording;
  final double latitude;
  final double longitude;
  final String resolution;
  final int fps;
  final int uptime; // seconds
  int peopleCount;
  int motionEvents;
  bool hasAlert;
  final List<double> activityHistory;

  CCTVCamera({
    required this.id,
    required this.name,
    required this.location,
    required this.zone,
    required this.status,
    required this.recording,
    required this.latitude,
    required this.longitude,
    required this.resolution,
    required this.fps,
    required this.uptime,
    required this.peopleCount,
    required this.motionEvents,
    required this.hasAlert,
    required this.activityHistory,
  });

  double get uptimePercent => (uptime / 86400).clamp(0, 1) * 100;
  String get displayUptime {
    final hours = uptime ~/ 3600;
    final minutes = (uptime % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }
}

class CCTVIncident {
  final String id;
  final String cameraId;
  final String description;
  final String severity;
  final DateTime timestamp;
  final String thumbnailUrl;
  bool acknowledged;

  CCTVIncident({
    required this.id,
    required this.cameraId,
    required this.description,
    required this.severity,
    required this.timestamp,
    required this.thumbnailUrl,
    this.acknowledged = false,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Color get severityColor {
    switch (severity) {
      case 'LOW':
        return C.yellow;
      case 'MEDIUM':
        return C.orange;
      case 'HIGH':
        return C.red;
      default:
        return C.cyan;
    }
  }
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
final rng = Random(456);

List<CCTVCamera> buildCameras() => [
  CCTVCamera(
    id: 'CAM-001',
    name: 'Main Entrance',
    location: 'North Gate',
    zone: 'Residential',
    status: CameraStatus.online,
    recording: RecordingMode.continuous,
    latitude: 40.7128,
    longitude: -74.0060,
    resolution: '4K',
    fps: 30,
    uptime: 82800,
    peopleCount: 12,
    motionEvents: 45,
    hasAlert: false,
    activityHistory: List.generate(24, (_) => rng.nextDouble() * 100),
  ),
  CCTVCamera(
    id: 'CAM-002',
    name: 'Commercial Hub',
    location: 'Market Square',
    zone: 'Commercial',
    status: CameraStatus.online,
    recording: RecordingMode.motion,
    latitude: 40.7150,
    longitude: -74.0080,
    resolution: '4K',
    fps: 30,
    uptime: 86400,
    peopleCount: 48,
    motionEvents: 128,
    hasAlert: true,
    activityHistory: List.generate(24, (_) => rng.nextDouble() * 100),
  ),
  CCTVCamera(
    id: 'CAM-003',
    name: 'Industrial Zone',
    location: 'Factory District',
    zone: 'Industrial',
    status: CameraStatus.online,
    recording: RecordingMode.continuous,
    latitude: 40.7200,
    longitude: -74.0120,
    resolution: '2K',
    fps: 24,
    uptime: 78500,
    peopleCount: 8,
    motionEvents: 23,
    hasAlert: false,
    activityHistory: List.generate(24, (_) => rng.nextDouble() * 100),
  ),
  CCTVCamera(
    id: 'CAM-004',
    name: 'Transport Hub',
    location: 'Central Station',
    zone: 'Transport',
    status: CameraStatus.online,
    recording: RecordingMode.continuous,
    latitude: 40.7180,
    longitude: -74.0090,
    resolution: '4K',
    fps: 30,
    uptime: 84300,
    peopleCount: 156,
    motionEvents: 342,
    hasAlert: true,
    activityHistory: List.generate(24, (_) => rng.nextDouble() * 100),
  ),
  CCTVCamera(
    id: 'CAM-005',
    name: 'Park Entrance',
    location: 'Green Zone',
    zone: 'Park',
    status: CameraStatus.offline,
    recording: RecordingMode.off,
    latitude: 40.7160,
    longitude: -74.0070,
    resolution: '2K',
    fps: 24,
    uptime: 0,
    peopleCount: 0,
    motionEvents: 0,
    hasAlert: true,
    activityHistory: List.generate(24, (_) => 0),
  ),
  CCTVCamera(
    id: 'CAM-006',
    name: 'Medical Campus',
    location: 'Hospital District',
    zone: 'Medical',
    status: CameraStatus.online,
    recording: RecordingMode.scheduled,
    latitude: 40.7140,
    longitude: -74.0100,
    resolution: '4K',
    fps: 30,
    uptime: 81200,
    peopleCount: 34,
    motionEvents: 67,
    hasAlert: false,
    activityHistory: List.generate(24, (_) => rng.nextDouble() * 100),
  ),
];

List<CCTVIncident> buildIncidents() {
  final now = DateTime.now();
  return [
    CCTVIncident(
      id: 'INC-001',
      cameraId: 'CAM-002',
      description: 'Unusual crowd density detected',
      severity: 'MEDIUM',
      timestamp: now.subtract(const Duration(minutes: 15)),
      thumbnailUrl: 'thumb_01',
    ),
    CCTVIncident(
      id: 'INC-002',
      cameraId: 'CAM-004',
      description: 'Person loitering detected near platform',
      severity: 'LOW',
      timestamp: now.subtract(const Duration(minutes: 32)),
      thumbnailUrl: 'thumb_02',
    ),
    CCTVIncident(
      id: 'INC-003',
      cameraId: 'CAM-005',
      description: 'Camera offline - network disconnected',
      severity: 'HIGH',
      timestamp: now.subtract(const Duration(hours: 2)),
      thumbnailUrl: 'thumb_03',
    ),
  ];
}
