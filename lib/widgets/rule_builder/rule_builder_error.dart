import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class RuleBuilderError extends StatelessWidget {
  final String? errorMessage;

  const RuleBuilderError({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: C.red.withOpacity(0.06),
        border: Border.all(color: C.red.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, color: C.red, size: 36),
          const SizedBox(height: 10),
          Text(
            errorMessage ?? 'Please complete this step',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: C.red,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
