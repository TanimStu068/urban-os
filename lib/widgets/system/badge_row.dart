import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/system_data_model.dart';

class BadgeRow extends StatelessWidget {
  final SystemEntry entry;
  final AnimationController hotCtrl;
  const BadgeRow({super.key, required this.entry, required this.hotCtrl});

  @override
  Widget build(BuildContext context) {
    final badge = entry.badge;
    final isHot = entry.isHot;
    if (badge == null && !isHot) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: hotCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isHot
              ? entry.accent.withOpacity(0.12 + hotCtrl.value * 0.08)
              : entry.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isHot
                ? entry.accent.withOpacity(0.4 + hotCtrl.value * 0.2)
                : entry.accent.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isHot) ...[
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: entry.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: entry.accent.withOpacity(0.7),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              badge ?? 'HOT',
              style: TextStyle(
                color: entry.accent,
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
