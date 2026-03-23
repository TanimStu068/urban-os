import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/screens/auth/forgot_password_screen.dart';
import 'package:urban_os/widgets/login/biometric_button.dart';
import 'package:urban_os/widgets/login/card_top_bar.dart';
import 'package:urban_os/widgets/login/cyber_input_field.dart';
import 'package:urban_os/widgets/login/login_button.dart';
import 'package:urban_os/widgets/login/or_driver.dart';
import 'package:urban_os/widgets/login/remember_toggle.dart';
import 'package:urban_os/widgets/login/welcome_text_widget.dart';

class LoginCard extends StatelessWidget {
  final TextEditingController emailCtrl, passCtrl;
  final GlobalKey<FormState> formKey;
  final FocusNode emailFocus, passFocus;
  final bool emailFocused, passFocused, obscurePass, rememberMe, isLoading;
  final String? emailError, passError;
  final AnimationController loadingCtrl;
  final Animation<double> field1Fade, field2Fade, btnFade;
  final Animation<Offset> field1Slide, field2Slide, btnSlide;
  final VoidCallback onTogglePass, onToggleRemember, onLogin;

  const LoginCard({
    super.key,
    required this.emailCtrl,
    required this.passCtrl,
    required this.formKey,
    required this.emailFocus,
    required this.passFocus,
    required this.emailFocused,
    required this.passFocused,
    required this.obscurePass,
    required this.rememberMe,
    required this.isLoading,
    required this.emailError,
    required this.passError,
    required this.loadingCtrl,
    required this.field1Fade,
    required this.field1Slide,
    required this.field2Fade,
    required this.field2Slide,
    required this.btnFade,
    required this.btnSlide,
    required this.onTogglePass,
    required this.onToggleRemember,
    required this.onLogin,
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
            color: const Color(0xFF071520).withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withOpacity(0.08),
                blurRadius: 40,
                spreadRadius: -5,
              ),
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 30),
            ],
          ),
          child: Column(
            children: [
              // Card top bar
              CardTopBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 4, 28, 28),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // Welcome text
                      const WelcomeText(),
                      const SizedBox(height: 28),

                      // Email field
                      FadeTransition(
                        opacity: field1Fade,
                        child: SlideTransition(
                          position: field1Slide,
                          child: CyberInputField(
                            controller: emailCtrl,
                            focusNode: emailFocus,
                            isFocused: emailFocused,
                            label: 'OPERATOR EMAIL',
                            hint: 'operator@urbanos.city',
                            icon: Icons.alternate_email_rounded,
                            error: emailError,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Password field
                      FadeTransition(
                        opacity: field2Fade,
                        child: SlideTransition(
                          position: field2Slide,
                          child: CyberInputField(
                            controller: passCtrl,
                            focusNode: passFocus,
                            isFocused: passFocused,
                            label: 'ACCESS CODE',
                            hint: '••••••••',
                            icon: Icons.lock_outline_rounded,
                            obscureText: obscurePass,
                            error: passError,
                            suffixIcon: GestureDetector(
                              onTap: onTogglePass,
                              child: Icon(
                                obscurePass
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.mutedLight,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Remember me + Forgot
                      FadeTransition(
                        opacity: field2Fade,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RememberToggle(
                              value: rememberMe,
                              onTap: onToggleRemember,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'FORGOT CODE?',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 9,
                                  letterSpacing: 1.5,
                                  color: AppColors.cyanDim,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Login button
                      FadeTransition(
                        opacity: btnFade,
                        child: SlideTransition(
                          position: btnSlide,
                          child: LoginButton(
                            isLoading: isLoading,
                            loadingCtrl: loadingCtrl,
                            onTap: onLogin,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Divider
                      FadeTransition(opacity: btnFade, child: OrDivider()),

                      const SizedBox(height: 20),

                      // Biometric button
                      FadeTransition(
                        opacity: btnFade,
                        child: BiometricButton(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
