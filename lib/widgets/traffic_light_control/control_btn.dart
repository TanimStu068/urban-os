import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ControlBtn extends StatelessWidget {
  final String label;
  final Color col;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  final bool enabled;
  const ControlBtn(
    this.label,
    this.col,
    this.icon,
    this.onTap,
    this.isActive, {
    this.enabled = true,
  });

  @override
  Widget build(BuildContext ctx) => Expanded(
    child: GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: isActive
              ? col.withOpacity(0.15)
              : (enabled ? col.withOpacity(0.07) : C.bgCard2),
          border: Border.all(
            color: isActive
                ? col.withOpacity(0.5)
                : col.withOpacity(enabled ? 0.2 : 0.08),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: col.withOpacity(enabled ? (isActive ? 1 : 0.7) : 0.25),
              size: 9,
            ),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 6.5,
                  color: col.withOpacity(enabled ? (isActive ? 1 : 0.8) : 0.3),
                  letterSpacing: 0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
