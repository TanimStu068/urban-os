// ─────────────────────────────────────────
//  COLOR PALETTE (UrbanOS — Profile)
// ─────────────────────────────────────────
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'dart:math';

typedef C = AppColors;

const kAccent = C.teal;

//  ENUMS & DATA MODELS
enum UserRole { admin, operator, viewer, guest }

enum DeviceType { mobile, tablet, desktop, watch }

enum SecurityLevel { low, medium, high, critical }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'ADMIN';
      case UserRole.operator:
        return 'OPERATOR';
      case UserRole.viewer:
        return 'VIEWER';
      case UserRole.guest:
        return 'GUEST';
    }
  }

  Color get color {
    switch (this) {
      case UserRole.admin:
        return C.red;
      case UserRole.operator:
        return C.cyan;
      case UserRole.viewer:
        return C.teal;
      case UserRole.guest:
        return C.orange;
    }
  }
}

extension DeviceTypeX on DeviceType {
  String get label {
    switch (this) {
      case DeviceType.mobile:
        return 'MOBILE';
      case DeviceType.tablet:
        return 'TABLET';
      case DeviceType.desktop:
        return 'DESKTOP';
      case DeviceType.watch:
        return 'WATCH';
    }
  }

  IconData get icon {
    switch (this) {
      case DeviceType.mobile:
        return Icons.smartphone_rounded;
      case DeviceType.tablet:
        return Icons.tablet_rounded;
      case DeviceType.desktop:
        return Icons.desktop_mac_rounded;
      case DeviceType.watch:
        return Icons.watch_rounded;
    }
  }

  Color get color {
    switch (this) {
      case DeviceType.mobile:
        return C.teal;
      case DeviceType.tablet:
        return C.cyan;
      case DeviceType.desktop:
        return C.green;
      case DeviceType.watch:
        return C.mint;
    }
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String bio;
  final String contactPhone;
  final UserRole role;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool twoFactorEnabled;
  final int loginStreak;
  final int totalLogins;
  bool notificationsEnabled;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.contactPhone,
    required this.role,
    required this.createdAt,
    required this.lastLoginAt,
    required this.twoFactorEnabled,
    required this.loginStreak,
    required this.totalLogins,
    this.notificationsEnabled = true,
  });

  String get daysActive =>
      DateTime.now().difference(createdAt).inDays.toString();
  String get hoursSinceLogin =>
      DateTime.now().difference(lastLoginAt).inHours.toString();
}

class ConnectedDevice {
  final String id;
  final String name;
  final DeviceType type;
  final String ipAddress;
  final DateTime lastActive;
  final bool isActive;

  ConnectedDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.ipAddress,
    required this.lastActive,
    required this.isActive,
  });

  String get lastActiveLabel {
    final diff = DateTime.now().difference(lastActive);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class LoginHistory {
  final String id;
  final DateTime timestamp;
  final String deviceName;
  final String ipAddress;
  final String location;
  final bool success;
  final String? failureReason;

  LoginHistory({
    required this.id,
    required this.timestamp,
    required this.deviceName,
    required this.ipAddress,
    required this.location,
    required this.success,
    this.failureReason,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

//  MOCK DATA FACTORY
// ─────────────────────────────────────────
final _rng = Random(654);
final _now = DateTime.now();

UserProfile buildUserProfile() => UserProfile(
  id: 'USR-001',
  name: 'Dr. Alexis Chen',
  email: 'alexis.chen@urbanos.io',
  bio: 'Urban Systems Architect | Smart City Innovation',
  contactPhone: '+1-555-0147',
  role: UserRole.admin,
  createdAt: _now.subtract(const Duration(days: 487)),
  lastLoginAt: _now.subtract(const Duration(hours: 2)),
  twoFactorEnabled: true,
  loginStreak: 47,
  totalLogins: 312,
);

List<ConnectedDevice> buildDevices() => [
  ConnectedDevice(
    id: 'DEV-001',
    name: 'iPhone 15 Pro',
    type: DeviceType.mobile,
    ipAddress: '192.168.1.45',
    lastActive: _now.subtract(const Duration(minutes: 12)),
    isActive: true,
  ),
  ConnectedDevice(
    id: 'DEV-002',
    name: 'MacBook Pro M3',
    type: DeviceType.desktop,
    ipAddress: '192.168.1.88',
    lastActive: _now.subtract(const Duration(hours: 3)),
    isActive: false,
  ),
  ConnectedDevice(
    id: 'DEV-003',
    name: 'iPad Air',
    type: DeviceType.tablet,
    ipAddress: '192.168.1.92',
    lastActive: _now.subtract(const Duration(hours: 18)),
    isActive: false,
  ),
];

List<LoginHistory> buildLoginHistory() {
  final locations = [
    'New York, USA',
    'San Francisco, USA',
    'London, UK',
    'Tokyo, Japan',
    'Singapore',
  ];
  final devices = ['Chrome', 'Safari', 'Mobile', 'Firefox'];

  return List.generate(8, (i) {
    final success = _rng.nextBool();
    return LoginHistory(
      id: 'LOGIN-${String.fromCharCode(65 + i)}${_rng.nextInt(100)}',
      timestamp: _now.subtract(Duration(hours: _rng.nextInt(72))),
      deviceName: devices[_rng.nextInt(devices.length)],
      ipAddress: '192.168.${_rng.nextInt(255)}.${_rng.nextInt(255)}',
      location: locations[_rng.nextInt(locations.length)],
      success: success,
      failureReason: success ? null : 'Invalid password',
    );
  });
}
