import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/card_widget.dart';
import 'chart_painter.dart';
import 'mini_stat.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class ChartsCard extends StatefulWidget {
  final RoadDetailData road;
  final AnimationController chartCtrl;
  final AnimationController glowCtrl;

  const ChartsCard({
    Key? key,
    required this.road,
    required this.chartCtrl,
    required this.glowCtrl,
  }) : super(key: key);

  @override
  State<ChartsCard> createState() => _ChartsCardState();
}

class _ChartsCardState extends State<ChartsCard> {
  int _chartTab = 0;

  @override
  Widget build(BuildContext context) {
    final labels = ['CONG.', 'VOL.', 'SPEED'];
    final colors = [widget.road.color, kAccent, C.amber];

    return CardWidget(
      title: '24H ANALYTICS',
      sub: 'Congestion · Volume · Speed trends',
      icon: Icons.show_chart_rounded,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final isSel = i == _chartTab;
          return GestureDetector(
            onTap: () {
              setState(() => _chartTab = i);
              widget.chartCtrl.forward(from: 0);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(left: 5),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: isSel ? colors[i].withOpacity(0.15) : Colors.transparent,
                border: Border.all(
                  color: isSel ? colors[i].withOpacity(0.5) : C.gBdr,
                ),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: isSel ? colors[i] : C.muted,
                ),
              ),
            ),
          );
        }),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: AnimatedBuilder(
              animation: Listenable.merge([widget.chartCtrl, widget.glowCtrl]),
              builder: (_, __) {
                final datasets = [
                  widget.road.congestion24h,
                  widget.road.volume24h,
                  widget.road.speed24h,
                ];
                final chartColors = [widget.road.color, kAccent, C.amber];
                final labelsFull = [
                  'CONGESTION (%)',
                  'VOLUME (veh/h)',
                  'SPEED (km/h)',
                ];
                final maxVals = [100.0, 1400.0, 80.0];

                return CustomPaint(
                  painter: ChartPainter(
                    data: datasets[_chartTab],
                    color: chartColors[_chartTab],
                    maxVal: maxVals[_chartTab],
                    label: labelsFull[_chartTab],
                    progress: widget.chartCtrl.value,
                    glowT: widget.glowCtrl.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: widget.glowCtrl,
            builder: (_, __) {
              final datasets = [
                widget.road.congestion24h,
                widget.road.volume24h,
                widget.road.speed24h,
              ];
              final chartColors = [widget.road.color, kAccent, C.amber];
              final d = datasets[_chartTab];
              final peak = d.reduce(max);
              final low = d.reduce(min);
              final avg = d.reduce((a, b) => a + b) / d.length;

              final nowValues = [
                widget.road.congestion,
                widget.road.vehicles,
                widget.road.speed,
              ];

              return Row(
                children: [
                  MiniStat(
                    'PEAK',
                    peak.toStringAsFixed(0),
                    chartColors[_chartTab],
                  ),
                  const SizedBox(width: 6),
                  MiniStat('LOW', low.toStringAsFixed(0), C.green),
                  const SizedBox(width: 6),
                  MiniStat('AVERAGE', avg.toStringAsFixed(0), C.mutedLt),
                  const SizedBox(width: 6),
                  MiniStat(
                    'NOW',
                    nowValues[_chartTab].toStringAsFixed(0),
                    chartColors[_chartTab],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
