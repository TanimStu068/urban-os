import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/energy_dashboard/donut_painter.dart';
import 'package:urban_os/widgets/energy_dashboard/panel.dart';

typedef C = AppColors;

class EnergyMixPanel extends StatelessWidget {
  final List<EnergySourceModel> sources;
  final double totalGeneration;
  final Animation<double> glowAnimation;

  const EnergyMixPanel({
    super.key,
    required this.sources,
    required this.totalGeneration,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'ENERGY MIX',
      icon: Icons.donut_large_rounded,
      color: C.yellow,
      child: Column(
        children: [
          SizedBox(
            height: 130,
            child: AnimatedBuilder(
              animation: glowAnimation,
              builder: (_, __) => CustomPaint(
                painter: DonutPainter(
                  sources: sources,
                  glowT: glowAnimation.value,
                ),
                size: const Size(double.infinity, 130),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Legend
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: sources.map((s) {
              final pct = totalGeneration > 0
                  ? s.output / totalGeneration * 100
                  : 0.0;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: s.type.color,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${s.type.label}  ${pct.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: s.isActive ? s.type.color : C.muted,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
