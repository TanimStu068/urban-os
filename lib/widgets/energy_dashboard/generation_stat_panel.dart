import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/energy_dashboard/panel.dart';
import 'package:urban_os/widgets/energy_dashboard/stat_box.dart';
import 'package:urban_os/widgets/energy_dashboard/vdivider.dart';

typedef C = AppColors;

class GenerationStatsPanel extends StatelessWidget {
  final double totalGeneration; // in kW
  final double renewablePct;
  final List<EnergySourceModel> sources;

  const GenerationStatsPanel({
    super.key,
    required this.totalGeneration,
    required this.renewablePct,
    required this.sources,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'GENERATION STATISTICS',
      icon: Icons.analytics_rounded,
      color: C.teal,
      child: Row(
        children: [
          StatBox(
            'TOTAL\nOUTPUT',
            '${(totalGeneration / 1000).toStringAsFixed(1)} MW',
            C.green,
          ),
          const VDivider(),
          StatBox(
            'RENEWABLE\nSHARE',
            '${renewablePct.toStringAsFixed(0)}%',
            C.teal,
          ),
          const VDivider(),
          StatBox(
            'ACTIVE\nSOURCES',
            '${sources.where((s) => s.isActive).length} / ${sources.length}',
            C.amber,
          ),
          const VDivider(),
          StatBox(
            'GRID\nIMPORT',
            '${(sources.firstWhere((s) => s.type == EnergySource.grid).output / 1000).toStringAsFixed(1)} MW',
            C.orange,
          ),
        ],
      ),
    );
  }
}
