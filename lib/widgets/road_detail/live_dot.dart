import 'package:flutter/services.dart';

class LiveDot {
  double progress;
  final int lane;
  final Color color;
  final double speed;
  final bool isReverse;
  LiveDot({
    required this.progress,
    required this.lane,
    required this.color,
    required this.speed,
    required this.isReverse,
  });
}
