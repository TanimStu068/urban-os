import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class AccountInfo extends StatelessWidget {
  final String userEmail;
  final bool isGoogleUser;

  const AccountInfo({
    super.key,
    required this.userEmail,
    required this.isGoogleUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard.withOpacity(0.85),
        border: Border.all(color: C.cyan.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          // Circle avatar with first letter
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: C.cyan.withOpacity(0.12),
              border: Border.all(color: C.cyan.withOpacity(0.25)),
            ),
            child: Center(
              child: Text(
                userEmail.isNotEmpty ? userEmail[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  color: C.cyan,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // User details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ACCOUNT TO BE DELETED',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6.5,
                    color: C.mutedLt,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userEmail,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    color: C.white,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Account type badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: (isGoogleUser ? C.amber : C.cyan).withOpacity(0.15),
                    border: Border.all(
                      color: (isGoogleUser ? C.amber : C.cyan).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    isGoogleUser ? 'GOOGLE ACCOUNT' : 'EMAIL / PASSWORD',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 5.5,
                      color: isGoogleUser ? C.amber : C.cyan,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
