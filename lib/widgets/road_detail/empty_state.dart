import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color col;
  const EmptyState(this.message, this.icon, this.col);

  @override
  Widget build(BuildContext ctx) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: col.withOpacity(0.5), size: 18),
        const SizedBox(width: 8),
        Text(
          message,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            color: col.withOpacity(0.6),
          ),
        ),
      ],
    ),
  );
}
