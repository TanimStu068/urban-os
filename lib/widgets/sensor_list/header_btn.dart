import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef _T = AppColors;

class HeaderBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final Color activeColor;

  const HeaderBtn({
    super.key,
    required this.icon,
    required this.onTap,
    required this.active,
    this.activeColor = _T.cyan,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: active ? activeColor.withOpacity(0.15) : _T.surfaceMd,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: active ? activeColor.withOpacity(0.5) : _T.border,
        ),
      ),
      child: Icon(
        icon,
        color: active ? activeColor : _T.textSecondary,
        size: 18,
      ),
    ),
  );
}
