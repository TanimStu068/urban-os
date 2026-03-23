import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/mini_signal_bar.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class IntersectionListTile extends StatelessWidget {
  final Intersection intersection;
  final bool isSelected;
  final AnimationController glowCtrl, blinkCtrl, pulseCtrl;
  final VoidCallback onTap;

  const IntersectionListTile({
    super.key,
    required this.intersection,
    required this.isSelected,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.pulseCtrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext ctx) {
    final ix = intersection;
    final col = ix.phase.color;
    return AnimatedBuilder(
      animation: Listenable.merge([glowCtrl, blinkCtrl, pulseCtrl]),
      builder: (_, __) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 7),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: isSelected
                ? col.withOpacity(0.07)
                : C.bgCard.withOpacity(0.85),
            border: Border.all(
              color: isSelected
                  ? col.withOpacity(0.4 + glowCtrl.value * 0.1)
                  : C.gBdr,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: col.withOpacity(0.07), blurRadius: 12)]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MiniSignalLight(
                    phase: ix.phase,
                    pulseT: pulseCtrl.value,
                    blinkT: blinkCtrl.value,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      ix.id,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? col : kAccent,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  if (ix.isEmergencyOverride)
                    const Icon(Icons.emergency_rounded, color: C.red, size: 11),
                  if (ix.isAdaptive && !ix.isEmergencyOverride)
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: C.teal.withOpacity(0.7),
                      size: 10,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                ix.name,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: C.white,
                  letterSpacing: 0.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    ix.phase.label,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      fontWeight: FontWeight.w700,
                      color: col,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${ix.timer}s',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: col,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${ix.totalVehicles}/h',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 6.5,
                      color: C.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Stack(
                  children: [
                    Container(height: 3, color: col.withOpacity(0.1)),
                    FractionallySizedBox(
                      widthFactor: ix.phaseProgress.clamp(0.0, 1.0),
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: [col.withOpacity(0.5), col],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
