import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/card_widget.dart';
import 'package:urban_os/widgets/traffic_light_control/control_btn.dart';

typedef C = AppColors;

class PhaseControlsCard extends StatelessWidget {
  final Intersection ix;

  // final VoidCallback Function() setStateWrapper;
  final VoidCallback setStateWrapper;
  final void Function(Intersection, SignalPhase) onForcePhase;
  final void Function(Intersection, int) onExtendGreen;
  final void Function(Intersection) onAdvancePhase;
  final void Function(Intersection) onToggleAdaptive;
  final void Function(Intersection) onEmergencyOverride;
  final void Function(Intersection) onTriggerPedestrian;

  final AnimationController blinkCtrl;

  const PhaseControlsCard({
    super.key,
    required this.ix,
    required this.setStateWrapper,
    required this.onForcePhase,
    required this.onExtendGreen,
    required this.onAdvancePhase,
    required this.onToggleAdaptive,
    required this.onEmergencyOverride,
    required this.onTriggerPedestrian,
    required this.blinkCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'PHASE CONTROL',
      sub: 'Override & adaptive',
      icon: Icons.tune_rounded,
      child: Column(
        children: [
          /// Row 1: Force phase
          Row(
            children: [
              ControlBtn(
                'FORCE GREEN',
                C.green,
                Icons.circle,
                () => onForcePhase(ix, SignalPhase.green),
                ix.phase == SignalPhase.green,
              ),
              const SizedBox(width: 5),
              ControlBtn(
                'FORCE YLW',
                C.amber,
                Icons.circle,
                () => onForcePhase(ix, SignalPhase.yellow),
                ix.phase == SignalPhase.yellow,
              ),
              const SizedBox(width: 5),
              ControlBtn(
                'FORCE RED',
                C.red,
                Icons.circle,
                () => onForcePhase(ix, SignalPhase.red),
                ix.phase == SignalPhase.red,
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// Row 2: Extend / Skip / Adaptive
          Row(
            children: [
              ControlBtn(
                '+15s GREEN',
                C.teal,
                Icons.add_circle_outline_rounded,
                () => onExtendGreen(ix, 15),
                false,
                enabled: ix.phase == SignalPhase.green,
              ),
              const SizedBox(width: 5),
              ControlBtn(
                'SKIP PHASE',
                C.amber,
                Icons.skip_next_rounded,
                () => onAdvancePhase(ix),
                false,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onToggleAdaptive(ix);
                    setStateWrapper(); // works fine
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: ix.isAdaptive
                          ? C.teal.withOpacity(0.12)
                          : C.bgCard2,
                      border: Border.all(
                        color: ix.isAdaptive
                            ? C.teal.withOpacity(0.4)
                            : C.muted.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: ix.isAdaptive ? C.teal : C.muted,
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            ix.isAdaptive ? 'AI ON' : 'AI OFF',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: ix.isAdaptive ? C.teal : C.muted,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// Row 3: Emergency + Pedestrian
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onEmergencyOverride(ix),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: ix.isEmergencyOverride
                          ? C.red.withOpacity(0.15)
                          : C.bgCard2,
                      border: Border.all(
                        color: ix.isEmergencyOverride
                            ? C.red.withOpacity(0.5 + blinkCtrl.value * 0.2)
                            : C.muted.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emergency_rounded,
                          color: ix.isEmergencyOverride ? C.red : C.muted,
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            ix.isEmergencyOverride
                                ? 'OVERRIDE ON'
                                : 'EMRG HOLD',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: ix.isEmergencyOverride ? C.red : C.muted,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: GestureDetector(
                  onTap: ix.hasPedestrian
                      ? () => onTriggerPedestrian(ix)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: ix.isPedestrianActive
                          ? kAccent.withOpacity(0.12)
                          : C.bgCard2,
                      border: Border.all(
                        color: ix.hasPedestrian
                            ? (ix.isPedestrianActive
                                  ? kAccent.withOpacity(0.4)
                                  : C.muted.withOpacity(0.2))
                            : C.muted.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_walk_rounded,
                          color: ix.hasPedestrian
                              ? (ix.isPedestrianActive ? kAccent : C.muted)
                              : C.muted.withOpacity(0.3),
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            ix.isPedestrianActive
                                ? 'PED ${ix.pedestrianCountdown}s'
                                : (ix.hasPedestrian ? 'PED' : 'NO PED'),
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: ix.hasPedestrian
                                  ? (ix.isPedestrianActive ? kAccent : C.muted)
                                  : C.muted.withOpacity(0.3),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
