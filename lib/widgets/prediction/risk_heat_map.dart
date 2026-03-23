import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';
import 'package:urban_os/widgets/prediction/risk_heat_map_painter.dart';
import 'package:urban_os/widgets/prediction/section_header.dart';

typedef C = AppColors;

class RiskHeatMapWidget extends StatelessWidget {
  final List<RiskZone> riskZones;
  final Animation<double> drawAnimation;
  final Animation<double> pulseAnimation;

  const RiskHeatMapWidget({
    super.key,
    required this.riskZones,
    required this.drawAnimation,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: C.gBdr),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader('DISTRICT RISK HEATMAP', C.amber),

            const SizedBox(height: 14),

            AnimatedBuilder(
              animation: Listenable.merge([drawAnimation, pulseAnimation]),
              builder: (_, __) => SizedBox(
                height: 180,
                child: CustomPaint(
                  painter: RiskHeatmapPainter(
                    riskZones,
                    drawAnimation.value,
                    pulseAnimation.value,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Legend
            Row(
              children: [
                const Text(
                  'RISK SCALE:',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.mutedLt,
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  width: 80,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [C.green, C.amber, C.red],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(width: 6),

                const Text(
                  'LOW',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.green,
                  ),
                ),

                const SizedBox(width: 10),

                const Text(
                  'HIGH',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.red,
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
