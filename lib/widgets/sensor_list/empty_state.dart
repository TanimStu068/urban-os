import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef T = AppColors;

class EmptyState extends StatelessWidget {
  final String query;
  const EmptyState({super.key, required this.query});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.sensors_off_rounded, color: T.textMuted, size: 56),
        const SizedBox(height: 20),
        Text(
          query.isNotEmpty ? 'No sensors match "$query"' : 'No sensors found',
          style: const TextStyle(
            color: T.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Try adjusting your filters or search query',
          style: TextStyle(color: T.textMuted, fontSize: 13),
        ),
      ],
    ),
  );
}
