import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';

typedef C = AppColors;

class ChartModeBar extends StatelessWidget {
  final ChartMode currentMode;
  final ValueChanged<ChartMode> onModeSelected;

  const ChartModeBar({
    super.key,
    required this.currentMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final modes = [
      (ChartMode.consumption, Icons.show_chart_rounded, 'LOAD CURVE'),
      (ChartMode.comparison, Icons.compare_arrows_rounded, 'COMPARE'),
      (ChartMode.forecast, Icons.trending_up_rounded, 'FORECAST'),
      (ChartMode.breakdown, Icons.donut_large_rounded, 'BREAKDOWN'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 6, 14, 0),
      height: 34,
      child: Row(
        children: modes.map((m) {
          final isSel = m.$1 == currentMode;
          return Expanded(
            child: GestureDetector(
              onTap: () => onModeSelected(m.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: isSel
                      ? C.cyan.withOpacity(0.12)
                      : C.bgCard.withOpacity(0.5),
                  border: Border.all(
                    color: isSel ? C.cyan.withOpacity(0.4) : C.gBdr,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(m.$2, color: isSel ? C.cyan : C.mutedLt, size: 11),
                    const SizedBox(width: 5),
                    Text(
                      m.$3,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7.5,
                        color: isSel ? C.cyan : C.mutedLt,
                        fontWeight: isSel ? FontWeight.w800 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
