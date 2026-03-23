import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/card_widget.dart';
import 'lane_row.dart';
import 'lane_vis_painter.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class LaneAnalysisCard extends StatelessWidget {
  final RoadDetailData road;
  final AnimationController laneCtrl;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;

  const LaneAnalysisCard({
    Key? key,
    required this.road,
    required this.laneCtrl,
    required this.glowCtrl,
    required this.blinkCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'LANE ANALYSIS',
      sub: '${road.lanes} active lanes  ·  Bidirectional flow',
      icon: Icons.view_column_rounded,
      child: AnimatedBuilder(
        animation: Listenable.merge([laneCtrl, glowCtrl, blinkCtrl]),
        builder: (_, __) => Column(
          children: [
            SizedBox(
              height: 100,
              child: CustomPaint(
                painter: LaneVisPainter(
                  lanes: road.laneInfo,
                  progress: laneCtrl.value,
                  glowT: glowCtrl.value,
                ),
                size: Size.infinite,
              ),
            ),
            const SizedBox(height: 12),
            ...road.laneInfo.map(
              (l) => LaneRow(lane: l, glowT: glowCtrl.value),
            ),
          ],
        ),
      ),
    );
  }
}
