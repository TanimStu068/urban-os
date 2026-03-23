import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/district_map_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/district/district_type.dart';
import 'package:urban_os/screens/districts/district_analytics_screen.dart';
import 'package:urban_os/screens/districts/district_detail_screen.dart';
import 'package:urban_os/widgets/district_map/mini_dial.dart';
import 'package:urban_os/widgets/district_map/panel_action.dart';
import 'package:urban_os/widgets/district_map/panel_pill.dart';
import 'package:urban_os/widgets/district_map/stat_chip.dart';

typedef C = AppColors;

class DistrictBottomPanel extends StatelessWidget {
  final DistrictModel district;
  final Animation<double> glowAnimation;
  final Animation<double> pulseAnimation;
  final MapMode mode;
  final VoidCallback onClose;

  const DistrictBottomPanel({
    super.key,
    required this.district,
    required this.glowAnimation,
    required this.pulseAnimation,
    required this.mode,
    required this.onClose,
  });

  Color get col => tileColor(mode, district);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.96),
          border: Border(
            top: BorderSide(
              color: col.withOpacity(0.3 + glowAnimation.value * 0.1),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: col.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag indicator
            Center(
              child: Container(
                width: 32,
                height: 3,
                decoration: BoxDecoration(
                  color: C.gBdr,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Top row with health, stats, and close button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Health dial
                SizedBox(
                  width: 52,
                  height: 52,
                  child: AnimatedBuilder(
                    animation: pulseAnimation,
                    builder: (_, __) => CustomPaint(
                      painter: MiniDial(
                        district.healthPercentage / 100,
                        col,
                        pulseAnimation.value,
                      ),
                      child: Center(
                        child: Text(
                          '${district.healthPercentage.toInt()}',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 11,
                            color: col,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name and stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              district.name,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: C.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          PanelPill(district.type.displayName, col),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        district.id,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: C.mutedLt,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          StatChip(
                            'TRAFFIC',
                            '${district.metrics.averageTraffic.toInt()}%',
                            C.amber,
                          ),
                          const SizedBox(width: 6),
                          StatChip(
                            'SAFETY',
                            '${district.metrics.safetyScore.toInt()}',
                            C.green,
                          ),
                          const SizedBox(width: 6),
                          StatChip(
                            'AQI',
                            '${district.metrics.airQualityIndex.toInt()}',
                            district.metrics.airQualityIndex > 150
                                ? C.red
                                : C.cyan,
                          ),
                          if (district.metrics.activeIncidents > 0) ...[
                            const SizedBox(width: 6),
                            StatChip(
                              'INC',
                              '${district.metrics.activeIncidents}',
                              C.red,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Close button
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: C.bgCard2,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: C.gBdr),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: C.mutedLt,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: PanelAction(
                    'DETAILS',
                    Icons.info_outline_rounded,
                    C.cyan,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DistrictDetailsScreen(district: district),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PanelAction(
                    'ANALYSIS',
                    Icons.bar_chart_rounded,
                    C.violet,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DistrictAnalysisScreen(district: district),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
