import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class DetailStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const DetailStat(this.label, this.value, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => Column(
    children: [
      Text(
        value,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 10,
          fontWeight: FontWeight.w900,
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
