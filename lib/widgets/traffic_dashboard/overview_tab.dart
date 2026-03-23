import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';
import 'package:urban_os/widgets/traffic_dashboard/congestion_bar_painter.dart';
import 'package:urban_os/widgets/traffic_dashboard/peak_legend.dart';
import 'package:urban_os/widgets/traffic_dashboard/road_flow_painter.dart';
import 'package:urban_os/widgets/traffic_dashboard/road_status_row.dart';
import 'package:urban_os/widgets/traffic_dashboard/section_card.dart';
import 'package:urban_os/widgets/traffic_dashboard/speed_row.dart';
import 'package:urban_os/widgets/traffic_dashboard/traffic_line_painter.dart';

class OverviewTab extends StatelessWidget {
  final List<RoadSegment> roads;
  final List<LiveVehicle> vehicles;
  final Map<String, double> liveStats;
  final AnimationController glowCtrl,
      blinkCtrl,
      pulseCtrl,
      flowCtrl,
      chartDrawCtrl;
  final int selectedRoad;
  final ValueChanged<int> onSelectRoad;

  const OverviewTab({
    super.key,
    required this.roads,
    required this.vehicles,
    required this.liveStats,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.pulseCtrl,
    required this.flowCtrl,
    required this.chartDrawCtrl,
    required this.selectedRoad,
    required this.onSelectRoad,
  });

  @override
  Widget build(BuildContext ctx) => ListView(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
    physics: const BouncingScrollPhysics(),
    children: [
      // ── LIVE ROAD FLOW PAINTER ──
      SectionCard(
        title: 'LIVE ROAD NETWORK',
        sub: 'Real-time flow simulation',
        icon: Icons.route_rounded,
        child: SizedBox(
          height: 180,
          child: AnimatedBuilder(
            animation: Listenable.merge([flowCtrl, pulseCtrl, glowCtrl]),
            builder: (_, __) => CustomPaint(
              painter: RoadFlowPainter(
                vehicles: vehicles,
                flowT: flowCtrl.value,
                pulseT: pulseCtrl.value,
                glowT: glowCtrl.value,
              ),
              size: Size.infinite,
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),

      // ── 24H PEAK TRAFFIC CHART ──
      SectionCard(
        title: '24H TRAFFIC VOLUME',
        sub: 'Vehicles per hour — city average',
        icon: Icons.show_chart_rounded,
        child: Column(
          children: [
            SizedBox(
              height: 130,
              child: AnimatedBuilder(
                animation: chartDrawCtrl,
                builder: (_, __) => CustomPaint(
                  painter: TrafficLinePainter(
                    data: peakHourly
                        .map((e) => e.toDouble())
                        .toList(), // convert to double
                    // data: _peakHourly,
                    progress: chartDrawCtrl.value,
                    glowT: glowCtrl.value,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
            const SizedBox(height: 8),
            PeakLegend(),
          ],
        ),
      ),
      const SizedBox(height: 12),

      // ── ROAD STATUS QUICK LIST ──
      SectionCard(
        title: 'ROAD STATUS',
        sub: '${roads.length} monitored segments',
        icon: Icons.list_alt_rounded,
        child: AnimatedBuilder(
          animation: Listenable.merge([glowCtrl, blinkCtrl]),
          builder: (_, __) => Column(
            children: List.generate(
              roads.length,
              (i) => RoadStatusRow(
                road: roads[i],
                isSelected: i == selectedRoad,
                glowT: glowCtrl.value,
                blinkT: blinkCtrl.value,
                onTap: () => onSelectRoad(i),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),

      // ── SPEED ZONES
      SectionCard(
        title: 'SPEED MONITOR',
        sub: 'Current vs limit',
        icon: Icons.speed_rounded,
        child: AnimatedBuilder(
          animation: glowCtrl,
          builder: (_, __) => Column(
            children: speedZoneData.map((d) {
              final (name, cur, limit, col) = d;
              return SpeedRow(
                name: name,
                current: cur,
                limit: limit,
                color: col,
                glowT: glowCtrl.value,
              );
            }).toList(),
          ),
        ),
      ),
      const SizedBox(height: 12),

      // ── CONGESTION DISTRIBUTION ──
      SectionCard(
        title: 'CONGESTION HEATMAP',
        sub: 'Flow distribution by road',
        icon: Icons.bar_chart_rounded,
        child: SizedBox(
          height: 100,
          child: AnimatedBuilder(
            animation: glowCtrl,
            builder: (_, __) => CustomPaint(
              painter: CongestionBarPainter(
                roads: roads,
                glowT: glowCtrl.value,
              ),
              size: Size.infinite,
            ),
          ),
        ),
      ),
    ],
  );
}
