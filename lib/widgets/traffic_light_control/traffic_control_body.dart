import 'package:flutter/material.dart';

import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/intersection_list_tile.dart';

class TrafficControlBody extends StatelessWidget {
  final List<Intersection> intersections;
  final List<Intersection> filteredIntersections;
  final int selectedIdx;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;
  final AnimationController pulseCtrl;
  final void Function(int) onSelectedIdxChanged;
  final Widget Function(Intersection) buildDetailPanel;

  const TrafficControlBody({
    super.key,
    required this.intersections,
    required this.filteredIntersections,
    required this.selectedIdx,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.pulseCtrl,
    required this.onSelectedIdxChanged,
    required this.buildDetailPanel,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIntersection =
        (selectedIdx >= 0 && selectedIdx < intersections.length)
        ? intersections[selectedIdx]
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── LEFT: Intersection list (fixed width) ──
        SizedBox(
          width: 180,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(10, 10, 6, 40),
            physics: const BouncingScrollPhysics(),
            children: filteredIntersections.map((ix) {
              final globalIdx = intersections.indexOf(ix);
              return IntersectionListTile(
                intersection: ix,
                isSelected: globalIdx == selectedIdx,
                glowCtrl: glowCtrl,
                blinkCtrl: blinkCtrl,
                pulseCtrl: pulseCtrl,
                onTap: () => onSelectedIdxChanged(globalIdx),
              );
            }).toList(),
          ),
        ),

        // ── RIGHT: Compact scrollable detail ──
        Expanded(
          child: selectedIntersection != null
              ? buildDetailPanel(selectedIntersection)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
