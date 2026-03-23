import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class CyberInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final String label, hint;
  final IconData icon;
  final bool obscureText;
  final String? error;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const CyberInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.error,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    final borderColor = hasError
        ? AppColors.error
        : isFocused
        ? AppColors.cyan
        : AppColors.glassBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 3,
              height: 10,
              color: isFocused ? AppColors.cyan : AppColors.muted,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                letterSpacing: 2,
                color: isFocused ? AppColors.cyan : AppColors.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Input container
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.inputBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: isFocused ? 1.0 : 0.8,
            ),
            boxShadow: isFocused
                ? [
                    BoxShadow(
                      color: AppColors.cyan.withOpacity(0.12),
                      blurRadius: 16,
                      spreadRadius: -2,
                    ),
                  ]
                : hasError
                ? [
                    BoxShadow(
                      color: AppColors.error.withOpacity(0.1),
                      blurRadius: 12,
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: AppColors.white,
              letterSpacing: 1,
            ),
            cursorColor: AppColors.cyan,
            cursorWidth: 1.5,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.muted,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
              prefixIcon: Icon(
                icon,
                color: isFocused ? AppColors.cyan : AppColors.muted,
                size: 18,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 4,
              ),
            ),
          ),
        ),

        // Error text
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.error,
                  size: 10,
                ),
                const SizedBox(width: 4),
                Text(
                  error!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    color: AppColors.error,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
