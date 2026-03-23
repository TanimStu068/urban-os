import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class HeroKpi extends StatelessWidget {
  final String label, value;
  final Color col;
  final IconData icon;
  final bool isAlert;
  final double glowT;
  const HeroKpi(
    this.label,
    this.value,
    this.col,
    this.icon,
    this.isAlert,
    this.glowT,
  );
  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: col.withOpacity(.1),
            border: Border.all(color: col.withOpacity(.25)),
          ),
          child: Icon(icon, color: col, size: 14),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isAlert ? C.red : col,
                  shadows: [Shadow(color: col.withOpacity(.4), blurRadius: 6)],
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 6.5,
                  letterSpacing: .8,
                  color: C.muted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
