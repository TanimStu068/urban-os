import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class RingKpiRow extends StatelessWidget {
  final String label, value, pct;
  final Color col;
  const RingKpiRow(this.label, this.value, this.pct, this.col);
  @override
  Widget build(BuildContext ctx) => Row(
    children: [
      Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: col.withOpacity(0.8),
        ),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: C.mutedLt,
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: col,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      if (pct.isNotEmpty) ...[
        const SizedBox(width: 5),
        Text(
          pct,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            color: col.withOpacity(0.6),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ],
  );
}
