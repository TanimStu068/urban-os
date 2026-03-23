import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/cctv_activity/filter_chip.dart';
import 'package:urban_os/datamodel/cctv_activity_data_model.dart';

typedef C = AppColors;

/// A reusable camera control bar with search, zone filter, and view mode toggle
class CameraControlBar extends StatelessWidget {
  final String searchQuery;
  final String? selectedZone;
  final ViewMode viewMode;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onZoneSelected;
  final ValueChanged<ViewMode> onViewModeChanged;

  const CameraControlBar({
    super.key,
    required this.searchQuery,
    required this.selectedZone,
    required this.viewMode,
    required this.onSearchChanged,
    required this.onZoneSelected,
    required this.onViewModeChanged,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: C.bgCard.withOpacity(0.5),
              border: Border.all(color: C.gBdr),
            ),
            child: TextField(
              onChanged: onSearchChanged,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                color: C.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Search cameras...',
                hintStyle: TextStyle(color: C.muted, fontFamily: 'monospace'),
                prefixIcon: Icon(Icons.search_rounded, color: C.teal, size: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Zone filter + View mode
          Row(
            children: [
              // Zone filter
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChipWidget(
                        label: 'ALL',
                        isSelected: selectedZone == null,
                        color: C.teal,
                        onTap: () => onZoneSelected(null),
                      ),
                      const SizedBox(width: 4),
                      ...<String>[
                        'Residential',
                        'Commercial',
                        'Industrial',
                        'Transport',
                        'Park',
                        'Medical',
                      ].map(
                        (zone) => FilterChipWidget(
                          label: zone.toUpperCase(),
                          isSelected: selectedZone == zone,
                          color: C.cyan,
                          onTap: () => onZoneSelected(zone),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // View mode toggle
              Row(
                children: [
                  GestureDetector(
                    onTap: () => onViewModeChanged(ViewMode.grid),
                    child: Icon(
                      Icons.grid_view_rounded,
                      color: viewMode == ViewMode.grid ? C.teal : C.mutedLt,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onViewModeChanged(ViewMode.list),
                    child: Icon(
                      Icons.list_rounded,
                      color: viewMode == ViewMode.list ? C.teal : C.mutedLt,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
