import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/district/district_type.dart';

typedef C = AppColors;

class MapTile {
  final DistrictModel district;
  final Rect rect;
  MapTile(this.district, this.rect);
}

enum MapMode { health, type, traffic, safety }

extension MapModeX on MapMode {
  String get label => const ['HEALTH', 'TYPE', 'TRAFFIC', 'SAFETY'][index];
  IconData get icon => [
    Icons.health_and_safety_rounded,
    Icons.category_rounded,
    Icons.traffic_rounded,
    Icons.security_rounded,
  ][index];
}

Color tileColor(MapMode mode, DistrictModel d) {
  switch (mode) {
    case MapMode.health:
      final h = d.healthPercentage;
      return h >= 70
          ? C.green
          : h >= 45
          ? C.amber
          : C.red;
    case MapMode.type:
      return typeColor(d.type);
    case MapMode.traffic:
      final t = d.metrics.averageTraffic;
      return t > 75
          ? C.red
          : t > 50
          ? C.amber
          : C.green;
    case MapMode.safety:
      final s = d.metrics.safetyScore;
      return s >= 70
          ? C.green
          : s >= 45
          ? C.amber
          : C.red;
  }
}

double tileFrac(MapMode mode, DistrictModel d) {
  switch (mode) {
    case MapMode.health:
      return d.healthPercentage / 100;
    case MapMode.type:
      return 0.6;
    case MapMode.traffic:
      return d.metrics.averageTraffic / 100;
    case MapMode.safety:
      return d.metrics.safetyScore / 100;
  }
}

Color typeColor(DistrictType t) {
  switch (t) {
    case DistrictType.residential:
      return C.cyan;
    case DistrictType.commercial:
      return C.amber;
    case DistrictType.industrial:
      return C.mutedLt;
    case DistrictType.educational:
      return C.violet;
    case DistrictType.medical:
      return C.red;
    case DistrictType.greenZone:
      return C.green;
    case DistrictType.government:
      return C.violet;
    case DistrictType.mixedUse:
      return C.cyan;
    default:
      return C.cyan;
  }
}
