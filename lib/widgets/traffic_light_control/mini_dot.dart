import 'package:flutter/material.dart';

class MiniDot extends StatelessWidget {
  final Color col;
  final bool isOn;
  final double blinkT;
  const MiniDot(this.col, {required this.isOn, required this.blinkT});

  @override
  Widget build(BuildContext ctx) => Container(
    width: 7,
    height: 7,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: col.withOpacity(isOn ? 0.85 : 0.1),
      boxShadow: isOn
          ? [BoxShadow(color: col.withOpacity(0.6), blurRadius: 4)]
          : [],
    ),
  );
}
