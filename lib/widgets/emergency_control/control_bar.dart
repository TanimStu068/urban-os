import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/emergency_control_data_model.dart';
import 'package:urban_os/widgets/emergency_control/filter_chip.dart';

typedef C = AppColors;
typedef FilterCallback<T> = void Function(T value);
typedef ToggleCallback = void Function(bool value);

class ControlBar extends StatelessWidget {
  final String filterSeverity;
  final String filterType;
  final bool showCompleted;

  final FilterCallback<String> onSeverityChanged;
  final FilterCallback<String> onTypeChanged;
  final ToggleCallback onShowCompletedChanged;

  const ControlBar({
    Key? key,
    required this.filterSeverity,
    required this.filterType,
    required this.showCompleted,
    required this.onSeverityChanged,
    required this.onTypeChanged,
    required this.onShowCompletedChanged,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Severity filter
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              'SEVERITY',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 6.5,
                fontWeight: FontWeight.w700,
                color: C.mutedLt,
                letterSpacing: 1.2,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChipWidget(
                  label: 'ALL',
                  isSelected: filterSeverity == 'ALL',
                  color: C.teal,
                  onTap: () => onSeverityChanged('ALL'),
                ),
                const SizedBox(width: 4),
                ...<String>['CRITICAL', 'HIGH', 'MEDIUM', 'LOW'].map(
                  (severity) => FilterChipWidget(
                    label: severity,
                    isSelected: filterSeverity == severity,
                    color: severity == 'CRITICAL'
                        ? C.red
                        : severity == 'HIGH'
                        ? C.orange
                        : severity == 'MEDIUM'
                        ? C.yellow
                        : C.cyan,
                    onTap: () => onSeverityChanged(severity),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Type filter
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              'TYPE',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 6.5,
                fontWeight: FontWeight.w700,
                color: C.mutedLt,
                letterSpacing: 1.2,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChipWidget(
                  label: 'ALL',
                  isSelected: filterType == 'ALL',
                  color: C.teal,
                  onTap: () => onTypeChanged('ALL'),
                ),
                const SizedBox(width: 4),
                ...<int>[0, 1, 2, 3, 4, 5, 6].map(
                  (idx) => FilterChipWidget(
                    label: IncidentType.values[idx].label,
                    isSelected: filterType == IncidentType.values[idx].label,
                    color: IncidentType.values[idx].color,
                    onTap: () => onTypeChanged(IncidentType.values[idx].label),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Show completed toggle
          GestureDetector(
            onTap: () => onShowCompletedChanged(!showCompleted),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: showCompleted
                        ? C.teal.withOpacity(0.2)
                        : Colors.transparent,
                    border: Border.all(
                      color: showCompleted ? C.teal : C.mutedLt,
                    ),
                  ),
                  child: showCompleted
                      ? const Icon(Icons.check_rounded, size: 12, color: C.teal)
                      : null,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Show Completed',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
