import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class MiniTabBtn extends StatelessWidget {
  final String label;
  final int idx, current;
  final Color col;
  final VoidCallback onTap;
  const MiniTabBtn(
    this.label,
    this.idx,
    this.current,
    this.col,
    this.onTap, {
    super.key,
  });
  @override
  Widget build(BuildContext ctx) {
    final isSel = idx == current;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSel ? col.withOpacity(0.15) : Colors.transparent,
          border: Border.all(color: isSel ? col.withOpacity(0.5) : C.gBdr),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: isSel ? col : C.muted,
          ),
        ),
      ),
    );
  }
}
