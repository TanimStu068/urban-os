import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/accident_monitoring/circle_btn.dart';

typedef C = AppColors;

class AccidentMonitorHeader extends StatelessWidget {
  const AccidentMonitorHeader({Key? key}) : super(key: key);

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
            onTap: () => Navigator.maybePop(context),
            child: CircleBtn(Icons.arrow_back_ios_rounded, sz: 14),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [C.red, C.orange],
                ).createShader(bounds),
                child: const Text(
                  'ACCIDENT MONITOR',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.5,
                    color: Colors.white, // Required but overridden by shader
                  ),
                ),
              ),
              const Text(
                'REAL-TIME INCIDENT MANAGEMENT  ·  LIVE',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  letterSpacing: 2,
                  color: C.mutedLt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
