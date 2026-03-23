import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/signup/shared_input_field.dart';

class Step0Identity extends StatelessWidget {
  final TextEditingController nameCtrl, emailCtrl, idCtrl;
  final FocusNode nameFocus, emailFocus, idFocus;
  final bool nameFocused, emailFocused, idFocused;
  final String? nameError, emailError, idError;

  const Step0Identity({
    super.key,
    required this.nameCtrl,
    required this.nameFocus,
    required this.nameFocused,
    required this.nameError,
    required this.emailCtrl,
    required this.emailFocus,
    required this.emailFocused,
    required this.emailError,
    required this.idCtrl,
    required this.idFocus,
    required this.idFocused,
    required this.idError,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
      child: Column(
        children: [
          Field(
            ctrl: nameCtrl,
            focus: nameFocus,
            focused: nameFocused,
            label: 'FULL NAME',
            hint: 'John Anderson',
            icon: Icons.badge_outlined,
            error: nameError,
            kbType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          Field(
            ctrl: emailCtrl,
            focus: emailFocus,
            focused: emailFocused,
            label: 'OFFICIAL EMAIL',
            hint: 'j.anderson@urbanos.city',
            icon: Icons.alternate_email_rounded,
            error: emailError,
            kbType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          Field(
            ctrl: idCtrl,
            focus: idFocus,
            focused: idFocused,
            label: 'OPERATOR ID',
            hint: 'OPS-2026-XXXX',
            icon: Icons.fingerprint_rounded,
            error: idError,
          ),
          const SizedBox(height: 16),
          // Info box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.amber.withOpacity(.25)),
              color: AppColors.amber.withOpacity(.05),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.amber,
                  size: 14,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Your Operator ID will be verified against the city registry. Contact admin if you don\'t have one.',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      color: AppColors.amber,
                      letterSpacing: .3,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
