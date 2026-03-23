import 'package:flutter/material.dart';

class CardHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const CardHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: color,
            boxShadow: [BoxShadow(color: color, blurRadius: 6)],
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 7),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            letterSpacing: 2,
            color: color,
          ),
        ),
      ],
    ),
  );
}
