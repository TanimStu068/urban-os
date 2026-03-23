import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SettingsSection extends StatelessWidget {
  final String title;
  final Color color;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: color,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: C.bgCard.withOpacity(0.85),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
