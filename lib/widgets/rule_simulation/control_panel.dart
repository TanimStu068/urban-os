import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';
import 'package:urban_os/widgets/rule_simulation/sim_panel.dart';
import 'package:urban_os/widgets/rule_simulation/inj_btn.dart';
import 'package:urban_os/widgets/rule_simulation/stat_row.dart';

typedef C = AppColors;

class ControlPanel extends StatelessWidget {
  final SimPhase phase;
  final int currentTick;
  final int totalTicks;
  final int triggerCount;
  final int ticksSinceTrigger;
  final Animation<double> glowAnimation;

  final VoidCallback startSim;
  final VoidCallback pauseSim;
  final VoidCallback resumeSim;
  final VoidCallback stopSim;
  final void Function(String) injectState;
  final VoidCallback resetSensors;

  const ControlPanel({
    super.key,
    required this.phase,
    required this.currentTick,
    required this.totalTicks,
    required this.triggerCount,
    required this.ticksSinceTrigger,
    required this.glowAnimation,
    required this.startSim,
    required this.pauseSim,
    required this.resumeSim,
    required this.stopSim,
    required this.injectState,
    required this.resetSensors,
  });

  @override
  Widget build(BuildContext context) {
    return SimPanel(
      title: 'CONTROLS',
      icon: Icons.play_circle_outline_rounded,
      color: C.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // RUN/PAUSE/RESUME Button
          AnimatedBuilder(
            animation: glowAnimation,
            builder: (_, __) {
              Color btnCol;
              String btnLabel;
              IconData btnIcon;
              VoidCallback? btnTap;

              if (phase == SimPhase.idle || phase == SimPhase.completed) {
                btnCol = C.green;
                btnLabel = 'RUN SIMULATION';
                btnIcon = Icons.play_arrow_rounded;
                btnTap = startSim;
              } else if (phase == SimPhase.running) {
                btnCol = C.amber;
                btnLabel = 'PAUSE';
                btnIcon = Icons.pause_rounded;
                btnTap = pauseSim;
              } else {
                btnCol = C.green;
                btnLabel = 'RESUME';
                btnIcon = Icons.play_arrow_rounded;
                btnTap = resumeSim;
              }

              return GestureDetector(
                onTap: btnTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        btnCol.withOpacity(0.2),
                        btnCol.withOpacity(0.08),
                      ],
                    ),
                    border: Border.all(
                      color: btnCol.withOpacity(
                        0.45 + glowAnimation.value * 0.15,
                      ),
                      width: 1.3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: btnCol.withOpacity(
                          0.12 + glowAnimation.value * 0.06,
                        ),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(btnIcon, color: btnCol, size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          btnLabel,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: btnCol,
                            letterSpacing: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          // STOP & RESET Button
          GestureDetector(
            onTap: phase != SimPhase.idle ? stopSim : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: phase != SimPhase.idle
                    ? C.red.withOpacity(0.1)
                    : C.bgCard2,
                border: Border.all(
                  color: phase != SimPhase.idle
                      ? C.red.withOpacity(0.35)
                      : C.muted.withOpacity(0.15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.stop_rounded,
                    color: phase != SimPhase.idle ? C.red : C.muted,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'STOP & RESET',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8.5,
                      color: phase != SimPhase.idle ? C.red : C.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // INJECT SCENARIO Section
          const Text(
            'INJECT SCENARIO',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: C.muted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          InjBtn('⚡ FORCE TRIGGER', C.red, () => injectState('trigger')),
          const SizedBox(height: 5),
          InjBtn('✓ SET SAFE', C.green, () => injectState('safe')),
          const SizedBox(height: 5),
          InjBtn('◎ EDGE CASE', C.amber, () => injectState('edge')),
          const SizedBox(height: 5),
          InjBtn('↺ RESET SENSORS', C.mutedLt, resetSensors),
          const SizedBox(height: 12),

          // SESSION STATS Section
          const Text(
            'SESSION STATS',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: C.muted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          StatRow('TICK', '$currentTick / $totalTicks'),
          StatRow('TRIGGERS', '$triggerCount'),
          StatRow(
            'RATE',
            currentTick > 0
                ? '${(triggerCount / currentTick * 100).toStringAsFixed(1)}%'
                : '—',
          ),
          StatRow(
            'LAST TRIG',
            triggerCount > 0 ? '${ticksSinceTrigger}t ago' : '—',
          ),
        ],
      ),
    );
  }
}
