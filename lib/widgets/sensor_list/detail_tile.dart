import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef T = AppColors;

class DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const DetailTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: T.surface,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: T.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, color: T.textSecondary, size: 10),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: T.textSecondary,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: T.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
