import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class AutoStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const AutoStat({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: color,
          shadows: [Shadow(color: color.withOpacity(.3), blurRadius: 5)],
        ),
      ),
      Text(
        label,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 7,
          letterSpacing: 1.5,
          color: C.muted,
        ),
      ),
    ],
  );
}
