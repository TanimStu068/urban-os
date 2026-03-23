import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/big_light.dart';

class SmallTrafficLight extends StatelessWidget {
  final SignalPhase phase;
  final double pulseT, blinkT, glowT;
  final bool isEmergency;
  const SmallTrafficLight({
    super.key,
    required this.phase,
    required this.pulseT,
    required this.blinkT,
    required this.glowT,
    required this.isEmergency,
  });

  @override
  Widget build(BuildContext ctx) => Container(
    width: 36,
    height: 90,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: const Color(0xFF060F1A),
      border: Border.all(color: C.mutedLt.withOpacity(0.3), width: 1.2),
      boxShadow: [
        BoxShadow(color: phase.color.withOpacity(0.12), blurRadius: 16),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BigLight(
          C.red,
          isOn: isEmergency || phase == SignalPhase.red,
          blink: isEmergency,
          blinkT: blinkT,
          pulseT: pulseT,
          glowT: glowT,
          size: 20,
        ),
        BigLight(
          C.amber,
          isOn: phase == SignalPhase.yellow,
          blink: phase == SignalPhase.yellow,
          blinkT: blinkT,
          pulseT: pulseT,
          glowT: glowT,
          size: 20,
        ),
        BigLight(
          C.green,
          isOn: phase == SignalPhase.green,
          blink: false,
          blinkT: blinkT,
          pulseT: pulseT,
          glowT: glowT,
          size: 20,
        ),
      ],
    ),
  );
}
