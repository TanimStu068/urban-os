import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const EmptyState({super.key, required this.icon, required this.message});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      children: [
        Icon(icon, color: C.muted, size: 28),
        const SizedBox(height: 8),
        Text(
          message,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            color: C.muted,
            letterSpacing: 1,
          ),
        ),
      ],
    ),
  );
}
