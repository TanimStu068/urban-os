import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class FilterChipWidget extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;
  final IconData? icon;
  const FilterChipWidget({
    super.key,
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isActive ? color.withOpacity(.18) : C.bgCard.withOpacity(.8),
          border: Border.all(
            color: isActive ? color.withOpacity(.6) : C.gBdr,
            width: isActive ? 1.2 : 1,
          ),
          boxShadow: isActive
              ? [BoxShadow(color: color.withOpacity(.15), blurRadius: 8)]
              : [],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: isActive ? color : C.mutedLt, size: 11),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                letterSpacing: 1.5,
                color: isActive ? color : C.mutedLt,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
