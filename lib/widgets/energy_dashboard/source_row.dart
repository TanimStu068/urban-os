import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';

typedef C = AppColors;

class SourceRow extends StatelessWidget {
  final EnergySourceModel source;
  final double glowT;

  const SourceRow({super.key, required this.source, required this.glowT});

  @override
  Widget build(BuildContext ctx) {
    final pct = source.loadPct;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: source.type.color.withOpacity(
                source.isActive ? 0.12 : 0.04,
              ),
              border: Border.all(
                color: source.type.color.withOpacity(
                  source.isActive ? 0.3 : 0.1,
                ),
              ),
            ),
            child: Icon(
              source.type.icon,
              color: source.isActive ? source.type.color : C.muted,
              size: 13,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source.type.label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    color: source.isActive ? source.type.color : C.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${source.output.toStringAsFixed(0)} kW',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: source.isActive ? C.mutedLt : C.muted,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: C.bgCard2,
                    border: Border.all(color: C.gBdr),
                  ),
                ),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 500),
                  widthFactor: source.isActive ? (pct / 100).clamp(0, 1) : 0,
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: source.type.color.withOpacity(0.55),
                      boxShadow: [
                        BoxShadow(
                          color: source.type.color.withOpacity(
                            0.2 + glowT * 0.1,
                          ),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        source.isActive ? '${pct.toStringAsFixed(0)}%' : 'OFF',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                          color: C.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
