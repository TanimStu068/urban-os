import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/card_widget.dart';
import 'package:urban_os/widgets/traffic_light_control/spark_line_painter.dart';
import 'package:urban_os/widgets/traffic_light_control/cap_chip.dart';

class BottomRow extends StatelessWidget {
  final Intersection ix;
  final AnimationController glowCtrl;

  const BottomRow({Key? key, required this.ix, required this.glowCtrl})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phase History
        Expanded(
          flex: 3,
          child: CardWidget(
            title: 'PHASE HISTORY',
            sub: 'Last 8 green cycles',
            icon: Icons.history_rounded,
            child: AnimatedBuilder(
              animation: glowCtrl,
              builder: (_, __) => SizedBox(
                height: 60,
                child: CustomPaint(
                  painter: SparklinePainter(
                    data: ix.phaseLog.map((e) => e.toDouble()).toList(),
                    glowT: glowCtrl.value,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),

        // Capabilities
        Expanded(
          flex: 2,
          child: CardWidget(
            title: 'HARDWARE',
            sub: 'Capabilities',
            icon: Icons.memory_rounded,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CapChip(
                        'CAM',
                        Icons.videocam_rounded,
                        ix.hasCamera,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: CapChip(
                        'SENS',
                        Icons.sensors_rounded,
                        ix.hasSensor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: CapChip(
                        'PED',
                        Icons.directions_walk_rounded,
                        ix.hasPedestrian,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: CapChip(
                        'AI',
                        Icons.auto_awesome_rounded,
                        ix.isAdaptive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
