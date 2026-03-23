import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class ResendRow extends StatelessWidget {
  final bool canResend;
  final int countdown;
  final VoidCallback onResend;
  final AnimationController timerCtrl;
  const ResendRow({
    super.key,
    required this.canResend,
    required this.countdown,
    required this.onResend,
    required this.timerCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "DIDN'T RECEIVE CODE? ",
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            color: AppColors.muted,
            letterSpacing: .5,
          ),
        ),
        if (canResend)
          GestureDetector(
            onTap: onResend,
            child: const Text(
              'RESEND',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                letterSpacing: 1.5,
                color: AppColors.cyan,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.cyan,
              ),
            ),
          )
        else
          AnimatedBuilder(
            animation: timerCtrl,
            builder: (_, __) => Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.muted, width: .8),
                  ),
                  child: ClipOval(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 8 * timerCtrl.value,
                        color: AppColors.cyan.withOpacity(.4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '${countdown}s',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    letterSpacing: 1,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
