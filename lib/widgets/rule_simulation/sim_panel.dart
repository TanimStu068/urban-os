import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SimPanel extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;
  final String? badge;
  final Color? badgeColor;
  const SimPanel({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
    this.badge,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13),
      color: C.bgCard.withOpacity(0.88),
      border: Border.all(color: C.gBdr),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(icon, color: color, size: 11),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: 1.5,
              ),
            ),
            if (badge != null) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: (badgeColor ?? C.muted).withOpacity(0.1),
                  border: Border.all(
                    color: (badgeColor ?? C.muted).withOpacity(0.25),
                  ),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    color: badgeColor ?? C.muted,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        const Divider(color: Color(0x1A00D4FF), height: 1),
        const SizedBox(height: 10),
        child,
      ],
    ),
  );
}
