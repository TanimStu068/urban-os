import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';
import 'package:urban_os/widgets/parking_analytics/event_card.dart';
import 'package:urban_os/widgets/parking_analytics/lot_hero_card.dart';
import 'package:urban_os/widgets/parking_analytics/chart_card.dart';
import 'package:urban_os/widgets/parking_analytics/floor_card.dart';
import 'package:urban_os/widgets/parking_analytics/occupancy_ring_card.dart';
import 'package:urban_os/widgets/parking_analytics/prediction_card.dart';
import 'package:urban_os/widgets/parking_analytics/slot_grid_card.dart';
import 'package:urban_os/widgets/parking_analytics/info_card.dart';

class LotDetailPanel extends StatelessWidget {
  final ParkingLot lot;
  final int liveOccupied;
  final double liveRate;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;
  final AnimationController pulseCtrl;
  final ValueNotifier<int> chartMode;
  final AnimationController chartCtrl;
  final AnimationController slotCtrl;
  final List<Prediction> Function(ParkingLot, double) getPredictions;

  const LotDetailPanel({
    Key? key,
    required this.lot,
    required this.liveOccupied,
    required this.liveRate,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.pulseCtrl,
    required this.chartMode,
    required this.chartCtrl,
    required this.slotCtrl,
    required this.getPredictions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowCtrl, blinkCtrl, pulseCtrl]),
      builder: (_, __) => Column(
        children: [
          // ① Lot Hero Card
          LotHeroCard(
            lot: lot,
            liveOcc: liveOccupied,
            liveRate: liveRate,
            glowCtrl: glowCtrl,
            blinkCtrl: blinkCtrl,
          ),
          const SizedBox(height: 10),

          // ② Occupancy Donut + KPI row
          OccupancyRingCard(
            lot: lot,
            liveOcc: liveOccupied,
            liveRate: liveRate,
            glowCtrl: glowCtrl,
            pulseCtrl: pulseCtrl,
          ),
          const SizedBox(height: 10),

          // ③ Chart (occupancy 24h / revenue 7d toggle)
          ChartCard(
            lot: lot,
            chartMode: chartMode,
            chartCtrl: chartCtrl,
            glowCtrl: glowCtrl,
          ),
          const SizedBox(height: 10),

          // ④ Floor breakdown
          FloorCard(lot: lot, glowCtrl: glowCtrl),
          const SizedBox(height: 10),

          // ⑤ Slot grid visualization
          SlotGridCard(
            lot: lot,
            liveOcc: liveOccupied,
            slotCtrl: slotCtrl,
            glowCtrl: glowCtrl,
            pulseCtrl: pulseCtrl,
            blinkCtrl: blinkCtrl,
          ),
          const SizedBox(height: 10),

          // ⑥ Recent events log
          EventsCard(lot: lot, glowCtrl: glowCtrl),
          const SizedBox(height: 10),

          // ⑦ Capabilities & info
          InfoCard(lot: lot),
          const SizedBox(height: 10),

          // ⑧ Predictions
          PredictionsCard(
            lot: lot,
            liveRate: liveRate,
            getPredictions: getPredictions, // your prediction function
          ),
        ],
      ),
    );
  }
}
