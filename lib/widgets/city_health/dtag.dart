import 'package:flutter/material.dart';

class DTag extends StatelessWidget {
  final String label;
  final Color color;
  const DTag({super.key, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: color.withOpacity(.1),
      border: Border.all(color: color.withOpacity(.3)),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 7,
        letterSpacing: 1,
        color: color,
      ),
    ),
  );
}
