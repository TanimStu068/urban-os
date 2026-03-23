import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/sensor/sensor_state.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  CATEGORY META  (maps SensorType.category → UI identity)
// ─────────────────────────────────────────────────────────────────────────────
typedef T = AppColors;

class CatMeta {
  final String label;
  final Color color;
  final IconData icon;
  const CatMeta(this.label, this.color, this.icon);
}

const categoryMeta = {
  'Traffic': CatMeta('Traffic', T.cyan, Icons.traffic_rounded),
  'Energy': CatMeta('Energy', T.amber, Icons.bolt_rounded),
  'Environment': CatMeta('Environment', T.green, Icons.eco_rounded),
  'Safety': CatMeta('Safety', T.red, Icons.security_rounded),
  'Other': CatMeta('Other', T.violet, Icons.device_hub_rounded),
};

CatMeta catOf(SensorType t) =>
    categoryMeta[t.category] ??
    const CatMeta('Other', T.violet, Icons.device_hub_rounded);

// ─────────────────────────────────────────────────────────────────────────────
//  STATE-COLOR HELPER
// ─────────────────────────────────────────────────────────────────────────────
Color stateColor(SensorState s) {
  switch (s) {
    case SensorState.online:
      return T.green;
    case SensorState.offline:
      return T.red;
    case SensorState.error:
      return T.orange;
    case SensorState.calibrating:
      return T.amber;
    case SensorState.maintenance:
      return T.violet;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SORT OPTIONS
// ─────────────────────────────────────────────────────────────────────────────
enum SortMode { name, category, state, battery, district }

const sortLabels = {
  SortMode.name: 'Name',
  SortMode.category: 'Category',
  SortMode.state: 'Status',
  SortMode.battery: 'Battery',
  SortMode.district: 'District',
};

// ─────────────────────────────────────────────────────────────────────────────
//  VIEW MODE
// ─────────────────────────────────────────────────────────────────────────────
enum ViewMode { list, grid }
