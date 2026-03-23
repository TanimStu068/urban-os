import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/report_gen_data_model.dart';
import 'package:urban_os/widgets/report_generator/option_row.dart';
import 'package:urban_os/widgets/report_generator/slevel.dart';

typedef C = AppColors;

class ReportOptionsWidget extends StatelessWidget {
  final ReportConfig config;
  final ValueChanged<ReportConfig> onConfigChanged;

  const ReportOptionsWidget({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: C.gBdr),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SLabel('OPTIONS', null),
            const SizedBox(height: 10),
            OptionRow(
              'Include Charts',
              Icons.bar_chart_rounded,
              C.violet,
              config.includeCharts,
              (v) => onConfigChanged(config.copyWith(includeCharts: v)),
            ),
            OptionRow(
              'Include Raw Data',
              Icons.table_rows_rounded,
              C.cyan,
              config.includeRawData,
              (v) => onConfigChanged(config.copyWith(includeRawData: v)),
            ),
            OptionRow(
              'Compress Output',
              Icons.compress_rounded,
              C.amber,
              config.compressOutput,
              (v) => onConfigChanged(config.copyWith(compressOutput: v)),
            ),
            OptionRow(
              'Include Metadata',
              Icons.info_outline_rounded,
              C.green,
              config.includeMetadata,
              (v) => onConfigChanged(config.copyWith(includeMetadata: v)),
            ),
          ],
        ),
      ),
    );
  }
}
