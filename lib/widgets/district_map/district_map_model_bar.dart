import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/district_map_data_model.dart';

typedef C = AppColors;

class DistrictMapModeBar extends StatelessWidget {
  final MapMode currentMode;
  final ValueChanged<MapMode> onModeSelected;

  const DistrictMapModeBar({
    super.key,
    required this.currentMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: C.bgCard2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        children: MapMode.values.map((mode) {
          final active = currentMode == mode;
          return GestureDetector(
            onTap: () => onModeSelected(mode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: active ? C.green.withOpacity(0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: active ? C.green.withOpacity(0.5) : C.gBdr,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    mode.icon,
                    size: 10,
                    color: active ? C.green : C.mutedLt,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    mode.label,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: active ? C.green : C.mutedLt,
                      letterSpacing: 0.8,
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
