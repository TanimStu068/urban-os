import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class RecommendRow extends StatelessWidget {
  final String text, priority;
  final IconData icon;
  final Color color;
  const RecommendRow({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.priority,
  });

  @override
  Widget build(BuildContext ctx) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          margin: const EdgeInsets.only(right: 10, top: 1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 12),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              color: C.mutedLt,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: color.withOpacity(0.08),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Text(
            priority,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 6.5,
              color: color,
            ),
          ),
        ),
      ],
    ),
  );
}
