import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/energy_dashboard/efficiency_conparison_panel.dart';
import 'package:urban_os/widgets/energy_dashboard/generation_stat_panel.dart';
import 'package:urban_os/widgets/energy_dashboard/source_detail_card.dart';

class SourcesTab extends StatelessWidget {
  final List<EnergySourceModel> sources;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;
  final double totalGeneration;
  final double renewablePct;

  const SourcesTab({
    super.key,
    required this.sources,
    required this.glowAnimation,
    required this.blinkAnimation,
    required this.totalGeneration,
    required this.renewablePct,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Source cards
          ...sources.map(
            (s) => SourceDetailCard(
              source: s,
              glowAnimation: glowAnimation,
              blinkAnimation: blinkAnimation,
            ),
          ),
          const SizedBox(height: 12),

          // Efficiency comparison
          EfficiencyComparisonPanel(
            sources: sources,
            glowAnimation: glowAnimation,
          ),
          const SizedBox(height: 12),

          // Total generation stats
          GenerationStatsPanel(
            totalGeneration: totalGeneration,
            renewablePct: renewablePct,
            sources: sources,
          ),
        ],
      ),
    );
  }
}
