import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ReviewSection extends StatelessWidget {
  final String title;
  final Color color;
  final List<String> items;
  const ReviewSection(this.title, this.color, this.items, {super.key});
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: C.bgCard2.withOpacity(0.4),
      border: Border.all(color: C.gBdr),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: color,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        ...items.map(
          (i) => Text(
            i,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              color: C.mutedLt,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}
