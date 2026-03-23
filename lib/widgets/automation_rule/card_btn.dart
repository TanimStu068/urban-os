import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class CardBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color col;
  final VoidCallback onTap;
  final bool enabled;
  const CardBtn(
    this.label,
    this.icon,
    this.col,
    this.onTap, {
    this.enabled = true,
  });
  @override
  Widget build(BuildContext ctx) => Expanded(
    child: GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: enabled ? col.withOpacity(0.08) : AppColors.bgCard2,
          border: Border.all(
            color: enabled ? col.withOpacity(0.28) : C.muted.withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: enabled ? col : C.muted.withOpacity(0.3),
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7.5,
                color: enabled ? col : C.muted.withOpacity(0.3),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
