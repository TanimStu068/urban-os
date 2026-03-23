import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/energy_dashboard/donut_painter.dart';

class MiniDonut extends StatelessWidget {
  final List<EnergySourceModel> sources;
  final double totalGen;
  final double glowT;

  const MiniDonut({
    super.key,
    required this.sources,
    required this.totalGen,
    required this.glowT,
  });

  @override
  Widget build(BuildContext ctx) => Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 42,
          height: 42,
          child: CustomPaint(
            painter: DonutPainter(
              sources: sources,
              glowT: glowT,
              compact: true,
            ),
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'MIX',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 6,
            color: C.muted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
  );
}
