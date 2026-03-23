import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, AppColors.glassBorder],
            ),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          'OR',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            letterSpacing: 3,
            color: AppColors.muted,
          ),
        ),
      ),
      Expanded(
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.glassBorder, Colors.transparent],
            ),
          ),
        ),
      ),
    ],
  );
}
