import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ToggleItem extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool isEnabled;
  final Color color;
  final VoidCallback onToggle;

  const ToggleItem({
    required this.label,
    required this.description,
    required this.icon,
    required this.isEnabled,
    required this.color,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: C.bgCard.withOpacity(0.85),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: color.withOpacity(0.15),
            ),
            child: Center(child: Icon(icon, color: color, size: 14)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    color: C.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6,
                    color: C.mutedLt,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isEnabled
                    ? color.withOpacity(0.25)
                    : C.muted.withOpacity(0.5),
              ),
              child: isEnabled
                  ? Icon(Icons.check_rounded, color: color, size: 12)
                  : const Icon(Icons.close_rounded, color: C.mutedLt, size: 12),
            ),
          ),
        ],
      ),
    );
  }
}
