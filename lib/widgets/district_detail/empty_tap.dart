import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class EmptyTab extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyTab({super.key, required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: C.mutedLt, size: 36),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: C.mutedLt,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
