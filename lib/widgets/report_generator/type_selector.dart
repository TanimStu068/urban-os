import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/report_gen_data_model.dart';
import 'package:urban_os/widgets/report_generator/slevel.dart';

typedef C = AppColors;

class ReportTypeSelectorWidget extends StatelessWidget {
  final Set<ReportType> selectedTypes;
  final ValueChanged<Set<ReportType>> onTypesChanged;

  const ReportTypeSelectorWidget({
    super.key,
    required this.selectedTypes,
    required this.onTypesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
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
            const SLabel('REPORT TYPE', 'SELECT ONE OR MORE'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReportType.values.map((t) {
                final active = selectedTypes.contains(t);
                return GestureDetector(
                  onTap: () {
                    final newTypes = {...selectedTypes};
                    active ? newTypes.remove(t) : newTypes.add(t);
                    if (newTypes.isNotEmpty) {
                      onTypesChanged(newTypes);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: active ? t.color.withOpacity(0.1) : C.bgCard2,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: active ? t.color.withOpacity(0.5) : C.gBdr,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          t.icon,
                          size: 12,
                          color: active ? t.color : C.mutedLt,
                        ),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.label,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 8.5,
                                color: active ? t.color : C.mutedLt,
                                letterSpacing: 0.5,
                                fontWeight: active
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            Text(
                              t.description,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 6.5,
                                color: active
                                    ? t.color.withOpacity(0.7)
                                    : C.mutedLt.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        if (active) ...[
                          const SizedBox(width: 6),
                          Icon(
                            Icons.check_circle_rounded,
                            size: 11,
                            color: t.color,
                          ),
                        ],
                      ],
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
