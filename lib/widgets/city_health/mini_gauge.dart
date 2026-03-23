import 'package:flutter/material.dart';

class MiniGauge extends StatelessWidget {
  final String label, unit;
  final double value, max;
  final Color color;
  const MiniGauge({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    required this.unit,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    final p = (value / max).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withOpacity(.05),
        border: Border.all(color: color.withOpacity(.15)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              letterSpacing: 1.5,
              color: color.withOpacity(.8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${value.toStringAsFixed(0)}${unit.isNotEmpty ? " $unit" : ""}',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
              shadows: [Shadow(color: color.withOpacity(.4), blurRadius: 6)],
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Stack(
              children: [
                Container(height: 3, color: color.withOpacity(.1)),
                FractionallySizedBox(
                  widthFactor: p,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withOpacity(.6), color],
                      ),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(color: color.withOpacity(.35), blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
