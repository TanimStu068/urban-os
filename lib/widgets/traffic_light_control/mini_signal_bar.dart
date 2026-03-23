import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/mini_dot.dart';

class MiniSignalLight extends StatelessWidget {
  final SignalPhase phase;
  final double pulseT, blinkT;
  const MiniSignalLight({
    super.key,
    required this.phase,
    required this.pulseT,
    required this.blinkT,
  });

  @override
  Widget build(BuildContext ctx) => Container(
    width: 18,
    height: 42,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: const Color(0xFF040C14),
      border: Border.all(color: C.mutedLt.withOpacity(0.2)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MiniDot(C.red, isOn: phase == SignalPhase.red, blinkT: blinkT),
        MiniDot(C.amber, isOn: phase == SignalPhase.yellow, blinkT: blinkT),
        MiniDot(C.green, isOn: phase == SignalPhase.green, blinkT: blinkT),
      ],
    ),
  );
}
