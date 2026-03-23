import 'package:flutter/material.dart';
import 'water_management_models.dart';

class WaterGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? borderColor;
  final double radius;

  const WaterGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: C.bgCard,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? C.gBdr),
        boxShadow: [
          BoxShadow(
            color: C.cyan.withOpacity(.04),
            blurRadius: 16,
            spreadRadius: -2,
          ),
        ],
      ),
      child: child,
    );
  }
}

class WaterLabel extends StatelessWidget {
  final String text;
  final Color? color;
  final double size;
  final FontWeight weight;
  final double letterSpacing;

  const WaterLabel({
    super.key,
    required this.text,
    this.color,
    this.size = 10,
    this.weight = FontWeight.w700,
    this.letterSpacing = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? C.mutedHi,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        fontFamily: 'monospace',
      ),
    );
  }
}

class WaterDot extends StatelessWidget {
  final Color color;
  final double radius;

  const WaterDot(this.color, [this.radius = 3.5]);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withOpacity(.6), blurRadius: 4)],
      ),
    );
  }
}

class WaterBadge extends StatelessWidget {
  final String text;
  final Color color;

  const WaterBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
