import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const DetailItem(this.label, this.value, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            color: C.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
