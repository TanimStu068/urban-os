import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class Panel extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;
  const Panel({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: C.bgCard2.withOpacity(0.5),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Color(0x1200D4FF)),
        const SizedBox(height: 10),
        child,
      ],
    ),
  );
}
