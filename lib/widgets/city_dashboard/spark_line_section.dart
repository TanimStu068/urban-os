import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/city_dashboard/live_chip.dart';
import 'package:urban_os/widgets/city_dashboard/section_header.dart';
import 'package:urban_os/widgets/city_dashboard/spark_line.dart';

typedef C = AppColors;

class SparklineSection extends StatelessWidget {
  final List<double> energyData, trafficData, aqiData;
  final AnimationController liveCtrl;
  const SparklineSection({
    super.key,
    required this.energyData,
    required this.trafficData,
    required this.aqiData,
    required this.liveCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final lastAqi = aqiData.isNotEmpty ? aqiData.last : 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.gBdr),
        color: C.bgCard.withOpacity(.85),
      ),
      child: Column(
        children: [
          SectionHeader(
            title: 'LIVE TRENDS',
            sub: 'Real-time sensor telemetry',
            icon: Icons.show_chart_rounded,
            color: C.cyan,
            trailing: const LiveChip(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Sparkline(
                  label: 'ENERGY LOAD',
                  data: energyData,
                  color: C.amber,
                  unit: '%',
                  liveCtrl: liveCtrl,
                ),
                const SizedBox(height: 14),
                Sparkline(
                  label: 'TRAFFIC FLOW',
                  data: trafficData,
                  color: C.cyan,
                  unit: '%',
                  liveCtrl: liveCtrl,
                ),
                const SizedBox(height: 14),
                Sparkline(
                  label: 'AIR QUALITY INDEX',
                  data: aqiData,
                  color: lastAqi < 100
                      ? C.green
                      : lastAqi < 150
                      ? C.amber
                      : C.red,
                  unit: 'AQI',
                  liveCtrl: liveCtrl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
