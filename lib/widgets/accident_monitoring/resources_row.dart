import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ResourceRow extends StatelessWidget {
  final String unit, type, distance;
  final Color col;
  final double glowT;
  const ResourceRow(
    this.unit,
    this.type,
    this.distance,
    this.col,
    this.glowT, {
    super.key,
  });

  @override
  Widget build(BuildContext ctx) => Container(
    margin: const EdgeInsets.only(bottom: 7),
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: C.bgCard2.withOpacity(0.5),
      border: Border.all(color: col.withOpacity(0.15 + glowT * 0.05)),
    ),
    child: Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: col.withOpacity(0.1),
            border: Border.all(color: col.withOpacity(0.3)),
          ),
          child: Icon(
            Icons.local_fire_department_rounded,
            color: col,
            size: 12,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                unit,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: col,
                ),
              ),
              Text(
                type,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: C.muted,
                ),
              ),
            ],
          ),
        ),
        Text(
          distance,
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: col,
          ),
        ),
      ],
    ),
  );
}
