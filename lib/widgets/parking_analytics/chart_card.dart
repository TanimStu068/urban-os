import 'package:flutter/material.dart';

import 'dart:math';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/widgets/parking_analytics/card_widget.dart';
import 'package:urban_os/widgets/parking_analytics/mini_tab_btn.dart';
import 'package:urban_os/widgets/parking_analytics/mini_stat.dart';
import 'package:urban_os/widgets/parking_analytics/occupancy_line_Chart.dart';
import 'package:urban_os/widgets/parking_analytics/revenue_bar_chart.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ChartCard extends StatelessWidget {
  final ParkingLot lot;
  final ValueNotifier<int> chartMode;
  final AnimationController chartCtrl;
  final AnimationController glowCtrl;

  const ChartCard({
    Key? key,
    required this.lot,
    required this.chartMode,
    required this.chartCtrl,
    required this.glowCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: chartMode,
      builder: (_, mode, __) {
        return CardWidget(
          title: mode == 0 ? '24H OCCUPANCY TREND' : '7-DAY REVENUE',
          sub: mode == 0
              ? 'Hourly occupancy percentage'
              : 'Daily revenue in BDT',
          icon: mode == 0 ? Icons.show_chart_rounded : Icons.bar_chart_rounded,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MiniTabBtn('OCCUPANCY', 0, mode, C.cyan, () {
                chartMode.value = 0;
                chartCtrl.forward(from: 0);
              }),
              const SizedBox(width: 5),
              MiniTabBtn('REVENUE', 1, mode, C.teal, () {
                chartMode.value = 1;
                chartCtrl.forward(from: 0);
              }),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 140,
                child: AnimatedBuilder(
                  animation: Listenable.merge([chartCtrl, glowCtrl]),
                  builder: (_, __) {
                    if (mode == 0) {
                      return CustomPaint(
                        painter: OccupancyLinePainter(
                          data: lot.occupancy24h,
                          color: lot.status.color,
                          progress: chartCtrl.value,
                          glowT: glowCtrl.value,
                        ),
                        size: Size.infinite,
                      );
                    } else {
                      return CustomPaint(
                        painter: RevenueBarPainter(
                          data: lot.revenue7d,
                          color: C.teal,
                          progress: chartCtrl.value,
                          glowT: glowCtrl.value,
                        ),
                        size: Size.infinite,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              if (mode == 0) ...[
                Row(
                  children: [
                    MiniStat(
                      'PEAK',
                      '${lot.occupancy24h.reduce(max).toStringAsFixed(0)}%',
                      lot.status.color,
                    ),
                    const SizedBox(width: 6),
                    MiniStat(
                      'NIGHT LOW',
                      '${lot.occupancy24h.reduce(min).toStringAsFixed(0)}%',
                      C.green,
                    ),
                    const SizedBox(width: 6),
                    MiniStat(
                      'DAILY AVG',
                      '${(lot.occupancy24h.reduce((a, b) => a + b) / 24).toStringAsFixed(0)}%',
                      C.mutedLt,
                    ),
                    const SizedBox(width: 6),
                    MiniStat(
                      'NOW',
                      '${(lot.occupancy24h.last).toStringAsFixed(0)}%',
                      C.cyan,
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    MiniStat(
                      '7D TOTAL',
                      '৳${lot.revenue7d.reduce((a, b) => a + b).toStringAsFixed(0)}',
                      C.teal,
                    ),
                    const SizedBox(width: 6),
                    MiniStat(
                      'DAILY AVG',
                      '৳${(lot.revenue7d.reduce((a, b) => a + b) / 7).toStringAsFixed(0)}',
                      C.cyan,
                    ),
                    const SizedBox(width: 6),
                    MiniStat(
                      'BEST DAY',
                      '৳${lot.revenue7d.reduce(max).toStringAsFixed(0)}',
                      C.green,
                    ),
                    const SizedBox(width: 6),
                    MiniStat(
                      'RATE/HR',
                      '৳${lot.pricePerHour.toStringAsFixed(2)}',
                      C.amber,
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
