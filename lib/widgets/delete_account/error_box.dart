import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef _C = AppColors;

class ErrorBox extends StatelessWidget {
  final String message;
  final Animation<double> shake;

  const ErrorBox({super.key, required this.message, required this.shake});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shake,
      builder: (_, child) =>
          Transform.translate(offset: Offset(shake.value, 0), child: child),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _C.red.withOpacity(0.10),
          border: Border.all(color: _C.red.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: _C.red, size: 14),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: _C.red,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
