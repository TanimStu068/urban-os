import 'package:flutter/material.dart';
import 'package:urban_os/widgets/forget_password/action_button_widget.dart';
import 'package:urban_os/widgets/forget_password/card_banner_widget.dart';
import 'package:urban_os/widgets/forget_password/card_wrap_widget.dart';
import 'package:urban_os/widgets/forget_password/input_field_widget.dart';
import 'package:urban_os/widgets/forget_password/lock_illustratino_widget.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class EmailCard extends StatelessWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final bool focused, isLoading;
  final String? error;
  final AnimationController loadingCtrl, lockCtrl;
  final VoidCallback onSubmit;

  const EmailCard({
    super.key,
    required this.ctrl,
    required this.focus,
    required this.focused,
    required this.error,
    required this.isLoading,
    required this.loadingCtrl,
    required this.lockCtrl,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return CardWrap(
      accentColor: AppColors.amber,
      child: Column(
        children: [
          CardBanner(
            title: 'IDENTITY VERIFICATION',
            sub: 'Enter your registered email',
            icon: Icons.manage_accounts_rounded,
            color: AppColors.amber,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              children: [
                LockIllustration(anim: lockCtrl),
                const SizedBox(height: 24),
                const Text(
                  'Enter the email address linked to your operator account. We will send a one-time recovery code.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    color: AppColors.mutedLight,
                    letterSpacing: .4,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                InputFieldWidget(
                  ctrl: ctrl,
                  focus: focus,
                  focused: focused,
                  label: 'REGISTERED EMAIL',
                  hint: 'operator@urbanos.city',
                  icon: Icons.alternate_email_rounded,
                  error: error,
                  accentColor: AppColors.amber,
                  kbType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                ActionButton(
                  label: 'SEND RECOVERY CODE',
                  icon: Icons.send_rounded,
                  color: AppColors.amber,
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
