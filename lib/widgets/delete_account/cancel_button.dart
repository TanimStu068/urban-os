import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef _C = AppColors;

class CancelButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CancelButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.maybePop(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
          border: Border.all(color: _C.mutedLt.withOpacity(0.3)),
        ),
        child: const Center(
          child: Text(
            'CANCEL — KEEP MY ACCOUNT',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              color: _C.mutedLt,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
