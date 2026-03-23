import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ConfirmationForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final bool isPasswordProvider;
  final bool isGoogleUser;

  final TextEditingController passwordCtrl;
  final TextEditingController confirmCtrl;

  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  final bool checkboxConfirmed;
  final VoidCallback onToggleCheckbox;

  final Widget Function(String text) inputLabelBuilder;
  final Widget Function({
    required TextEditingController controller,
    required String hintText,
    required bool obscure,
    required VoidCallback? onToggle,
    required String? Function(String?) validator,
  })
  passwordFieldBuilder;

  const ConfirmationForm({
    super.key,
    required this.formKey,
    required this.isPasswordProvider,
    required this.isGoogleUser,
    required this.passwordCtrl,
    required this.confirmCtrl,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.checkboxConfirmed,
    required this.onToggleCheckbox,
    required this.inputLabelBuilder,
    required this.passwordFieldBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: C.bgCard.withOpacity(0.85),
          border: Border.all(color: C.mutedLt.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CONFIRM DELETION',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7.5,
                color: C.mutedLt,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            /// 🔐 Password user
            if (isPasswordProvider) ...[
              inputLabelBuilder('Current Password'),
              const SizedBox(height: 6),
              passwordFieldBuilder(
                controller: passwordCtrl,
                hintText: '••••••••••••',
                obscure: obscurePassword,
                onToggle: onTogglePassword,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Password is required';
                  if (val.length < 6) return 'Min 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              inputLabelBuilder('Type  DELETE  to confirm'),
              const SizedBox(height: 6),
              passwordFieldBuilder(
                controller: confirmCtrl,
                hintText: 'Type DELETE here',
                obscure: false,
                onToggle: null,
                validator: (val) {
                  if (val?.trim() != 'DELETE') {
                    return 'Type DELETE exactly';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
            ],

            /// 🔵 Google user
            if (isGoogleUser) ...[
              inputLabelBuilder('Type  DELETE  to confirm'),
              const SizedBox(height: 6),
              passwordFieldBuilder(
                controller: confirmCtrl,
                hintText: 'Type DELETE here',
                obscure: false,
                onToggle: null,
                validator: (val) {
                  if (val?.trim() != 'DELETE') {
                    return 'Type DELETE exactly';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: C.amber.withOpacity(0.08),
                  border: Border.all(color: C.amber.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: C.amber, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You will be prompted to re-authenticate with Google before deletion.',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 6.5,
                          color: C.amber.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            /// ☑️ Checkbox
            GestureDetector(
              onTap: onToggleCheckbox,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: checkboxConfirmed
                          ? C.red.withOpacity(0.25)
                          : C.muted.withOpacity(0.6),
                      border: Border.all(
                        color: checkboxConfirmed
                            ? C.red.withOpacity(0.7)
                            : C.mutedLt.withOpacity(0.5),
                      ),
                    ),
                    child: checkboxConfirmed
                        ? const Icon(
                            Icons.check_rounded,
                            color: C.red,
                            size: 10,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'I understand this is permanent and irreversible.',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 6.5,
                        color: C.white.withOpacity(0.75),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
