import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef _C = AppColors;

class AnimatedStatPill extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final AnimationController ctrl;

  const AnimatedStatPill({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ctrl,
    builder: (_, __) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08 + ctrl.value * 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3 + ctrl.value * 0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1 + ctrl.value * 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 13),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: _C.textSub,
                fontSize: 6.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
