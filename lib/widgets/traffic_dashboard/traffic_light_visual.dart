import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/traffic_dashboard/light_dot.dart';

typedef C = AppColors;

class TrafficLightVisual extends StatelessWidget {
  final String phase;
  final double pulseT, blinkT;
  const TrafficLightVisual({
    super.key,
    required this.phase,
    required this.pulseT,
    required this.blinkT,
  });

  @override
  Widget build(BuildContext ctx) {
    final isYellow = phase == 'YELLOW';
    return Container(
      width: 28,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color(0xFF0A1F30),
        border: Border.all(color: C.mutedLt.withOpacity(.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          LightDot(
            C.red,
            isOn: phase == 'RED',
            blink: false,
            pulseT: pulseT,
            blinkT: blinkT,
          ),
          LightDot(
            C.amber,
            isOn: phase == 'YELLOW',
            blink: isYellow,
            pulseT: pulseT,
            blinkT: blinkT,
          ),
          LightDot(
            C.green,
            isOn: phase == 'GREEN',
            blink: false,
            pulseT: pulseT,
            blinkT: blinkT,
          ),
        ],
      ),
    );
  }
}
