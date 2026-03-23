import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';
import 'package:urban_os/widgets/rule_simulation/sim_panel.dart';
import 'package:urban_os/widgets/rule_simulation/tiny_toggle.dart';

typedef C = AppColors;

class SimConfigPanel extends StatelessWidget {
  final int totalTicks;
  final SimPhase phase;
  final SimSpeed speed;
  final SimScenario scenario;
  final bool noiseEnabled;
  final double noiseAmp;

  final ValueChanged<int> onTotalTicksChanged;
  final ValueChanged<SimSpeed> onSpeedChanged;
  final ValueChanged<SimScenario> onScenarioChanged;
  final VoidCallback onNoiseToggled;
  final ValueChanged<double> onNoiseAmpChanged;

  const SimConfigPanel({
    super.key,
    required this.totalTicks,
    required this.phase,
    required this.speed,
    required this.scenario,
    required this.noiseEnabled,
    required this.noiseAmp,
    required this.onTotalTicksChanged,
    required this.onSpeedChanged,
    required this.onScenarioChanged,
    required this.onNoiseToggled,
    required this.onNoiseAmpChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SimPanel(
      title: 'CONFIGURATION',
      icon: Icons.tune_rounded,
      color: C.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DURATION Slider
          Row(
            children: [
              const Text(
                'DURATION',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: C.muted,
                ),
              ),
              const Spacer(),
              Text(
                '$totalTicks TICKS',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: C.mutedLt,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: C.cyan,
              inactiveTrackColor: C.muted,
              thumbColor: C.cyan,
              overlayColor: C.cyan.withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              trackHeight: 3,
            ),
            child: Slider(
              value: totalTicks.toDouble(),
              min: 10,
              max: 100,
              divisions: 18,
              onChanged: (phase == SimPhase.idle || phase == SimPhase.completed)
                  ? (v) => onTotalTicksChanged(v.toInt())
                  : null,
            ),
          ),

          const SizedBox(height: 6),
          const Text(
            'TICK SPEED',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: C.muted,
            ),
          ),
          const SizedBox(height: 6),

          // SPEED Selection
          Row(
            children: SimSpeed.values.map((s) {
              final isSel = s == speed;
              return Expanded(
                child: GestureDetector(
                  onTap: (phase == SimPhase.idle || phase == SimPhase.completed)
                      ? () => onSpeedChanged(s)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 5),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: isSel
                          ? s.color.withOpacity(0.15)
                          : C.bgCard2.withOpacity(0.5),
                      border: Border.all(
                        color: isSel ? s.color.withOpacity(0.5) : C.gBdr,
                      ),
                    ),
                    child: Text(
                      s.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        fontWeight: isSel ? FontWeight.w800 : FontWeight.normal,
                        color: isSel ? s.color : C.muted,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),
          const Text(
            'SCENARIO',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: C.muted,
            ),
          ),
          const SizedBox(height: 6),

          // SCENARIO Selection
          Row(
            children: SimScenario.values.map((s) {
              final isSel = s == scenario;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onScenarioChanged(s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 5),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: isSel
                          ? s.color.withOpacity(0.15)
                          : C.bgCard2.withOpacity(0.5),
                      border: Border.all(
                        color: isSel ? s.color.withOpacity(0.5) : C.gBdr,
                      ),
                    ),
                    child: Text(
                      s.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7.5,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.normal,
                        color: isSel ? s.color : C.muted,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // SENSOR NOISE Toggle
          Row(
            children: [
              const Text(
                'SENSOR NOISE',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: C.muted,
                ),
              ),
              const Spacer(),
              TinyToggle(value: noiseEnabled, onToggle: onNoiseToggled),
            ],
          ),

          // NOISE AMPLITUDE Slider
          if (noiseEnabled) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Text(
                  'AMPLITUDE',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    color: C.muted,
                  ),
                ),
                const Spacer(),
                Text(
                  '±${(noiseAmp * 100).toInt()}%',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    color: C.violet,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: C.violet,
                inactiveTrackColor: C.muted,
                thumbColor: C.violet,
                overlayColor: C.violet.withOpacity(0.1),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                trackHeight: 2,
              ),
              child: Slider(
                value: noiseAmp,
                min: 0.01,
                max: 0.4,
                divisions: 39,
                onChanged: onNoiseAmpChanged,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
