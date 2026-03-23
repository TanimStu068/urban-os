import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class KpiCard extends StatelessWidget {
  final String label, value, sub;
  final IconData icon;
  final Color color;
  final double progress;
  final AnimationController glowCtrl;
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.sub,
    required this.icon,
    required this.color,
    required this.progress,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: glowCtrl,
    builder: (_, __) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: C.bgCard.withOpacity(.85),
        border: Border.all(
          color: color.withOpacity(.15 + glowCtrl.value * .06),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.07 + glowCtrl.value * .04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    letterSpacing: 1.5,
                    color: color.withOpacity(.8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
              shadows: [Shadow(color: color.withOpacity(.5), blurRadius: 8)],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              color: C.muted,
              letterSpacing: .5,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Stack(
              children: [
                Container(height: 3, color: color.withOpacity(.1)),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        colors: [color.withOpacity(.6), color],
                      ),
                      boxShadow: [
                        BoxShadow(color: color.withOpacity(.4), blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
