import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color col;
  final VoidCallback? onTap;
  const ActionBtn(this.label, this.icon, this.col, this.onTap, {super.key});

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: onTap != null ? col.withOpacity(0.1) : C.bgCard2,
          border: Border.all(
            color: onTap != null
                ? col.withOpacity(0.35)
                : C.muted.withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: onTap != null ? col : C.muted.withOpacity(0.3),
              size: 13,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: onTap != null ? col : C.muted.withOpacity(0.3),
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
