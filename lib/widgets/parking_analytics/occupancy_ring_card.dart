import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/parking_analytics/ring_kpi.dart';
import 'package:urban_os/widgets/parking_analytics/donut_painter.dart';

typedef C = AppColors;

class OccupancyRingCard extends StatelessWidget {
  final ParkingLot lot;
  final int liveOcc;
  final double liveRate;
  final AnimationController glowCtrl;
  final AnimationController pulseCtrl;

  const OccupancyRingCard({
    Key? key,
    required this.lot,
    required this.liveOcc,
    required this.liveRate,
    required this.glowCtrl,
    required this.pulseCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: C.bgCard.withOpacity(0.9),
        border: Border.all(color: C.gBdr),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: 110,
              height: 110,
              child: AnimatedBuilder(
                animation: Listenable.merge([glowCtrl, pulseCtrl]),
                builder: (_, __) => CustomPaint(
                  painter: DonutPainter(
                    lot: lot,
                    liveOcc: liveOcc,
                    glowT: glowCtrl.value,
                    pulseT: pulseCtrl.value,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                children: [
                  RingKpiRow(
                    'OCCUPIED',
                    '$liveOcc',
                    '${(liveRate * 100).toStringAsFixed(0)}%',
                    lot.status.color,
                  ),
                  const SizedBox(height: 6),
                  RingKpiRow(
                    'AVAILABLE',
                    '${lot.totalSpaces - liveOcc - lot.reserved}',
                    '',
                    C.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
