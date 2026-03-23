import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';
import 'package:urban_os/widgets/rule_simulation/circle_btn.dart';
import 'package:urban_os/widgets/rule_simulation/phase_chip.dart';

typedef C = AppColors;

class RuleSimHeader extends StatelessWidget {
  final SimPhase phase;
  final Animation<double> blinkAnimation;
  final VoidCallback? onBack;

  const RuleSimHeader({
    super.key,
    required this.phase,
    required this.blinkAnimation,
    this.onBack,
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
            child: CircleBtn(Icons.arrow_back_ios_rounded, sz: 14),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [C.cyan, C.violet],
                  ).createShader(b),
                  child: const Text(
                    'RULE SIMULATION',
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
                  'SANDBOX ENGINE  ·  VIRTUAL TESTBED  ·  REAL-TIME',
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
          const Spacer(),
          AnimatedBuilder(
            animation: blinkAnimation,
            builder: (_, __) => PhaseChip(phase, blinkAnimation.value),
          ),
        ],
      ),
    );
  }
}
