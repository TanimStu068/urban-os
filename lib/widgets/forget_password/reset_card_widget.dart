import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/forget_password/action_button_widget.dart';
import 'package:urban_os/widgets/forget_password/card_banner_widget.dart';
import 'package:urban_os/widgets/forget_password/card_wrap_widget.dart';
import 'package:urban_os/widgets/forget_password/input_field_widget.dart';
import 'package:urban_os/widgets/forget_password/req_widget.dart';
import 'package:urban_os/widgets/forget_password/shield_illustration_widget.dart';

class ResetCard extends StatelessWidget {
  final TextEditingController passCtrl, confirmCtrl;
  final FocusNode passFocus, confirmFocus;
  final bool passFocused, confirmFocused, obscurePass, obscureConfirm;
  final double passStrength;
  final String? passError, confirmError;
  final bool isLoading;
  final AnimationController loadingCtrl;
  final VoidCallback onTogglePass, onToggleConfirm, onSubmit;

  const ResetCard({
    super.key,
    required this.passCtrl,
    required this.passFocus,
    required this.passFocused,
    required this.confirmCtrl,
    required this.confirmFocus,
    required this.confirmFocused,
    required this.obscurePass,
    required this.obscureConfirm,
    required this.passStrength,
    required this.passError,
    required this.confirmError,
    required this.isLoading,
    required this.loadingCtrl,
    required this.onTogglePass,
    required this.onToggleConfirm,
    required this.onSubmit,
  });

  Color get _sColor {
    if (passStrength <= .25) return AppColors.error;
    if (passStrength <= .5) return AppColors.amber;
    if (passStrength <= .75) return AppColors.cyan;
    return AppColors.success;
  }

  String get _sLabel {
    if (passStrength <= .25) return 'WEAK';
    if (passStrength <= .5) return 'FAIR';
    if (passStrength <= .75) return 'STRONG';
    return 'MAXIMUM';
  }

  @override
  Widget build(BuildContext context) {
    return CardWrap(
      accentColor: AppColors.teal,
      child: Column(
        children: [
          CardBanner(
            title: 'NEW CREDENTIALS',
            sub: 'Set your new access password',
            icon: Icons.lock_open_rounded,
            color: AppColors.teal,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              children: [
                ShieldIllustration(),
                const SizedBox(height: 22),
                InputFieldWidget(
                  ctrl: passCtrl,
                  focus: passFocus,
                  focused: passFocused,
                  label: 'NEW ACCESS CODE',
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  obscure: obscurePass,
                  error: passError,
                  accentColor: AppColors.teal,
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
                                    .7,
                                color: _sColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _sLabel,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          letterSpacing: 1.5,
                          color: _sColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
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
                const SizedBox(height: 16),
                InputFieldWidget(
                  ctrl: confirmCtrl,
                  focus: confirmFocus,
                  focused: confirmFocused,
                  label: 'CONFIRM ACCESS CODE',
                  hint: '••••••••',
                  icon: Icons.lock_person_outlined,
                  obscure: obscureConfirm,
                  error: confirmError,
                  accentColor: AppColors.teal,
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
                const SizedBox(height: 24),
                ActionButton(
                  label: 'RESET ACCESS CODE',
                  icon: Icons.lock_reset_rounded,
                  color: AppColors.teal,
                  isLoading: isLoading,
                  loadingCtrl: loadingCtrl,
                  onTap: onSubmit,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
