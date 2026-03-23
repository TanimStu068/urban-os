import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/signup/check_row.dart';
import 'package:urban_os/widgets/signup/req.dart';
import 'package:urban_os/widgets/signup/shared_input_field.dart';

class Step2Security extends StatelessWidget {
  final TextEditingController passCtrl, confirmCtrl;
  final FocusNode passFocus, confirmFocus;
  final bool passFocused, confirmFocused, obscurePass, obscureConfirm;
  final double passStrength;
  final String? passError, confirmError;
  final bool agreeTerms, agreeData;
  final VoidCallback onTogglePass, onToggleConfirm, onToggleTerms, onToggleData;

  const Step2Security({
    super.key,
    required this.passCtrl,
    required this.passFocus,
    required this.passFocused,
    required this.passError,
    required this.confirmCtrl,
    required this.confirmFocus,
    required this.confirmFocused,
    required this.confirmError,
    required this.obscurePass,
    required this.obscureConfirm,
    required this.passStrength,
    required this.agreeTerms,
    required this.agreeData,
    required this.onTogglePass,
    required this.onToggleConfirm,
    required this.onToggleTerms,
    required this.onToggleData,
  });

  Color get _strengthColor {
    if (passStrength <= .25) return AppColors.error;
    if (passStrength <= .5) return AppColors.amber;
    if (passStrength <= .75) return AppColors.cyan;
    return AppColors.success;
  }

  String get _strengthLabel {
    if (passStrength <= .25) return 'WEAK';
    if (passStrength <= .5) return 'FAIR';
    if (passStrength <= .75) return 'STRONG';
    return 'MAXIMUM';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Column(
        children: [
          Field(
            ctrl: passCtrl,
            focus: passFocus,
            focused: passFocused,
            label: 'ACCESS PASSWORD',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscure: obscurePass,
            error: passError,
            suffix: GestureDetector(
              onTap: onTogglePass,
              child: Icon(
                obscurePass
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.mutedLight,
                size: 17,
              ),
            ),
          ),

          // Strength meter
          if (passCtrl.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Stack(
                      children: [
                        Container(
                          height: 3,
                          color: AppColors.muted.withOpacity(.2),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 3,
                          width:
                              MediaQuery.of(context).size.width *
                              passStrength *
                              .72,
                          color: _strengthColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _strengthLabel,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    letterSpacing: 1.5,
                    color: _strengthColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Requirements
            Row(
              children: [
                Req(met: passCtrl.text.length >= 8, label: '8+ CHARS'),
                const SizedBox(width: 8),
                Req(
                  met: passCtrl.text.contains(RegExp(r'[A-Z]')),
                  label: 'UPPERCASE',
                ),
                const SizedBox(width: 8),
                Req(
                  met: passCtrl.text.contains(RegExp(r'[0-9]')),
                  label: 'NUMBER',
                ),
                const SizedBox(width: 8),
                Req(
                  met: passCtrl.text.contains(RegExp(r'[!@#\$%^&*]')),
                  label: 'SYMBOL',
                ),
              ],
            ),
          ],

          const SizedBox(height: 14),

          Field(
            ctrl: confirmCtrl,
            focus: confirmFocus,
            focused: confirmFocused,
            label: 'CONFIRM PASSWORD',
            hint: '••••••••',
            icon: Icons.lock_person_outlined,
            obscure: obscureConfirm,
            error: confirmError,
            suffix: GestureDetector(
              onTap: onToggleConfirm,
              child: Icon(
                obscureConfirm
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.mutedLight,
                size: 17,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Agreement checkboxes
          CheckRow(
            value: agreeTerms,
            onTap: onToggleTerms,
            label:
                'I agree to the UrbanOS Terms of Service & Operator Agreement',
          ),
          const SizedBox(height: 10),
          CheckRow(
            value: agreeData,
            onTap: onToggleData,
            label: 'I consent to system access logging and activity monitoring',
          ),
        ],
      ),
    );
  }
}
