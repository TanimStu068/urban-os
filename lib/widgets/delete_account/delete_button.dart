import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef _C = AppColors;

class DeleteButton extends StatelessWidget {
  final bool isLoading;
  final bool isGoogleUser;
  final int step;
  final Animation<double> redPulse;
  final VoidCallback onDeleteWithGoogle;
  final VoidCallback onDeleteWithPassword;

  const DeleteButton({
    super.key,
    required this.isLoading,
    required this.isGoogleUser,
    required this.step,
    required this.redPulse,
    required this.onDeleteWithGoogle,
    required this.onDeleteWithPassword,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              if (isGoogleUser) {
                onDeleteWithGoogle();
              } else {
                onDeleteWithPassword();
              }
            },
      child: AnimatedBuilder(
        animation: redPulse,
        builder: (_, __) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isLoading
                ? _C.red.withOpacity(0.1)
                : _C.red.withOpacity(0.18 + redPulse.value * 0.06),
            border: Border.all(
              color: isLoading
                  ? _C.red.withOpacity(0.2)
                  : _C.red.withOpacity(0.45 + redPulse.value * 0.2),
              width: 1.5,
            ),
            boxShadow: isLoading
                ? []
                : [
                    BoxShadow(
                      color: _C.red.withOpacity(0.12 + redPulse.value * 0.08),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: isLoading
              ? Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            _C.red.withOpacity(0.8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        step == 2 ? 'DELETING ACCOUNT...' : 'PROCESSING...',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8.5,
                          color: _C.red.withOpacity(0.8),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.delete_forever_rounded,
                      color: _C.red,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isGoogleUser
                          ? 'REAUTHENTICATE & DELETE'
                          : 'PERMANENTLY DELETE ACCOUNT',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        color: _C.red,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
