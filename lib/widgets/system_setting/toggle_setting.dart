import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ToggleSetting extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool value;
  final Color color;
  final Function(bool) onChanged;

  const ToggleSetting({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: value
                    ? color.withOpacity(0.25)
                    : C.muted.withOpacity(0.5),
              ),
              child: value
                  ? Icon(Icons.check_rounded, color: color, size: 12)
                  : const Icon(Icons.close_rounded, color: C.mutedLt, size: 12),
            ),
          ],
        ),
      ),
    );
  }
}
