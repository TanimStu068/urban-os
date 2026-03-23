import 'package:flutter/material.dart';

class PolicySection {
  final IconData icon;
  final String title;
  final Color color;
  final List<PolicyPoint> content;
  const PolicySection({
    required this.icon,
    required this.title,
    required this.color,
    required this.content,
  });
}

class PolicyPoint {
  final String title;
  final String detail;
  const PolicyPoint({required this.title, required this.detail});
}
