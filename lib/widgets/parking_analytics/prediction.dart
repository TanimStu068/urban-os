import 'package:flutter/material.dart';

class Prediction {
  final String text;
  final IconData icon;
  final Color color;
  final String tag;

  Prediction({
    required this.text,
    required this.icon,
    required this.color,
    required this.tag,
  });
}
