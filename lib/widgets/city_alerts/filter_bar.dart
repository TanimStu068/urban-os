import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_alert_data_model.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/widgets/city_alerts/filter_clip.dart';

typedef C = AppColors;

class FilterBar extends StatelessWidget {
  final RulePriority? filterSeverity;
  final bool showAcknowledged;
  final int sortMode;
  final TextEditingController searchCtrl;
  final ValueChanged<RulePriority> onFilterChanged;
  final VoidCallback onToggleAck;
  final ValueChanged<int> onSortChanged;
  final ValueChanged<String> onSearchChanged;

  const FilterBar({
    super.key,
    required this.filterSeverity,
    required this.showAcknowledged,
    required this.sortMode,
    required this.searchCtrl,
    required this.onFilterChanged,
    required this.onToggleAck,
    required this.onSortChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Container(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: C.bgCard.withOpacity(.8),
            border: Border.all(color: C.gBdr),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(Icons.search_rounded, color: C.mutedLt, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: searchCtrl,
                  onChanged: onSearchChanged,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: C.white,
                    letterSpacing: .5,
                  ),
                  cursorColor: C.red,
                  decoration: const InputDecoration(
                    hintText: 'Search alerts, districts, sensors...',
                    hintStyle: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: C.muted,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (searchCtrl.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    searchCtrl.clear();
                    onSearchChanged('');
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.close_rounded,
                      color: C.mutedLt,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Filter chips
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            children: [
              // Severity filters
              ...[
                RulePriority.critical,
                RulePriority.high,
                RulePriority.medium,
                RulePriority.low,
              ].map((s) {
                final uiSev = mapAlertSeverity(s, true);
                return FilterChipWidget(
                  label: uiSev.label,
                  color: uiSev.color,
                  isActive: filterSeverity == s,
                  onTap: () => onFilterChanged(s),
                );
              }),
              const SizedBox(width: 8),
              // Acknowledged toggle
              FilterChipWidget(
                label: showAcknowledged ? 'HIDE ACK' : 'SHOW ACK',
                color: C.mutedLt,
                isActive: !showAcknowledged,
                icon: Icons.done_all_rounded,
                onTap: onToggleAck,
              ),
              const SizedBox(width: 8),
              // Sort
              FilterChipWidget(
                label: sortMode == 0 ? 'BY TIME' : 'BY SEVERITY',
                color: C.violet,
                isActive: sortMode == 1,
                icon: Icons.sort_rounded,
                onTap: () => onSortChanged(sortMode == 0 ? 1 : 0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
