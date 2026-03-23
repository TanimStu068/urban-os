import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';
import 'package:urban_os/widgets/rule_simulation/sim_panel.dart';
import 'package:urban_os/widgets/rule_simulation/time_line_chart_painter.dart';

typedef C = AppColors;

class SimulationTimelineChart extends StatelessWidget {
  final List<SimTick> ticks;
  final List<SimSensor> sensors;
  final dynamic rule;
  final AnimationController glowCtrl;

  const SimulationTimelineChart({
    super.key,
    required this.ticks,
    required this.sensors,
    required this.rule,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SimPanel(
      title: 'TRIGGER TIMELINE',
      icon: Icons.show_chart_rounded,
      color: C.cyan,
      child: SizedBox(
        height: 100,
        child: AnimatedBuilder(
          animation: glowCtrl,
          builder: (_, __) => CustomPaint(
            painter: TimelineChartPainter(
              ticks: ticks,
              sensors: sensors,
              rule: rule,
              glowT: glowCtrl.value,
            ),
            size: const Size(double.infinity, 100),
          ),
        ),
      ),
    );
  }
}
