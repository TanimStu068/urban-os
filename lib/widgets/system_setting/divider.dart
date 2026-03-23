import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final Color color;
  const DividerWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    color: color.withOpacity(0.08),
  );
}
