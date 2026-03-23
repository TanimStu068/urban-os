import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/traffic_light_control/circle_btn.dart';

typedef C = AppColors;
typedef EmergencyCallback = void Function(BuildContext context);

class SignalControlHeader extends StatelessWidget {
  final EmergencyCallback onEmergency;
  final VoidCallback? onBack;
  final VoidCallback? onSettings;

  const SignalControlHeader({
    super.key,
    required this.onEmergency,
    this.onBack,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: C.bgCard.withOpacity(0.92),
        border: Border(bottom: BorderSide(color: C.gBdr)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.maybePop(context),
            child: const CircleBtn(Icons.arrow_back_ios_rounded, sz: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [C.cyan, C.teal],
                  ).createShader(bounds),
                  child: const Text(
                    'SIGNAL CONTROL',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Text(
                  'TRAFFIC LIGHT MANAGEMENT · LIVE',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    letterSpacing: 2,
                    color: C.mutedLt,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onEmergency(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: C.red.withOpacity(0.1),
                border: Border.all(color: C.red.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.emergency_rounded, color: C.red, size: 13),
                  SizedBox(width: 5),
                  Text(
                    'EMERG',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      letterSpacing: 1,
                      color: C.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSettings,
            child: const CircleBtn(Icons.settings_rounded, sz: 16),
          ),
        ],
      ),
    );
  }
}
