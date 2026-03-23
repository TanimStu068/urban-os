import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class WRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const WRow(this.icon, this.text, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(
      children: [
        Icon(icon, color: color, size: 11),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 8.5,
            color: C.white.withOpacity(0.85),
          ),
        ),
      ],
    ),
  );
}
