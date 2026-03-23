import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/consumption_analytics/intensity_box.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';

typedef C = AppColors;

class EnergyIntensityPanel extends StatelessWidget {
  const EnergyIntensityPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'ENERGY INTENSITY  (kWh / UNIT)',
      icon: Icons.lightbulb_outline_rounded,
      color: C.lime,
      child: Row(
        children: const [
          IntensityBox('RESIDENTIAL', '12.4', 'kWh/m²', C.cyan, -3.2),
          IntensityBox('COMMERCIAL', '18.7', 'kWh/m²', C.amber, 5.1),
          IntensityBox('INDUSTRIAL', '42.1', 'kWh/unit', C.red, 11.3),
          IntensityBox('GOVERNMENT', '9.8', 'kWh/m²', C.green, -1.4),
        ],
      ),
    );
  }
}
