import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';
import 'package:urban_os/widgets/energy_dashboard/source_row.dart';

typedef C = AppColors;

class SourceQuickViewPanel extends StatelessWidget {
  final List<EnergySourceModel> sources;
  final Animation<double> glowAnimation;

  const SourceQuickViewPanel({
    super.key,
    required this.sources,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'GENERATION SOURCES',
      icon: Icons.power_input_rounded,
      color: C.green,
      child: Column(
        children: sources.map((s) {
          return AnimatedBuilder(
            animation: glowAnimation,
            builder: (_, __) =>
                SourceRow(source: s, glowT: glowAnimation.value),
          );
        }).toList(),
      ),
    );
  }
}
