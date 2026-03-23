import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SectionHeader extends StatelessWidget {
  final String title, sub;
  final IconData icon;
  final Color color;
  final Widget? trailing;
  const SectionHeader({
    super.key,
    required this.title,
    required this.sub,
    required this.icon,
    required this.color,
    required this.trailing,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: C.gBdr)),
        color: color.withOpacity(.03),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: color,
              boxShadow: [BoxShadow(color: color, blurRadius: 6)],
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  letterSpacing: 2.5,
                  color: color,
                ),
              ),
              Text(
                sub,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: C.muted,
                  letterSpacing: .5,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
