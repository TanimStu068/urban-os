import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart'; // assuming C is defined here

typedef C = AppColors;

class EmptyDistrictWidget extends StatelessWidget {
  const EmptyDistrictWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.grid_off_rounded, color: C.mutedLt, size: 44),
          const SizedBox(height: 12),
          const Text(
            'NO DISTRICT DATA',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: C.mutedLt,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ensure mock_data/district.json is loaded',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8.5,
              color: C.mutedLt,
            ),
          ),
        ],
      ),
    );
  }
}
