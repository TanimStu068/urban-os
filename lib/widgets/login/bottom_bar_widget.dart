import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});
  @override
  Widget build(BuildContext context) => Positioned(
    bottom: 24,
    left: 0,
    right: 0,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '© 2026 UrbanOS',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              letterSpacing: 2,
              color: AppColors.muted,
            ),
          ),
          Container(
            width: 1,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.glassBorder,
          ),
          const Text(
            'IoT Platform v4.2.1',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              letterSpacing: 2,
              color: AppColors.muted,
            ),
          ),
          Container(
            width: 1,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.glassBorder,
          ),
          const Text(
            'All Rights Reserved',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              letterSpacing: 2,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    ),
  );
}
