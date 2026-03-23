import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/weather_simulation/custom_slider.dart';

typedef C = AppColors;

class SimulationControlsWidget extends StatelessWidget {
  final double tempOffset;
  final double windMultiplier;
  final double rainfallMultiplier;
  final int currentHour;
  final void Function(double) onTempChanged;
  final void Function(double) onWindChanged;
  final void Function(double) onRainfallChanged;
  final VoidCallback onAdvanceSimulation;
  final VoidCallback onResetSimulation;

  const SimulationControlsWidget({
    super.key,
    required this.tempOffset,
    required this.windMultiplier,
    required this.rainfallMultiplier,
    required this.currentHour,
    required this.onTempChanged,
    required this.onWindChanged,
    required this.onRainfallChanged,
    required this.onAdvanceSimulation,
    required this.onResetSimulation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: C.bgCard.withOpacity(0.9),
        border: Border.all(color: C.lime.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.lime.withOpacity(0.12),
                  border: Border.all(color: C.lime.withOpacity(0.3)),
                ),
                child: const Icon(Icons.tune_rounded, color: C.lime, size: 11),
              ),
              const SizedBox(width: 7),
              const Text(
                'SIMULATION CONTROLS',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: C.lime,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0x1A00FFCC), height: 1),
          const SizedBox(height: 10),

          // Temperature slider
          CustomSliderWidget(
            label: 'Temperature Offset',
            value: tempOffset,
            min: -20,
            max: 20,
            color: C.amber,
            onChanged: onTempChanged,
          ),
          const SizedBox(height: 10),

          // Wind multiplier
          CustomSliderWidget(
            label: 'Wind Multiplier',
            value: windMultiplier,
            min: 0.1,
            max: 3.0,
            color: C.mint,
            onChanged: onWindChanged,
          ),
          const SizedBox(height: 10),

          // Rainfall multiplier
          CustomSliderWidget(
            label: 'Rainfall Multiplier',
            value: rainfallMultiplier,
            min: 0.0,
            max: 3.0,
            color: C.cyan,
            onChanged: onRainfallChanged,
          ),
          const SizedBox(height: 12),

          // Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onAdvanceSimulation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: C.teal.withOpacity(0.1),
                      border: Border.all(color: C.teal.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.skip_next_rounded,
                            color: C.teal,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${currentHour}h',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: C.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: onResetSimulation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: C.red.withOpacity(0.1),
                      border: Border.all(color: C.red.withOpacity(0.3)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.restart_alt_rounded,
                        color: C.red,
                        size: 14,
                      ),
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
