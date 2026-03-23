import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/event_logs/filter_chip.dart';
import 'package:urban_os/datamodel/event_log_data_model.dart';

typedef C = AppColors;

/// A reusable filter bar widget for events
class EventsFilterBar extends StatelessWidget {
  final String searchQuery;
  final EventType? selectedType;
  final EventSeverity? selectedSeverity;
  final bool showSuccessOnly;

  final ValueChanged<String> onSearchChanged;
  final ValueChanged<EventType?> onTypeSelected;
  final ValueChanged<EventSeverity?> onSeveritySelected;
  final VoidCallback onToggleSuccessOnly;
  final VoidCallback onClearFilters;

  const EventsFilterBar({
    super.key,
    required this.searchQuery,
    required this.selectedType,
    required this.selectedSeverity,
    required this.showSuccessOnly,
    required this.onSearchChanged,
    required this.onTypeSelected,
    required this.onSeveritySelected,
    required this.onToggleSuccessOnly,
    required this.onClearFilters,
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
              decoration: InputDecoration(
                hintText: 'Search events...',
                hintStyle: const TextStyle(
                  color: C.muted,
                  fontFamily: 'monospace',
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: C.teal,
                  size: 14,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: onClearFilters,
                        child: const Icon(
                          Icons.close_rounded,
                          color: C.mutedLt,
                          size: 14,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...EventType.values.map(
                  (type) => FilterChipWidget(
                    label: type.label,
                    isSelected: selectedType == type,
                    color: type.color,
                    onTap: () =>
                        onTypeSelected(selectedType == type ? null : type),
                  ),
                ),
                const SizedBox(width: 6),
                ...EventSeverity.values
                    .skip(2)
                    .map(
                      (sev) => FilterChipWidget(
                        label: sev.label,
                        isSelected: selectedSeverity == sev,
                        color: sev.color,
                        onTap: () => onSeveritySelected(
                          selectedSeverity == sev ? null : sev,
                        ),
                      ),
                    ),
                const SizedBox(width: 6),
                FilterChipWidget(
                  label: 'SUCCESS',
                  isSelected: showSuccessOnly,
                  color: C.green,
                  onTap: onToggleSuccessOnly,
                ),
                if ((selectedType != null ||
                    selectedSeverity != null ||
                    showSuccessOnly ||
                    searchQuery.isNotEmpty)) ...[
                  const SizedBox(width: 6),
                  FilterChipWidget(
                    label: 'CLEAR',
                    isSelected: false,
                    color: C.mutedLt,
                    onTap: onClearFilters,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
