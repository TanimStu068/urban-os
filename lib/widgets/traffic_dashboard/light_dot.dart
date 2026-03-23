import 'package:flutter/material.dart';

class LightDot extends StatelessWidget {
  final Color col;
  final bool isOn, blink;
  final double pulseT, blinkT;
  const LightDot(
    this.col, {
    required this.isOn,
    required this.blink,
    required this.pulseT,
    required this.blinkT,
  });

  @override
  Widget build(BuildContext ctx) {
    final opacity = isOn ? (blink ? .4 + blinkT * .6 : .9 + pulseT * .1) : .12;
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: col.withOpacity(opacity),
        boxShadow: isOn
            ? [
                BoxShadow(
                  color: col.withOpacity(.6),
                  blurRadius: blink ? 6 + blinkT * 6 : 6,
                ),
              ]
            : [],
      ),
    );
  }
}
