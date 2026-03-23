import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/city_health/card.dart';
import 'package:urban_os/widgets/city_health/card_header_simple.dart';
import 'package:urban_os/widgets/city_health/live_badge.dart';
import 'package:urban_os/widgets/city_health/spark_row.dart';

typedef C = AppColors;

class MultiSparklines extends StatelessWidget {
  final List<double> energyHist, trafficHist, aqiHist, waterHist, infraHist;
  final AnimationController liveCtrl, glowCtrl;
  const MultiSparklines({
    super.key,
    required this.energyHist,
    required this.trafficHist,
    required this.aqiHist,
    required this.waterHist,
    required this.infraHist,
    required this.liveCtrl,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final lastAqi = aqiHist.isNotEmpty ? aqiHist.last : 0;
    return CardWidget(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: CardHeaderSimple(
                  title: 'LIVE TELEMETRY',
                  icon: Icons.show_chart_rounded,
                  color: C.teal,
                ),
              ),
              LiveBadge(),
            ],
          ),
          const SizedBox(height: 4),
          SparkRow(
            label: 'POWER LOAD',
            data: energyHist,
            color: C.amber,
            unit: 'kW',
            ctrl: liveCtrl,
          ),
          const SizedBox(height: 12),
          SparkRow(
            label: 'TRAFFIC',
            data: trafficHist,
            color: C.cyan,
            unit: '%',
            ctrl: liveCtrl,
          ),
          const SizedBox(height: 12),
          SparkRow(
            label: 'AIR QUALITY',
            data: aqiHist,
            color: lastAqi < 100
                ? C.teal
                : lastAqi < 150
                ? C.amber
                : C.red,
            unit: 'AQI',
            ctrl: liveCtrl,
          ),
          const SizedBox(height: 12),
          SparkRow(
            label: 'WATER FLOW',
            data: waterHist,
            color: C.violet,
            unit: 'L/s',
            ctrl: liveCtrl,
          ),
          const SizedBox(height: 12),
          SparkRow(
            label: 'INFRA HEALTH',
            data: infraHist,
            color: C.teal,
            unit: '%',
            ctrl: liveCtrl,
          ),
        ],
      ),
    );
  }
}
