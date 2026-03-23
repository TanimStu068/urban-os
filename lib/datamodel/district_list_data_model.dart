import 'package:flutter/painting.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_type.dart';

typedef C = AppColors;
Color healthColor(double h) => h >= 70
    ? C.green
    : h >= 45
    ? C.amber
    : C.red;

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
    case DistrictType.transportHub:
      return C.amber;
    case DistrictType.greenZone:
      return C.green;
    case DistrictType.government:
      return C.violet;
    case DistrictType.mixedUse:
      return C.cyan;
    case DistrictType.agricultural:
      return C.green;
    case DistrictType.entertainment:
      return C.red;
    case DistrictType.military:
      return C.mutedLt;
    case DistrictType.economicZone:
      return C.cyan;
  }
}

String fmtNum(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
  return '$n';
}
