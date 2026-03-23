import 'package:flutter/material.dart';

class BigLight extends StatelessWidget {
  final Color col;
  final bool isOn, blink;
  final double blinkT, pulseT, glowT;
  final double size;
  const BigLight(
    this.col, {
    required this.isOn,
    required this.blink,
    required this.blinkT,
    required this.pulseT,
    required this.glowT,
    this.size = 30,
  });

  @override
  Widget build(BuildContext ctx) {
    final opacity = isOn
        ? (blink ? 0.4 + blinkT * 0.6 : 0.85 + pulseT * 0.15)
        : 0.08;
    final glowOpacity = isOn ? (0.6 + glowT * 0.3) : 0.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: col.withOpacity(opacity),
        boxShadow: isOn
            ? [
                BoxShadow(
                  color: col.withOpacity(glowOpacity),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: col.withOpacity(glowOpacity * 0.4),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ]
            : [],
      ),
      child: isOn
          ? Center(
              child: Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            )
          : null,
    );
  }
}
