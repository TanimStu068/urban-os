import 'package:flutter/material.dart';

class CardHeaderSimple extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const CardHeaderSimple({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: color,
            boxShadow: [BoxShadow(color: color, blurRadius: 5)],
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            letterSpacing: 2,
            color: color,
          ),
        ),
      ],
    ),
  );
}
