import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class MiniStat extends StatelessWidget {
  final String label, value;
  final Color col;
  const MiniStat(this.label, this.value, this.col);
  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: col.withOpacity(.07),
        border: Border.all(color: col.withOpacity(.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: col,
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
      ),
    ),
  );
}
