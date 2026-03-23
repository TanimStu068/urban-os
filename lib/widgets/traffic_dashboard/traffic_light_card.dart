import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';
import 'package:urban_os/widgets/traffic_dashboard/tag_chip.dart';
import 'package:urban_os/widgets/traffic_dashboard/traffic_light_visual.dart';

typedef C = AppColors;
// Traffic theme accent
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

class TrafficLightCard extends StatelessWidget {
  final TrafficLight tl;
  final AnimationController glowCtrl, blinkCtrl, pulseCtrl;
  final VoidCallback onToggleAdaptive;
  final ValueChanged<String> onForcePhase;
  const TrafficLightCard({
    super.key,
    required this.tl,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.pulseCtrl,
    required this.onToggleAdaptive,
    required this.onForcePhase,
  });

  Color get _phaseColor => tl.phase == 'GREEN'
      ? C.green
      : tl.phase == 'YELLOW'
      ? C.amber
      : C.red;
  String get _nextPhase => tl.phase == 'GREEN'
      ? 'YELLOW'
      : tl.phase == 'YELLOW'
      ? 'RED'
      : 'GREEN';

  @override
  Widget build(BuildContext ctx) => AnimatedBuilder(
    animation: Listenable.merge([glowCtrl, blinkCtrl, pulseCtrl]),
    builder: (_, __) {
      final pc = _phaseColor;
      final isYellow = tl.phase == 'YELLOW';
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.bgCard.withOpacity(.92),
          border: Border.all(
            color: isYellow
                ? pc.withOpacity(.35 + blinkCtrl.value * .2)
                : pc.withOpacity(.22 + glowCtrl.value * .08),
          ),
          boxShadow: [
            BoxShadow(
              color: pc.withOpacity(.06 + glowCtrl.value * .03),
              blurRadius: 16,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Traffic light visual
                TrafficLightVisual(
                  phase: tl.phase,
                  pulseT: pulseCtrl.value,
                  blinkT: blinkCtrl.value,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tl.intersection,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: C.white,
                          letterSpacing: .3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          TagChip(tl.id, kAccent),
                          const SizedBox(width: 6),
                          if (tl.isAdaptive) TagChip('ADAPTIVE', C.teal),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Phase timer bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 4,
                                    color: pc.withOpacity(.12),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: (tl.phaseTimer / tl.cycleTime)
                                        .clamp(0, 1),
                                    child: Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        gradient: LinearGradient(
                                          colors: [pc.withOpacity(.5), pc],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: pc.withOpacity(.3),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${tl.phaseTimer}s',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: pc,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      tl.phase,
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: pc,
                        shadows: [
                          Shadow(color: pc.withOpacity(.5), blurRadius: 8),
                        ],
                      ),
                    ),
                    Text(
                      'PHASE',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7,
                        color: C.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Control buttons
            Row(
              children: [
                // Force next phase
                Expanded(
                  child: GestureDetector(
                    onTap: () => onForcePhase(_nextPhase),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: C.amber.withOpacity(.1),
                        border: Border.all(color: C.amber.withOpacity(.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.skip_next_rounded,
                            color: C.amber,
                            size: 14,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'FORCE NEXT',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              color: C.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Toggle adaptive
                Expanded(
                  child: GestureDetector(
                    onTap: onToggleAdaptive,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: tl.isAdaptive
                            ? C.teal.withOpacity(.12)
                            : C.bgCard2,
                        border: Border.all(
                          color: tl.isAdaptive
                              ? C.teal.withOpacity(.4)
                              : C.muted.withOpacity(.25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: tl.isAdaptive ? C.teal : C.muted,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            tl.isAdaptive ? 'ADAPTIVE ON' : 'ADAPTIVE OFF',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              color: tl.isAdaptive ? C.teal : C.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Extend green (if green)
                if (tl.phase == 'GREEN')
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: C.green.withOpacity(.1),
                          border: Border.all(color: C.green.withOpacity(.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_circle_outline_rounded,
                              color: C.green,
                              size: 14,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'EXTEND +15s',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 8,
                                color: C.green,
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
    },
  );
}
