import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/widgets/chartsTrends/circle_btn.dart';

typedef C = AppColors;

class AnalyticsHeader extends StatelessWidget {
  final LogProvider lp;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;
  final bool showDistribution;
  final VoidCallback onToggleDistribution;

  const AnalyticsHeader({
    super.key,
    required this.lp,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.showDistribution,
    required this.onToggleDistribution,
  });

  @override
  Widget build(BuildContext context) {
    final totalAlerts = lp.alerts.length;
    final activeAlerts = lp.alerts.where((a) => a.isActive).length;

    return Container(
      height: 52,
      color: C.bgCard.withOpacity(0.92),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: glowCtrl,
            builder: (_, __) => Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: C.cyan.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: C.cyan.withOpacity(0.3 + glowCtrl.value * 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: C.cyan.withOpacity(0.1 + glowCtrl.value * 0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.analytics_rounded,
                color: C.cyan,
                size: 15,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Flexible(
            child: ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [C.cyan, C.violet],
              ).createShader(b),
              child: const Text(
                'CHARTS & TRENDS',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: C.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          const Spacer(),

          if (activeAlerts > 0)
            AnimatedBuilder(
              animation: blinkCtrl,
              builder: (_, __) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: C.red.withOpacity(0.1 + blinkCtrl.value * 0.05),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: C.red.withOpacity(0.4 + blinkCtrl.value * 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: C.red,
                      size: 10,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$activeAlerts ACTIVE',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        color: C.red,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(width: 8),

          CircleBtn(
            icon: showDistribution
                ? Icons.bar_chart_rounded
                : Icons.pie_chart_rounded,
            color: C.violet,
            active: showDistribution,
            onTap: onToggleDistribution,
          ),

          const SizedBox(width: 6),

          Text(
            '$totalAlerts LOGS',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              color: C.mutedLt,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
