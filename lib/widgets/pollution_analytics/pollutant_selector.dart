import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/pollution_analysis_data_model.dart';

typedef C = AppColors;

class PollutantSelector extends StatelessWidget {
  final PollutantType selectedPollutant;
  final Function(PollutantType) onChanged;
  final AnimationController barAnimCtrl;

  const PollutantSelector({
    super.key,
    required this.selectedPollutant,
    required this.onChanged,
    required this.barAnimCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: PollutantType.values.map((p) {
          final isSel = p == selectedPollutant;

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () {
                onChanged(p);
                barAnimCtrl.forward(from: 0);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 170),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: isSel ? p.color.withOpacity(0.14) : Colors.transparent,
                  border: isSel
                      ? Border.all(color: p.color.withOpacity(0.4))
                      : null,
                ),
                child: Text(
                  p.label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    color: isSel ? p.color : C.mutedLt,
                    fontWeight: isSel ? FontWeight.w800 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
