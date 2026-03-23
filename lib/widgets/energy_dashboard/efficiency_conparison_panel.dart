import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/energy_dashboard/panel.dart';

typedef C = AppColors;

class EfficiencyComparisonPanel extends StatelessWidget {
  final List<EnergySourceModel> sources;
  final Animation<double> glowAnimation;

  const EfficiencyComparisonPanel({
    super.key,
    required this.sources,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final activeSources = sources.where((s) => s.isActive).toList();

    return Panel(
      title: 'EFFICIENCY COMPARISON',
      icon: Icons.compare_arrows_rounded,
      color: C.violet,
      child: Column(
        children: activeSources.map((s) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    s.type.label,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: s.type.color,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AnimatedBuilder(
                    animation: glowAnimation,
                    builder: (_, __) => Stack(
                      children: [
                        Container(
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: C.bgCard2,
                            border: Border.all(color: C.gBdr),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: s.efficiency / 100,
                          child: Container(
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: s.type.color.withOpacity(0.5),
                              boxShadow: [
                                BoxShadow(
                                  color: s.type.color.withOpacity(
                                    0.2 + glowAnimation.value * 0.1,
                                  ),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${s.efficiency.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: C.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
