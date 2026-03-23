import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/developer_panel_data_model.dart';
import 'package:urban_os/widgets/developer_panel/log_card.dart';
import 'package:urban_os/widgets/developer_panel/log_filter_chip.dart';

typedef C = AppColors;

class LogsView extends StatefulWidget {
  final List<DebugLog> logs;
  final List<DebugLog> filteredLogs;
  final int errorCount;
  final int warningCount;
  final int infoCount;
  final ScrollController scrollController;

  const LogsView({
    super.key,
    required this.logs,
    required this.filteredLogs,
    required this.errorCount,
    required this.warningCount,
    required this.infoCount,
    required this.scrollController,
  });

  @override
  State<LogsView> createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {
  String _logFilter = 'ALL';
  final Set<String> _expandedLogs = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: [
          // Filter bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('ALL', widget.logs.length, C.cyan),
                const SizedBox(width: 4),
                _buildFilterChip('ERROR', widget.errorCount, C.red),
                const SizedBox(width: 4),
                _buildFilterChip('WARN', widget.warningCount, C.orange),
                const SizedBox(width: 4),
                _buildFilterChip('INFO', widget.infoCount, C.teal),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Logs list
          ...widget.filteredLogs.map(
            (log) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: LogCard(
                log: log,
                isExpanded: _expandedLogs.contains(log.id),
                onTap: () {
                  setState(() {
                    if (_expandedLogs.contains(log.id)) {
                      _expandedLogs.remove(log.id);
                    } else {
                      _expandedLogs.add(log.id);
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count, Color color) {
    return LogFilterChip(
      label: label,
      count: count,
      isSelected: _logFilter == label,
      color: color,
      onTap: () {
        setState(() {
          _logFilter = label;
        });
      },
    );
  }
}
