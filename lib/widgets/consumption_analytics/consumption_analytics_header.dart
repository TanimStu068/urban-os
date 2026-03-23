import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/circle_btn.dart';

typedef C = AppColors;

/// Header widget for the Consumption Analytics page
class ConsumptionAnalyticsHeader extends StatelessWidget {
  final AnimationController glowCtrl;
  final AnimationController pulseCtrl;
  final bool showCostMode;
  final VoidCallback onToggleCostMode;
  final TimeRange range;
  final int anomalyCount;
  final bool exporting;
  final VoidCallback onExport;
  final VoidCallback? onBack;

  const ConsumptionAnalyticsHeader({
    super.key,
    required this.glowCtrl,
    required this.pulseCtrl,
    required this.showCostMode,
    required this.onToggleCostMode,
    required this.range,
    required this.anomalyCount,
    required this.exporting,
    required this.onExport,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.gBdr)),
          boxShadow: [
            BoxShadow(
              color: C.amber.withOpacity(0.03 + glowCtrl.value * 0.02),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: onBack ?? () => Navigator.maybePop(context),
              child: const CircleBtn(Icons.arrow_back_ios_rounded, sz: 14),
            ),
            const SizedBox(width: 12),
            // Analytics icon
            AnimatedBuilder(
              animation: pulseCtrl,
              builder: (_, __) => Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.amber.withOpacity(0.10),
                  border: Border.all(
                    color: C.amber.withOpacity(0.3 + glowCtrl.value * 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: C.amber.withOpacity(0.15 + glowCtrl.value * 0.1),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: C.amber,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONSUMPTION ANALYTICS',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.5,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'ENERGY USAGE INTELLIGENCE · ${range.label} VIEW · $anomalyCount ANOMALIES',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      letterSpacing: 1.8,
                      color: C.mutedLt,
                    ),
                  ),
                ],
              ),
            ),
            // Cost toggle
            GestureDetector(
              onTap: onToggleCostMode,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: showCostMode ? C.green.withOpacity(0.1) : C.bgCard2,
                  border: Border.all(
                    color: showCostMode
                        ? C.green.withOpacity(0.4)
                        : C.muted.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.attach_money_rounded,
                      color: showCostMode ? C.green : C.mutedLt,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'COST',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        color: showCostMode ? C.green : C.mutedLt,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Export button
            GestureDetector(
              onTap: onExport,
              child: AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: C.gBg,
                    border: Border.all(color: C.gBdr),
                  ),
                  child: exporting
                      ? const Padding(
                          padding: EdgeInsets.all(9),
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: C.amber,
                          ),
                        )
                      : const Icon(
                          Icons.download_rounded,
                          color: C.mutedLt,
                          size: 15,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
