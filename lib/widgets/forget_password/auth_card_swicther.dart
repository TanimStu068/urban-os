import 'package:flutter/material.dart';
import 'package:urban_os/screens/auth/forgot_password_screen.dart';
import 'package:urban_os/widgets/forget_password/done_card_widget.dart';
import 'package:urban_os/widgets/forget_password/email_card_widget.dart';
import 'package:urban_os/widgets/forget_password/otp_card_widget.dart';
import 'package:urban_os/widgets/forget_password/reset_card_widget.dart';

class AuthCardSwitcher extends StatelessWidget {
  final Phase phase;

  final TextEditingController emailCtrl;
  final FocusNode emailFocus;
  final bool emailFocused;
  final String? emailError;

  final List<TextEditingController> otpCtrls;
  final List<FocusNode> otpFocus;
  final String? otpError;

  final TextEditingController passCtrl;
  final FocusNode passFocus;
  final bool passFocused;

  final TextEditingController confirmCtrl;
  final FocusNode confirmFocus;
  final bool confirmFocused;

  final bool obscurePass;
  final bool obscureConfirm;

  final double passStrength;

  final String? passError;
  final String? confirmError;

  final bool isLoading;

  final AnimationController loadingCtrl;
  final AnimationController lockCtrl;
  final AnimationController radarCtrl;
  final AnimationController timerCtrl;
  final AnimationController successCtrl;

  final bool canResend;
  final int countdown;

  final VoidCallback onSubmitEmail;
  final VoidCallback onSubmitOtp;
  final VoidCallback onResendOtp;
  final VoidCallback onSubmitReset;

  final VoidCallback onTogglePass;
  final VoidCallback onToggleConfirm;

  const AuthCardSwitcher({
    super.key,
    required this.phase,
    required this.emailCtrl,
    required this.emailFocus,
    required this.emailFocused,
    required this.emailError,
    required this.otpCtrls,
    required this.otpFocus,
    required this.otpError,
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
    required this.lockCtrl,
    required this.radarCtrl,
    required this.timerCtrl,
    required this.successCtrl,
    required this.canResend,
    required this.countdown,
    required this.onSubmitEmail,
    required this.onSubmitOtp,
    required this.onResendOtp,
    required this.onSubmitReset,
    required this.onTogglePass,
    required this.onToggleConfirm,
  });

  @override
  Widget build(BuildContext context) {
    switch (phase) {
      case Phase.email:
        return EmailCard(
          ctrl: emailCtrl,
          focus: emailFocus,
          focused: emailFocused,
          error: emailError,
          isLoading: isLoading,
          loadingCtrl: loadingCtrl,
          lockCtrl: lockCtrl,
          onSubmit: onSubmitEmail,
        );

      case Phase.otp:
        return OtpCard(
          ctrls: otpCtrls,
          focuses: otpFocus,
          error: otpError,
          email: emailCtrl.text.trim(),
          isLoading: isLoading,
          loadingCtrl: loadingCtrl,
          canResend: canResend,
          countdown: countdown,
          timerCtrl: timerCtrl,
          radarCtrl: radarCtrl,
          onSubmit: onSubmitOtp,
          onResend: onResendOtp,
        );

      case Phase.reset:
        return ResetCard(
          passCtrl: passCtrl,
          passFocus: passFocus,
          passFocused: passFocused,
          confirmCtrl: confirmCtrl,
          confirmFocus: confirmFocus,
          confirmFocused: confirmFocused,
          obscurePass: obscurePass,
          obscureConfirm: obscureConfirm,
          passStrength: passStrength,
          passError: passError,
          confirmError: confirmError,
          isLoading: isLoading,
          loadingCtrl: loadingCtrl,
          onTogglePass: onTogglePass,
          onToggleConfirm: onToggleConfirm,
          onSubmit: onSubmitReset,
        );

      case Phase.done:
        return DoneCard(anim: successCtrl);
    }
  }
}
