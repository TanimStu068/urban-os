import 'package:flutter/material.dart';

class MiniTag extends StatelessWidget {
  final String label;
  final Color color;
  const MiniTag({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color.withOpacity(0.85),
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
