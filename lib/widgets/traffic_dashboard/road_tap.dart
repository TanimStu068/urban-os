import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';
import 'package:urban_os/widgets/traffic_dashboard/road_detail_card.dart';

typedef C = AppColors;

class RoadsTab extends StatelessWidget {
  final List<RoadSegment> roads;
  final AnimationController glowCtrl, blinkCtrl, chartDrawCtrl;
  final int selected;
  final ValueChanged<int> onSelect;
  const RoadsTab({
    super.key,
    required this.roads,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.chartDrawCtrl,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext ctx) => Column(
    children: [
      // Road selector
      SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
          children: List.generate(roads.length, (i) {
            final r = roads[i];
            final isSel = i == selected;
            return GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: isSel
                      ? r.color.withOpacity(.18)
                      : C.bgCard.withOpacity(.8),
                  border: Border.all(
                    color: isSel ? r.color.withOpacity(.6) : C.gBdr,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: r.color,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      r.id,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        letterSpacing: 1,
                        color: isSel ? r.color : C.mutedLt,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 40),
          physics: const BouncingScrollPhysics(),
          children: [
            RoadDetailCard(
              road: roads[selected],
              glowCtrl: glowCtrl,
              blinkCtrl: blinkCtrl,
              chartDrawCtrl: chartDrawCtrl,
            ),
          ],
        ),
      ),
    ],
  );
}
