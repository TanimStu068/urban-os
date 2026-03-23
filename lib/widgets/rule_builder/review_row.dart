import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ReviewRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const ReviewRow(this.label, this.value, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Text(
          '$label  ',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: C.muted,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 8.5,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
