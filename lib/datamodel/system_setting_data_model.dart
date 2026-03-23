//  ENUMS & DATA MODELS

import 'package:flutter/material.dart';

enum ThemeMode { dark, light, auto }

enum DataUpdateFrequency { realtime, highFreq, normal, lowFreq }

extension ThemeModeX on ThemeMode {
  String get label {
    switch (this) {
      case ThemeMode.dark:
        return 'DARK';
      case ThemeMode.light:
        return 'LIGHT';
      case ThemeMode.auto:
        return 'AUTO';
    }
  }

  IconData get icon {
    switch (this) {
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.auto:
        return Icons.brightness_auto_rounded;
    }
  }
}

extension DataUpdateFrequencyX on DataUpdateFrequency {
  String get label {
    switch (this) {
      case DataUpdateFrequency.realtime:
        return 'REAL-TIME';
      case DataUpdateFrequency.highFreq:
        return 'HIGH FREQ';
      case DataUpdateFrequency.normal:
        return 'NORMAL';
      case DataUpdateFrequency.lowFreq:
        return 'LOW FREQ';
    }
  }

  int get intervalMs {
    switch (this) {
      case DataUpdateFrequency.realtime:
        return 100;
      case DataUpdateFrequency.highFreq:
        return 500;
      case DataUpdateFrequency.normal:
        return 1000;
      case DataUpdateFrequency.lowFreq:
        return 5000;
    }
  }
}

class SystemSettings {
  bool darkMode;
  bool animationsEnabled;
  bool soundsEnabled;
  bool hapticFeedbackEnabled;
  double brightnessLevel;
  double volumeLevel;
  bool locationServicesEnabled;
  bool dataCollectionEnabled;
  bool automaticUpdatesEnabled;
  DataUpdateFrequency updateFrequency;
  bool lowPowerMode;

  SystemSettings({
    this.darkMode = true,
    this.animationsEnabled = true,
    this.soundsEnabled = true,
    this.hapticFeedbackEnabled = true,
    this.brightnessLevel = 0.85,
    this.volumeLevel = 0.75,
    this.locationServicesEnabled = true,
    this.dataCollectionEnabled = false,
    this.automaticUpdatesEnabled = true,
    this.updateFrequency = DataUpdateFrequency.normal,
    this.lowPowerMode = false,
  });
}

class StorageInfo {
  final String total;
  final String used;
  final String available;
  final double usagePercent;

  StorageInfo({
    required this.total,
    required this.used,
    required this.available,
    required this.usagePercent,
  });
}

class CacheInfo {
  final String size;
  final int itemCount;
  final DateTime lastCleaned;

  CacheInfo({
    required this.size,
    required this.itemCount,
    required this.lastCleaned,
  });
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
StorageInfo buildStorageInfo() => StorageInfo(
  total: '128 GB',
  used: '89.3 GB',
  available: '38.7 GB',
  usagePercent: 0.697,
);

CacheInfo buildCacheInfo() => CacheInfo(
  size: '4.2 GB',
  itemCount: 12847,
  lastCleaned: DateTime.now().subtract(const Duration(days: 3)),
);
