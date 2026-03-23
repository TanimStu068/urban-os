import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/alert_history_data_model.dart';

typedef C = AppColors;

class AlertsFilterBar extends StatelessWidget {
  final String searchQuery;
  final AlertSeverity? selectedSeverity;
  final AlertType? selectedType;
  final AlertStatus? selectedStatus;
  final void Function(String val) onSearchChanged;
  final void Function(AlertSeverity? sev) onSeveritySelected;
  final void Function(AlertType? type) onTypeSelected;
  final void Function(AlertStatus? status) onStatusSelected;
  final VoidCallback onClearFilters;

  const AlertsFilterBar({
    super.key,
    required this.searchQuery,
    required this.selectedSeverity,
    required this.selectedType,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onSeveritySelected,
    required this.onTypeSelected,
    required this.onStatusSelected,
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
                hintText: 'Search alerts...',
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
                        onTap: () => onSearchChanged(''),
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
                ...AlertSeverity.values.map(
                  (sev) => _FilterChip(
                    label: sev.label,
                    isSelected: selectedSeverity == sev,
                    color: sev.color,
                    onTap: () => onSeveritySelected(
                      selectedSeverity == sev ? null : sev,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                ...AlertType.values.map(
                  (type) => _FilterChip(
                    label: type.label,
                    isSelected: selectedType == type,
                    color: type.color,
                    onTap: () =>
                        onTypeSelected(selectedType == type ? null : type),
                  ),
                ),
                const SizedBox(width: 6),
                _FilterChip(
                  label: 'ACTIVE',
                  isSelected: selectedStatus == AlertStatus.active,
                  color: C.red,
                  onTap: () => onStatusSelected(
                    selectedStatus == AlertStatus.active
                        ? null
                        : AlertStatus.active,
                  ),
                ),
                if (selectedSeverity != null ||
                    selectedType != null ||
                    selectedStatus != null ||
                    searchQuery.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  _FilterChip(
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

// ─────── Private Filter Chip ───────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isSelected ? color.withOpacity(0.2) : C.bgCard2,
          border: Border.all(color: isSelected ? color : C.gBdr),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            fontWeight: FontWeight.w600,
            color: isSelected ? color : C.mutedLt,
          ),
        ),
      ),
    );
  }
}
