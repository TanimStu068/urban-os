import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class DetailItem extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const DetailItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      color: C.bgCard2,
      border: Border.all(color: C.gBdr),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: C.muted, size: 10),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 7,
                letterSpacing: 1.5,
                color: C.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            color: C.white,
            letterSpacing: .5,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
