import 'package:flutter/material.dart';
import 'package:urban_os/widgets/forget_password/action_button_widget.dart';
import 'package:urban_os/widgets/forget_password/card_banner_widget.dart';
import 'package:urban_os/widgets/forget_password/card_wrap_widget.dart';
import 'package:urban_os/widgets/forget_password/otp_row_widget.dart';
import 'package:urban_os/widgets/forget_password/resend_row_widget.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/forget_password/signal_illustration_widget.dart';

class OtpCard extends StatelessWidget {
  final List<TextEditingController> ctrls;
  final List<FocusNode> focuses;
  final String? error;
  final String email;
  final bool isLoading, canResend;
  final int countdown;
  final AnimationController loadingCtrl, timerCtrl, radarCtrl;
  final VoidCallback onSubmit, onResend;

  const OtpCard({
    super.key,
    required this.ctrls,
    required this.focuses,
    required this.error,
    required this.email,
    required this.isLoading,
    required this.loadingCtrl,
    required this.canResend,
    required this.countdown,
    required this.timerCtrl,
    required this.radarCtrl,
    required this.onSubmit,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return CardWrap(
      accentColor: AppColors.cyan,
      child: Column(
        children: [
          CardBanner(
            title: 'OTP VERIFICATION',
            sub: 'Enter the 6-character reset code',
            icon: Icons.pin_rounded,
            color: AppColors.cyan,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              children: [
                SignalIllustration(anim: radarCtrl),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      color: AppColors.muted,
                      letterSpacing: .4,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'A password reset email has been sent to\n',
                      ),
                      TextSpan(
                        text: email,
                        style: const TextStyle(
                          color: AppColors.cyan,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text:
                            '\n\nOpen the email, copy the reset code\nfrom the link and enter it below.',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                OtpRow(ctrls: ctrls, focuses: focuses),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.error,
                          size: 11,
                        ),
                        const SizedBox(width: 5),
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
                const SizedBox(height: 24),
                ResendRow(
                  canResend: canResend,
                  countdown: countdown,
                  onResend: onResend,
                  timerCtrl: timerCtrl,
                ),
                const SizedBox(height: 20),
                ActionButton(
                  label: 'VERIFY CODE',
                  icon: Icons.verified_rounded,
                  color: AppColors.cyan,
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
