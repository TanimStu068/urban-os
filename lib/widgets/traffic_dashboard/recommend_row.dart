import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class RecommendRow extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const RecommendRow({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
  });
  @override
  Widget build(BuildContext ctx) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.1),
            border: Border.all(color: color.withOpacity(.3)),
          ),
          child: Icon(icon, color: color, size: 11),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              color: C.mutedLt,
              height: 1.4,
              letterSpacing: .2,
            ),
          ),
        ),
      ],
    ),
  );
}
