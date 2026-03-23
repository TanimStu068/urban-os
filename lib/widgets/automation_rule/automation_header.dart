import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/automation/automation_provider.dart';
import 'package:urban_os/widgets/automation_rule/circle_btn.dart';

class AutomationHeader extends StatelessWidget {
  final int total;
  final int active;
  final int errors;
  final Animation<double> blinkT;
  final VoidCallback? onExecuteAll;
  final VoidCallback? onSettings;

  const AutomationHeader({
    super.key,
    required this.total,
    required this.active,
    required this.errors,
    required this.blinkT,
    this.onExecuteAll,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard.withOpacity(0.92),
        border: Border(bottom: BorderSide(color: AppColors.gBdr)),
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
                  colors: [AppColors.violet, AppColors.cyan],
                ).createShader(bounds),
                child: const Text(
                  'AUTOMATION ENGINE',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.5,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '$total RULES  ·  $active ACTIVE  ·  LIVE',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  letterSpacing: 2,
                  color: AppColors.mutedLt,
                ),
              ),
            ],
          ),
          const Spacer(),
          AnimatedBuilder(
            animation: blinkT,
            builder: (_, __) => errors > 0
                ? Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: AppColors.red.withOpacity(
                        0.1 + blinkT.value * 0.04,
                      ),
                      border: Border.all(
                        color: AppColors.red.withOpacity(
                          0.4 + blinkT.value * 0.15,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.red.withOpacity(
                            0.8 + blinkT.value * 0.2,
                          ),
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$errors ERROR${errors > 1 ? 'S' : ''}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7.5,
                            letterSpacing: 1,
                            color: AppColors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          GestureDetector(
            onTap:
                onExecuteAll ??
                () => context.read<AutomationProvider>().executeAll(),
            child: CircleBtn(Icons.play_arrow_rounded, sz: 16),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onSettings,
            child: CircleBtn(Icons.settings_rounded, sz: 16),
          ),
        ],
      ),
    );
  }
}
