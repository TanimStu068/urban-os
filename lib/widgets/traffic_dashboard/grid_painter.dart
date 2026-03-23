import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;
// Traffic theme accent
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

class GridPainter extends CustomPainter {
  final double t;
  GridPainter(this.t);
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()
      ..color = kAccent.withOpacity(.012 * (.5 + (sin(t * pi) + 1) / 2 * .3))
      ..strokeWidth = .4;
    for (double x = 0; x < s.width; x += 60)
      c.drawLine(Offset(x, 0), Offset(x, s.height), p);
    for (double y = 0; y < s.height; y += 60)
      c.drawLine(Offset(0, y), Offset(s.width, y), p);
  }

  @override
  bool shouldRepaint(GridPainter o) => o.t != t;
}
