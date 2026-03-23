import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SummaryKpi extends StatelessWidget {
  final String value, label;
  final Color col;
  final IconData icon;
  final double glowT;
  const SummaryKpi(this.value, this.label, this.col, this.icon, this.glowT);

  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: col.withOpacity(0.1),
            border: Border.all(color: col.withOpacity(0.22)),
          ),
          child: Icon(icon, color: col, size: 11),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: col,
                  shadows: [Shadow(color: col.withOpacity(0.4), blurRadius: 5)],
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 6,
                  letterSpacing: 0.5,
                  color: C.muted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
