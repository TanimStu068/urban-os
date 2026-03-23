import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef _C = AppColors;

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final VoidCallback? onToggle;
  final String? Function(String?) validator;

  const PasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.validator,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 9,
        color: _C.white,
        letterSpacing: 1.2,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 8,
          color: _C.mutedLt.withOpacity(0.6),
        ),
        filled: true,
        fillColor: _C.bgCard2.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _C.mutedLt.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _C.mutedLt.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _C.red.withOpacity(0.5), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _C.red.withOpacity(0.7)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _C.red, width: 1.5),
        ),
        errorStyle: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 6.5,
          color: _C.red,
        ),
        suffixIcon: onToggle != null
            ? GestureDetector(
                onTap: onToggle,
                child: Icon(
                  obscure
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: _C.mutedLt,
                  size: 16,
                ),
              )
            : null,
      ),
    );
  }
}
