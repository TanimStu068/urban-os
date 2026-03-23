import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/signup/card_header.dart';
import 'package:urban_os/widgets/signup/nav_button.dart';
import 'package:urban_os/widgets/signup/step0_identity.dart';
import 'package:urban_os/widgets/signup/step1_role.dart';
import 'package:urban_os/widgets/signup/step2_security.dart';

class SignupCard extends StatelessWidget {
  final PageController pageCtrl;
  final int step;
  // Step 0
  final TextEditingController nameCtrl, emailCtrl, idCtrl;
  final FocusNode nameFocus, emailFocus, idFocus;
  final bool nameFocused, emailFocused, idFocused;
  final String? nameError, emailError, idError;
  // Step 1
  final int selectedRole;
  final ValueChanged<int> onRoleSelect;
  // Step 2
  final TextEditingController passCtrl, confirmCtrl;
  final FocusNode passFocus, confirmFocus;
  final bool passFocused, confirmFocused, obscurePass, obscureConfirm;
  final double passStrength;
  final String? passError, confirmError;
  final bool agreeTerms, agreeData, isLoading;
  final AnimationController loadingCtrl;
  final VoidCallback onTogglePass, onToggleConfirm, onToggleTerms, onToggleData;
  final VoidCallback onNext, onBack, onRegister;

  const SignupCard({
    super.key,
    required this.pageCtrl,
    required this.step,
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
    required this.selectedRole,
    required this.onRoleSelect,
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
    required this.isLoading,
    required this.loadingCtrl,
    required this.onTogglePass,
    required this.onToggleConfirm,
    required this.onToggleTerms,
    required this.onToggleData,
    required this.onNext,
    required this.onBack,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF071520).withOpacity(.88),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBdr),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withOpacity(.07),
                blurRadius: 40,
                spreadRadius: -5,
              ),
              BoxShadow(color: Colors.black.withOpacity(.5), blurRadius: 30),
            ],
          ),
          child: Column(
            children: [
              // Card header
              CardHeader(step: step),

              // Page view
              SizedBox(
                height: _pageHeight(),
                child: PageView(
                  controller: pageCtrl,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Step0Identity(
                      nameCtrl: nameCtrl,
                      nameFocus: nameFocus,
                      nameFocused: nameFocused,
                      nameError: nameError,
                      emailCtrl: emailCtrl,
                      emailFocus: emailFocus,
                      emailFocused: emailFocused,
                      emailError: emailError,
                      idCtrl: idCtrl,
                      idFocus: idFocus,
                      idFocused: idFocused,
                      idError: idError,
                    ),
                    Step1Role(
                      selectedRole: selectedRole,
                      onSelect: onRoleSelect,
                    ),
                    Step2Security(
                      passCtrl: passCtrl,
                      passFocus: passFocus,
                      passFocused: passFocused,
                      passError: passError,
                      confirmCtrl: confirmCtrl,
                      confirmFocus: confirmFocus,
                      confirmFocused: confirmFocused,
                      confirmError: confirmError,
                      obscurePass: obscurePass,
                      obscureConfirm: obscureConfirm,
                      passStrength: passStrength,
                      agreeTerms: agreeTerms,
                      agreeData: agreeData,
                      onTogglePass: onTogglePass,
                      onToggleConfirm: onToggleConfirm,
                      onToggleTerms: onToggleTerms,
                      onToggleData: onToggleData,
                    ),
                  ],
                ),
              ),

              // Navigation buttons
              NavButtons(
                step: step,
                isLoading: isLoading,
                loadingCtrl: loadingCtrl,
                onNext: onNext,
                onBack: onBack,
                onRegister: onRegister,
                agreeTerms: agreeTerms,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _pageHeight() {
    if (step == 0) return 390;
    if (step == 1) return 440;
    return 460;
  }
}
