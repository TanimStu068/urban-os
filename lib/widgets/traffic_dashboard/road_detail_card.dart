import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';
import 'package:urban_os/widgets/traffic_dashboard/card_header.dart';
import 'package:urban_os/widgets/traffic_dashboard/mini_stat.dart';
import 'package:urban_os/widgets/traffic_dashboard/tag_chip.dart';
import 'package:urban_os/widgets/traffic_dashboard/recommend_row.dart';
import 'package:urban_os/widgets/traffic_dashboard/congestion_ring.dart';
import 'package:urban_os/widgets/traffic_dashboard/labeled_bar.dart';
import 'package:urban_os/widgets/traffic_dashboard/road_history_painter.dart';
import 'package:urban_os/widgets/traffic_dashboard/road_kpi.dart';

typedef C = AppColors;

// Traffic theme accent
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

class RoadDetailCard extends StatelessWidget {
  final RoadSegment road;
  final AnimationController glowCtrl, blinkCtrl, chartDrawCtrl;
  const RoadDetailCard({
    super.key,
    required this.road,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.chartDrawCtrl,
  });

  @override
  Widget build(BuildContext ctx) => AnimatedBuilder(
    animation: Listenable.merge([glowCtrl, blinkCtrl]),
    builder: (_, __) => Column(
      children: [
        // Header card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: C.bgCard.withOpacity(.9),
            border: Border.all(
              color: road.color.withOpacity(.25 + glowCtrl.value * .1),
            ),
            boxShadow: [
              BoxShadow(color: road.color.withOpacity(.08), blurRadius: 20),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: road.color.withOpacity(.12),
                      border: Border.all(color: road.color.withOpacity(.4)),
                    ),
                    child: Icon(
                      Icons.route_rounded,
                      color: road.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          road.name,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: C.white,
                            letterSpacing: .4,
                          ),
                        ),
                        Row(
                          children: [
                            TagChip(road.type, road.color),
                            const SizedBox(width: 8),
                            Text(
                              road.id,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 8,
                                color: C.muted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CongestionRing(
                    pct: road.congestion,
                    color: road.color,
                    glowT: glowCtrl.value,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // KPI row
              Row(
                children: [
                  RoadKpi('SPEED', '${road.speed}', 'km/h', road.color),
                  RoadKpi('VEHICLES', '${road.vehicles}', '/h', kAccent),
                  RoadKpi(
                    'INCIDENTS',
                    '${road.incidents}',
                    '',
                    road.incidents > 0 ? C.red : C.green,
                  ),
                  RoadKpi(
                    'CONGESTION',
                    '${road.congestion}',
                    '%',
                    _congColor(road.congestion),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Congestion bar
              LabeledBar(
                'TRAFFIC FLOW',
                road.congestion / 100,
                _congColor(road.congestion),
              ),
              const SizedBox(height: 8),
              LabeledBar('SPEED RATIO', road.speed / 80, road.color),
              const SizedBox(height: 8),
              LabeledBar(
                'INCIDENT RISK',
                road.incidents > 0 ? .72 : .18,
                road.incidents > 0 ? C.red : C.green,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 24h history chart
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: C.bgCard.withOpacity(.9),
            border: Border.all(color: C.gBdr),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardHeader(
                '24H CONGESTION TREND',
                '${road.name}',
                Icons.show_chart_rounded,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: AnimatedBuilder(
                  animation: chartDrawCtrl,
                  builder: (_, __) => CustomPaint(
                    painter: RoadHistoryPainter(
                      data: road.history24h,
                      color: road.color,
                      progress: chartDrawCtrl.value,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  MiniStat(
                    'PEAK',
                    '${road.history24h.reduce((a, b) => a > b ? a : b).toStringAsFixed(0)}%',
                    C.red,
                  ),
                  MiniStat(
                    'LOW',
                    '${road.history24h.reduce((a, b) => a < b ? a : b).toStringAsFixed(0)}%',
                    C.green,
                  ),
                  MiniStat(
                    'AVG',
                    '${(road.history24h.reduce((a, b) => a + b) / road.history24h.length).toStringAsFixed(0)}%',
                    C.amber,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Recommendations
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: C.bgCard.withOpacity(.9),
            border: Border.all(color: C.gBdr),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardHeader(
                'AI RECOMMENDATIONS',
                'System suggestions',
                Icons.auto_fix_high_rounded,
              ),
              const SizedBox(height: 10),
              ..._roadRecommendations(
                road,
              ).map((r) => RecommendRow(text: r.$1, icon: r.$2, color: r.$3)),
            ],
          ),
        ),
      ],
    ),
  );

  List<(String, IconData, Color)> _roadRecommendations(RoadSegment r) {
    if (r.congestion > 85)
      return [
        (
          'Extend green signal duration at entry intersections',
          Icons.traffic_rounded,
          kAccent,
        ),
        (
          'Activate dynamic speed limit boards — reduce to 40km/h',
          Icons.speed_rounded,
          C.amber,
        ),
        (
          'Recommend alternate route via South Bypass',
          Icons.alt_route_rounded,
          C.teal,
        ),
        (
          'Deploy traffic management personnel at chokepoint',
          Icons.person_rounded,
          C.violet,
        ),
      ];
    if (r.congestion > 60)
      return [
        (
          'Monitor closely — approaching high congestion threshold',
          Icons.visibility_rounded,
          C.amber,
        ),
        (
          'Pre-emptive signal timing adjustment suggested',
          Icons.traffic_rounded,
          kAccent,
        ),
      ];
    return [
      (
        'Traffic flow within normal parameters',
        Icons.check_circle_outline_rounded,
        C.green,
      ),
      ('Continue standard monitoring cycle', Icons.sensors_rounded, kAccent),
    ];
  }

  Color _congColor(int c) => c >= 85
      ? C.red
      : c >= 60
      ? C.amber
      : C.green;
}
