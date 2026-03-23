import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/fire_monitoring/filter_chip.dart';

typedef C = AppColors;
typedef FilterChangedCallback = void Function(String value);
typedef ToggleChangedCallback = void Function(bool value);

class ZoneControlBar extends StatelessWidget {
  final String viewFilter;
  final bool showHeatmap;
  final bool showEquipment;

  final FilterChangedCallback onViewFilterChanged;
  final ToggleChangedCallback onShowHeatmapChanged;
  final ToggleChangedCallback onShowEquipmentChanged;

  const ZoneControlBar({
    Key? key,
    required this.viewFilter,
    required this.showHeatmap,
    required this.showEquipment,
    required this.onViewFilterChanged,
    required this.onShowHeatmapChanged,
    required this.onShowEquipmentChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard2.withOpacity(0.7),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: [
          // View filter
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChipWidget(
                    label: 'CRITICAL',
                    isSelected: viewFilter == 'CRITICAL',
                    color: C.red,
                    onTap: () => onViewFilterChanged('CRITICAL'),
                  ),
                  const SizedBox(width: 6),
                  FilterChipWidget(
                    label: 'ACTIVE',
                    isSelected: viewFilter == 'ACTIVE',
                    color: C.orange,
                    onTap: () => onViewFilterChanged('ACTIVE'),
                  ),
                  const SizedBox(width: 6),
                  FilterChipWidget(
                    label: 'ALL',
                    isSelected: viewFilter == 'ALL',
                    color: C.cyan,
                    onTap: () => onViewFilterChanged('ALL'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Toggle buttons
          GestureDetector(
            onTap: () => onShowHeatmapChanged(!showHeatmap),
            child: Icon(
              Icons.thermostat_rounded,
              color: showHeatmap ? C.orange : C.mutedLt,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => onShowEquipmentChanged(!showEquipment),
            child: Icon(
              Icons.build_circle_rounded,
              color: showEquipment ? C.cyan : C.mutedLt,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
