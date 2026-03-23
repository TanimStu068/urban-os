import 'package:flutter/material.dart';

class ArrowBtn extends StatelessWidget {
  final Color color;
  final double size;
  const ArrowBtn({super.key, required this.color, this.size = 32});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Icon(Icons.arrow_forward_rounded, color: color, size: size * 0.5),
  );
}
