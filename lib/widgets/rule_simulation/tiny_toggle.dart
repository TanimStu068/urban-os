import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class TinyToggle extends StatelessWidget {
  final bool value;
  final VoidCallback onToggle;
  const TinyToggle({super.key, required this.value, required this.onToggle});
  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onToggle,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 36,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: value ? C.cyan.withOpacity(0.18) : C.bgCard2,
        border: Border.all(
          color: value ? C.cyan.withOpacity(0.5) : C.muted.withOpacity(0.3),
        ),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 180),
            left: value ? 18 : 2,
            top: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? C.cyan : C.mutedLt,
                boxShadow: value
                    ? [BoxShadow(color: C.cyan.withOpacity(0.5), blurRadius: 4)]
                    : [],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
