import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/profile_screen_data_model.dart';
import 'package:urban_os/widgets/profile/history_detail.dart';

typedef C = AppColors;

class LoginHistoryCard extends StatelessWidget {
  final LoginHistory login;

  const LoginHistoryCard({super.key, required this.login});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: C.bgCard.withOpacity(0.85),
        border: Border.all(
          color: (login.success ? C.green : C.red).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                login.success
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: login.success ? C.green : C.red,
                size: 14,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      login.success
                          ? 'SUCCESSFUL LOGIN'
                          : 'FAILED LOGIN ATTEMPT',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7,
                        color: login.success ? C.green : C.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      login.deviceName,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 6,
                        color: C.mutedLt,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                login.timeAgo,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 6.5,
                  color: C.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: HistoryDetail('IP', login.ipAddress)),
              const SizedBox(width: 8),
              Expanded(child: HistoryDetail('LOCATION', login.location)),
            ],
          ),
          if (!login.success && login.failureReason != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: C.red.withOpacity(0.15),
              ),
              child: Text(
                'Reason: ${login.failureReason}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 6,
                  color: C.red,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
