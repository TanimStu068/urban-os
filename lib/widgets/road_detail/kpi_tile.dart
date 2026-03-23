import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class KpiTile extends StatelessWidget {
  final String label, value;
  final Color col;
  final IconData icon;
  final double glowT;
  const KpiTile(
    this.label,
    this.value,
    this.col,
    this.icon,
    this.glowT, {
    super.key,
  });

  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: C.bgCard.withOpacity(0.88),
        border: Border.all(color: col.withOpacity(0.2 + glowT * 0.08)),
        boxShadow: [BoxShadow(color: col.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: col.withOpacity(0.1),
                  border: Border.all(color: col.withOpacity(0.25)),
                ),
                child: Icon(icon, color: col, size: 12),
              ),
              const Spacer(),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.green.withOpacity(0.6 + glowT * 0.4),
                  boxShadow: [
                    BoxShadow(
                      color: C.green.withOpacity(0.4 * glowT),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: col,
              shadows: [Shadow(color: col.withOpacity(0.4), blurRadius: 5)],
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 6.5,
              color: C.muted,
              letterSpacing: 0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
