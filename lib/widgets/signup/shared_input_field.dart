import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class Field extends StatelessWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final bool focused;
  final String label, hint;
  final IconData icon;
  final bool obscure;
  final String? error;
  final Widget? suffix;
  final TextInputType? kbType;

  const Field({
    super.key,
    required this.ctrl,
    required this.focus,
    required this.focused,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.error,
    this.suffix,
    this.kbType,
  });

  @override
  Widget build(BuildContext context) {
    final hasErr = error != null;
    final bdrColor = hasErr
        ? AppColors.error
        : focused
        ? AppColors.cyan
        : AppColors.glassBdr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 3,
              height: 10,
              color: focused ? AppColors.cyan : AppColors.muted,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                letterSpacing: 2,
                color: focused ? AppColors.cyan : AppColors.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: bdrColor, width: focused ? 1.0 : 0.8),
            color: AppColors.inputBg,
            boxShadow: focused
                ? [
                    BoxShadow(
                      color: AppColors.cyan.withOpacity(.1),
                      blurRadius: 14,
                      spreadRadius: -2,
                    ),
                  ]
                : hasErr
                ? [
                    BoxShadow(
                      color: AppColors.error.withOpacity(.08),
                      blurRadius: 10,
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: ctrl,
            focusNode: focus,
            obscureText: obscure,
            keyboardType: kbType,
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
                color: focused ? AppColors.cyan : AppColors.muted,
                size: 17,
              ),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 4,
              ),
            ),
          ),
        ),
        if (hasErr)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
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
                    letterSpacing: .5,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
