import 'package:flutter/material.dart';

class TermSection {
  final String number;
  final String title;
  final Color color;
  final IconData icon;
  final String highlight;
  final String content;
  const TermSection({
    required this.number,
    required this.title,
    required this.color,
    required this.icon,
    required this.highlight,
    required this.content,
  });
}
