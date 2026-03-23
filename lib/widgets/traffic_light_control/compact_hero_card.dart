import 'package:flutter/material.dart';

import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_dashboard/tag_chip.dart';
import 'package:urban_os/widgets/traffic_light_control/mini_cycle_bar.dart';
import 'package:urban_os/widgets/traffic_light_control/small_traffic_light.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class CompactHeroCard extends StatelessWidget {
  final Intersection ix;

  final AnimationController glowCtrl;
  final AnimationController pulseCtrl;
  final AnimationController blinkCtrl;
  final AnimationController signalGlowCtrl;

  const CompactHeroCard({
    super.key,
    required this.ix,
    required this.glowCtrl,
    required this.pulseCtrl,
    required this.blinkCtrl,
    required this.signalGlowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final col = ix.phase.color;

    return AnimatedBuilder(
      animation: Listenable.merge([
        glowCtrl,
        pulseCtrl,
        blinkCtrl,
        signalGlowCtrl,
      ]),
      builder: (_, __) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: C.bgCard.withOpacity(0.92),
            border: Border.all(
              color: col.withOpacity(0.2 + glowCtrl.value * 0.08),
            ),
            boxShadow: [
              BoxShadow(color: col.withOpacity(0.07), blurRadius: 20),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Traffic Light
                SmallTrafficLight(
                  phase: ix.phase,
                  pulseT: pulseCtrl.value,
                  blinkT: blinkCtrl.value,
                  glowT: signalGlowCtrl.value,
                  isEmergency: ix.isEmergencyOverride,
                ),

                const SizedBox(width: 12),

                /// Info
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          TagChip(ix.id, kAccent),
                          const SizedBox(width: 4),
                          if (ix.isAdaptive) TagChip('AI', C.teal),
                          if (ix.isEmergencyOverride) ...[
                            const SizedBox(width: 4),
                            TagChip('EMRG', C.red),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ix.name,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: C.white,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ix.district,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: C.mutedLt,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                /// Right side (badge + stats)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: col.withOpacity(0.12),
                        border: Border.all(
                          color: col.withOpacity(0.4 + blinkCtrl.value * 0.15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: col.withOpacity(
                              0.15 + signalGlowCtrl.value * 0.1,
                            ),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            ix.phase.label,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: col,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${ix.timer}s',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: col,
                              shadows: [
                                Shadow(
                                  color: col.withOpacity(0.5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cycle ${ix.cycleDuration}s · ${ix.totalVehicles}/h',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7,
                        color: C.mutedLt,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 100,
                      child: MiniCycleBar(ix: ix, glowT: glowCtrl.value),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
