import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';
import 'package:urban_os/widgets/parking_analytics/lot_list_tile.dart';
import 'package:urban_os/widgets/parking_analytics/lot_detail_panel.dart';

class ParkingBody extends StatelessWidget {
  final List<ParkingLot> filteredLots;
  final int selectedLotIdx;
  final List<int> liveOccupied;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;
  final AnimationController chartCtrl;
  final AnimationController slotCtrl;
  final AnimationController pulseCtrl;
  final ValueNotifier<int> chartMode;
  final List<Prediction> Function(ParkingLot, double) getPredictions;
  final ValueChanged<int> onLotSelected;

  const ParkingBody({
    super.key,
    required this.filteredLots,
    required this.selectedLotIdx,
    required this.liveOccupied,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.chartCtrl,
    required this.slotCtrl,
    required this.pulseCtrl,
    required this.chartMode,
    required this.getPredictions,
    required this.onLotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: lot list
        SizedBox(
          width: 190,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 10, 6, 40),
            physics: const BouncingScrollPhysics(),
            children: [
              ...filteredLots.asMap().entries.map((entry) {
                final idx = entry.key;
                final lot = entry.value;
                final liveOcc = liveOccupied[idx];
                return LotListTile(
                  lot: lot,
                  liveOccupied: liveOcc,
                  isSelected: idx == selectedLotIdx,
                  glowT: glowCtrl.value,
                  blinkT: blinkCtrl.value,
                  onTap: () => onLotSelected(idx),
                );
              }),
            ],
          ),
        ),

        // Right: detail panel
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(6, 10, 14, 40),
            physics: const BouncingScrollPhysics(),
            children: [
              LotDetailPanel(
                lot: filteredLots[selectedLotIdx],
                liveOccupied: liveOccupied[selectedLotIdx],
                liveRate:
                    liveOccupied[selectedLotIdx] /
                    filteredLots[selectedLotIdx].totalSpaces,
                glowCtrl: glowCtrl,
                blinkCtrl: blinkCtrl,
                pulseCtrl: pulseCtrl,
                chartMode: chartMode,
                chartCtrl: chartCtrl,
                slotCtrl: slotCtrl,
                getPredictions:
                    getPredictions, // make sure this function is defined
              ),
            ],
          ),
        ),
      ],
    );
  }
}
