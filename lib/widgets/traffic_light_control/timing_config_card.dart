import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/card_widget.dart';
import 'package:urban_os/widgets/traffic_light_control/cycle_summary_bar.dart';
import 'package:urban_os/widgets/traffic_light_control/timing_slider.dart';

typedef C = AppColors;

class TimingConfigCard extends StatelessWidget {
  final Intersection ix;
  final AnimationController glowCtrl;
  final Function(Intersection ix, SignalPhase phase, double duration)
  onAdjustDuration;

  const TimingConfigCard({
    super.key,
    required this.ix,
    required this.glowCtrl,
    required this.onAdjustDuration,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'CYCLE TIMING',
      sub: 'Adjust phase durations',
      icon: Icons.timer_rounded,
      child: Column(
        children: [
          TimingSlider(
            'GREEN',
            ix.greenDuration,
            10,
            120,
            C.green,
            (d) => onAdjustDuration(ix, SignalPhase.green, d.toDouble()),
            glowCtrl.value,
          ),
          const SizedBox(height: 6),
          TimingSlider(
            'YELLOW',
            ix.yellowDuration,
            3,
            15,
            C.amber,
            (d) => onAdjustDuration(ix, SignalPhase.green, d.toDouble()),
            glowCtrl.value,
          ),
          const SizedBox(height: 6),
          TimingSlider(
            'RED',
            ix.redDuration,
            10,
            120,
            C.red,
            (d) => onAdjustDuration(ix, SignalPhase.green, d.toDouble()),
            glowCtrl.value,
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: glowCtrl,
            builder: (_, __) => CycleSummaryBar(ix: ix, glowT: glowCtrl.value),
          ),
        ],
      ),
    );
  }
}
