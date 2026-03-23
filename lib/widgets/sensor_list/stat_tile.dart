import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef _T = AppColors;

class StatTile extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 85,
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.12) : _T.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? color.withOpacity(0.45) : _T.border,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  color: active ? color : _T.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: _T.textSecondary,
                  fontSize: 7,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
