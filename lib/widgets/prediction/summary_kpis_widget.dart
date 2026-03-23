import 'package:flutter/material.dart';

import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';
import 'package:urban_os/widgets/prediction/pred_kpi.dart';

typedef C = AppColors;

class SummaryKpisWidget extends StatelessWidget {
  final List predictions;
  final List riskZones;
  final Animation<double> glowAnimation;

  const SummaryKpisWidget({
    super.key,
    required this.predictions,
    required this.riskZones,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    // Compute metrics
    final anomalies = predictions.where((p) => p.isAnomaly).length;
    final highConf = predictions
        .where(
          (p) =>
              p.level == ConfidenceLevel.high ||
              p.level == ConfidenceLevel.critical,
        )
        .length;
    final avgConf =
        predictions.fold(0.0, (a, b) => a + b.confidence) / predictions.length;
    final critZones = riskZones.where((z) => z.score > 0.8).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: AnimatedBuilder(
        animation: glowAnimation,
        builder: (_, __) => Row(
          children: [
            PredKpi(
              '$anomalies',
              'ANOMALIES',
              C.red,
              Icons.warning_amber_rounded,
              glowAnimation.value,
            ),
            const SizedBox(width: 8),
            PredKpi(
              '$highConf',
              'HIGH CONF',
              C.amber,
              Icons.verified_rounded,
              glowAnimation.value,
            ),
            const SizedBox(width: 8),
            PredKpi(
              '${(avgConf * 100).toInt()}%',
              'AVG CONF',
              C.cyan,
              Icons.percent_rounded,
              glowAnimation.value,
            ),
            const SizedBox(width: 8),
            PredKpi(
              '$critZones',
              'CRIT ZONES',
              C.violet,
              Icons.location_on_rounded,
              glowAnimation.value,
            ),
          ],
        ),
      ),
    );
  }
}
