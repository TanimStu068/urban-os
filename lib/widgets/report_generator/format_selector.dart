import 'package:flutter/material.dart';

import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/report_gen_data_model.dart';
import 'package:urban_os/widgets/report_generator/slevel.dart';

typedef C = AppColors;

class ReportFormatSelectorWidget extends StatelessWidget {
  final ReportFormat selectedFormat;
  final ValueChanged<ReportFormat> onFormatChanged;

  const ReportFormatSelectorWidget({
    super.key,
    required this.selectedFormat,
    required this.onFormatChanged,
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
            const SLabel('OUTPUT FORMAT', null),
            const SizedBox(height: 10),
            Row(
              children: ReportFormat.values.map((f) {
                final active = selectedFormat == f;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onFormatChanged(f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: active ? C.cyan.withOpacity(0.1) : C.bgCard2,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: active ? C.cyan.withOpacity(0.5) : C.gBdr,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            f.icon,
                            size: 16,
                            color: active ? C.cyan : C.mutedLt,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            f.label,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              color: active ? C.cyan : C.mutedLt,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
