import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';

class ActuatorCard extends StatelessWidget {
  final SimActuator actuator;
  final double glowT, blinkT;
  const ActuatorCard({
    super.key,
    required this.actuator,
    required this.glowT,
    required this.blinkT,
  });

  @override
  Widget build(BuildContext ctx) {
    final col = actuator.triggered ? C.violet : C.muted;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: actuator.triggered
            ? C.violet.withOpacity(0.08 + glowT * 0.04)
            : C.bgCard2.withOpacity(0.4),
        border: Border.all(
          color: actuator.triggered
              ? C.violet.withOpacity(0.35 + blinkT * 0.1)
              : C.muted.withOpacity(0.15),
          width: actuator.triggered ? 1.2 : 1,
        ),
        boxShadow: actuator.triggered
            ? [
                BoxShadow(
                  color: C.violet.withOpacity(0.1 + blinkT * 0.05),
                  blurRadius: 10,
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: actuator.triggered
                      ? C.violet.withOpacity(0.7 + blinkT * 0.3)
                      : C.muted,
                  boxShadow: actuator.triggered
                      ? [
                          BoxShadow(
                            color: C.violet.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ]
                      : [],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                actuator.id,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: col,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            actuator.triggered ? 'TRIGGERED' : 'STANDBY',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              color: actuator.triggered ? C.white : C.mutedLt,
            ),
          ),
          if (actuator.triggerCount > 0) ...[
            const SizedBox(height: 4),
            Text(
              '${actuator.triggerCount}× fired',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 7,
                color: C.mutedLt,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
