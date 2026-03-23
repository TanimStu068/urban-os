import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class DiffStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const DiffStat(this.label, this.value, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 8.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      Text(
        label,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 6.5,
          color: C.muted,
        ),
      ),
    ],
  );
}
