import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class CircleBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool active;
  final VoidCallback onTap;
  const CircleBtn({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: active ? color.withOpacity(0.5) : AppColors.gBdr,
          ),
        ),
        child: Icon(icon, color: active ? color : AppColors.mutedLt, size: 13),
      ),
    );
  }
}
