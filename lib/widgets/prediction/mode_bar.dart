import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';

typedef C = AppColors;

class PredictModeBar extends StatelessWidget {
  final PredictMode currentMode;
  final Function(PredictMode) onModeChange;

  const PredictModeBar({
    super.key,
    required this.currentMode,
    required this.onModeChange,
  });

  @override
  Widget build(BuildContext context) {
    const modes = [PredictMode.anomaly, PredictMode.forecast, PredictMode.risk];

    const labels = ['ANOMALY DETECT', 'FORECAST', 'RISK MAP'];

    const icons = [
      Icons.search_rounded,
      Icons.trending_up_rounded,
      Icons.map_rounded,
    ];

    return Container(
      height: 40,
      color: C.bgCard2,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(3, (i) {
          final active = currentMode == modes[i];

          return GestureDetector(
            onTap: () => onModeChange(modes[i]),

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),

              decoration: BoxDecoration(
                color: active ? C.violet.withOpacity(0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: active ? C.violet.withOpacity(0.5) : C.gBdr,
                ),
              ),

              child: Row(
                children: [
                  Icon(
                    icons[i],
                    size: 11,
                    color: active ? C.violet : C.mutedLt,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    labels[i],
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8.5,
                      letterSpacing: 1,
                      color: active ? C.violet : C.mutedLt,
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
