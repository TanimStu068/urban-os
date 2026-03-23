import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/card.dart';
import 'package:urban_os/widgets/parking_analytics/prediction_row.dart';

class PredictionsCard extends StatelessWidget {
  final ParkingLot lot;
  final double liveRate;
  final List<Prediction> Function(ParkingLot, double) getPredictions;

  const PredictionsCard({
    Key? key,
    required this.lot,
    required this.liveRate,
    required this.getPredictions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final predictions = getPredictions(lot, liveRate);

    return CardWidget(
      title: 'AI PREDICTIONS',
      sub: 'System forecasts & recommendations',
      icon: Icons.auto_fix_high_rounded,
      child: Column(
        children: predictions
            .map(
              (p) => PredictionRow(
                text: p.summary,
                icon: Icons.warning,
                color: p.level.color,
                tag: p.level.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
