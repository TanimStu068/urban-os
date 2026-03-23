import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';
import 'package:urban_os/widgets/traffic_dashboard/signal_summary_chip.dart';
import 'package:urban_os/widgets/traffic_dashboard/traffic_light_card.dart';

typedef C = AppColors;

class SignalsTab extends StatelessWidget {
  final List<TrafficLight> lights;
  final AnimationController glowCtrl, blinkCtrl, pulseCtrl;
  final ValueChanged<TrafficLight> onToggleAdaptive;
  final void Function(TrafficLight, String) onForcePhase;
  const SignalsTab({
    super.key,
    required this.lights,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.pulseCtrl,
    required this.onToggleAdaptive,
    required this.onForcePhase,
  });

  @override
  Widget build(BuildContext ctx) => ListView(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
    physics: const BouncingScrollPhysics(),
    children: [
      // Summary row
      AnimatedBuilder(
        animation: glowCtrl,
        builder: (_, __) => Row(
          children: [
            SignalSummaryChip(
              '${lights.where((l) => l.phase == 'GREEN').length}',
              'GREEN',
              C.green,
              glowCtrl.value,
            ),
            const SizedBox(width: 8),
            SignalSummaryChip(
              '${lights.where((l) => l.phase == 'YELLOW').length}',
              'YELLOW',
              C.amber,
              glowCtrl.value,
            ),
            const SizedBox(width: 8),
            SignalSummaryChip(
              '${lights.where((l) => l.phase == 'RED').length}',
              'RED',
              C.red,
              glowCtrl.value,
            ),
            const SizedBox(width: 8),
            SignalSummaryChip(
              '${lights.where((l) => l.isAdaptive).length}',
              'ADAPT.',
              kAccent,
              glowCtrl.value,
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      ...lights.map(
        (tl) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TrafficLightCard(
            tl: tl,
            glowCtrl: glowCtrl,
            blinkCtrl: blinkCtrl,
            pulseCtrl: pulseCtrl,
            onToggleAdaptive: () => onToggleAdaptive(tl),
            onForcePhase: (p) => onForcePhase(tl, p),
          ),
        ),
      ),
    ],
  );
}
