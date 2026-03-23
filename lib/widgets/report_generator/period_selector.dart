import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/report_gen_data_model.dart';
import 'package:urban_os/widgets/report_generator/slevel.dart';

typedef C = AppColors;

class ReportPeriodSelectorWidget extends StatelessWidget {
  final ReportPeriod selectedPeriod;
  final ValueChanged<ReportPeriod> onPeriodChanged;

  const ReportPeriodSelectorWidget({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
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
            const SLabel('TIME PERIOD', null),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: ReportPeriod.values.map((p) {
                final active = selectedPeriod == p;
                return GestureDetector(
                  onTap: () => onPeriodChanged(p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: active ? C.amber.withOpacity(0.1) : C.bgCard2,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: active ? C.amber.withOpacity(0.5) : C.gBdr,
                      ),
                    ),
                    child: Text(
                      p.label,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        color: active ? C.amber : C.mutedLt,
                        letterSpacing: 0.5,
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
