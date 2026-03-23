import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/approach_grid_card.dart';
import 'package:urban_os/widgets/traffic_light_control/bottom_row.dart';
import 'package:urban_os/widgets/traffic_light_control/compact_hero_card.dart';
import 'package:urban_os/widgets/traffic_light_control/intersection_map_card.dart';
import 'package:urban_os/widgets/traffic_light_control/phase_control_card.dart';
import 'package:urban_os/widgets/traffic_light_control/timing_config_card.dart';

class DetailPanel extends StatefulWidget {
  final Intersection ix;
  final AnimationController glowCtrl;
  final AnimationController pulseCtrl;
  final AnimationController blinkCtrl;
  final AnimationController signalGlowCtrl;
  final void Function(Intersection, SignalPhase) onForcePhase;
  final void Function(Intersection, int) onExtendGreen;
  final void Function(Intersection) onAdvancePhase;
  final void Function(Intersection) onToggleAdaptive;
  final void Function(Intersection) onEmergencyOverride;
  final void Function(Intersection) onTriggerPedestrian;

  const DetailPanel({
    super.key,
    required this.ix,
    required this.glowCtrl,
    required this.pulseCtrl,
    required this.blinkCtrl,
    required this.signalGlowCtrl,
    required this.onForcePhase,
    required this.onExtendGreen,
    required this.onAdvancePhase,
    required this.onToggleAdaptive,
    required this.onEmergencyOverride,
    required this.onTriggerPedestrian,
  });

  @override
  State<DetailPanel> createState() => _DetailPanelState();
}

class _DetailPanelState extends State<DetailPanel> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.glowCtrl,
        widget.blinkCtrl,
        widget.pulseCtrl,
        widget.signalGlowCtrl,
      ]),
      builder: (_, __) => ListView(
        padding: const EdgeInsets.fromLTRB(4, 10, 10, 40),
        physics: const BouncingScrollPhysics(),
        children: [
          // 1. Compact Signal Hero
          CompactHeroCard(
            ix: widget.ix,
            glowCtrl: widget.glowCtrl,
            pulseCtrl: widget.pulseCtrl,
            blinkCtrl: widget.blinkCtrl,
            signalGlowCtrl: widget.signalGlowCtrl,
          ),
          const SizedBox(height: 8),

          // 2. Phase Controls
          PhaseControlsCard(
            ix: widget.ix,
            blinkCtrl: widget.blinkCtrl,
            onForcePhase: widget.onForcePhase,
            onExtendGreen: widget.onExtendGreen,
            onAdvancePhase: widget.onAdvancePhase,
            onToggleAdaptive: widget.onToggleAdaptive,
            onEmergencyOverride: widget.onEmergencyOverride,
            onTriggerPedestrian: widget.onTriggerPedestrian,
            setStateWrapper: () => setState(() {}),
          ),
          const SizedBox(height: 8),

          // 3. Cycle Timing
          TimingConfigCard(
            ix: widget.ix,
            glowCtrl: widget.glowCtrl,
            onAdjustDuration: (ix, phase, dur) {
              // implement your duration adjustment logic here
            },
          ),
          const SizedBox(height: 8),

          // 4. Approach Queues Grid
          ApproachGridCard(ix: widget.ix, glowCtrl: widget.glowCtrl),
          const SizedBox(height: 8),

          // 5. Intersection Map
          IntersectionMapCard(
            ix: widget.ix,
            glowCtrl: widget.glowCtrl,
            pulseCtrl: widget.pulseCtrl,
            blinkCtrl: widget.blinkCtrl,
          ),
          const SizedBox(height: 8),

          // 6. Phase History + Capabilities
          BottomRow(ix: widget.ix, glowCtrl: widget.glowCtrl),
        ],
      ),
    );
  }
}
