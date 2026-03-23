import 'package:flutter/material.dart';

extension DashedLine on Canvas {
  void drawDashedLine(
    Offset a,
    Offset b,
    Paint paint, {
    double dashLen = 4,
    double gapLen = 6,
  }) {
    final dir = (b - a) / (b - a).distance;
    final total = (b - a).distance;
    double pos = 0;
    while (pos < total) {
      final end = (pos + dashLen).clamp(0.0, total);
      drawLine(a + dir * pos, a + dir * end, paint);
      pos += dashLen + gapLen;
    }
  }
}
