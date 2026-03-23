import 'package:flutter/material.dart';

class Recommendation {
  final String text;
  final IconData icon;
  final Color color;
  final String priority;

  Recommendation({
    required this.text,
    required this.icon,
    required this.color,
    required this.priority,
  });
}
