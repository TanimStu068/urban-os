import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';
import 'package:urban_os/widgets/consumption_analytics/sec_label.dart';

typedef C = AppColors;

class PowerBalancePanel extends StatelessWidget {
  final double totalGeneration;
  final double totalConsumption;
  final double gridLoadPct;
  final Animation<double> glowAnimation;

  const PowerBalancePanel({
    super.key,
    required this.totalGeneration,
    required this.totalConsumption,
    required this.gridLoadPct,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final genFlex =
        (totalGeneration / (totalGeneration + totalConsumption) * 100)
            .toInt()
            .clamp(1, 99);
    final conFlex =
        (totalConsumption / (totalGeneration + totalConsumption) * 100)
            .toInt()
            .clamp(1, 99);
    final isSurplus = totalGeneration >= totalConsumption;

    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, __) => Panel(
        title: 'POWER BALANCE',
        icon: Icons.balance_rounded,
        color: C.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            // Balance Bar
            Row(
              children: [
                // Generation
                Expanded(
                  flex: genFlex,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GEN',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          color: C.green,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(5),
                          ),
                          gradient: const LinearGradient(
                            colors: [C.green, C.teal],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: C.green.withOpacity(
                                0.3 + glowAnimation.value * 0.15,
                              ),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Consumption
                Expanded(
                  flex: conFlex,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'CON',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          color: C.amber,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(5),
                          ),
                          gradient: const LinearGradient(
                            colors: [C.orange, C.amber],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: C.amber.withOpacity(
                                0.3 + glowAnimation.value * 0.15,
                              ),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Big Numbers & Surplus/Deficit
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${(totalGeneration / 1000).toStringAsFixed(2)} MW',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: C.green,
                        ),
                      ),
                      const Text(
                        'TOTAL GENERATION',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          color: C.muted,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: (isSurplus ? C.green : C.red).withOpacity(0.1),
                        border: Border.all(
                          color: (isSurplus ? C.green : C.red).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        isSurplus ? 'SURPLUS' : 'DEFICIT',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: isSurplus ? C.green : C.red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${((totalGeneration - totalConsumption).abs() / 1000).toStringAsFixed(1)} MW',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        color: C.mutedLt,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(totalConsumption / 1000).toStringAsFixed(2)} MW',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: C.amber,
                        ),
                      ),
                      const Text(
                        'TOTAL CONSUMPTION',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          color: C.muted,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Grid Load Indicator
            SecLabel('GRID LOAD'),
            const SizedBox(height: 6),
            Stack(
              children: [
                Container(
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: C.bgCard2,
                    border: Border.all(color: C.gBdr),
                  ),
                ),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 600),
                  widthFactor: (gridLoadPct / 100).clamp(0, 1),
                  child: Container(
                    height: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(
                        colors: gridLoadPct > 90
                            ? [C.orange, C.red]
                            : gridLoadPct > 75
                            ? [C.amber, C.orange]
                            : [C.green, C.teal],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (gridLoadPct > 90 ? C.red : C.amber)
                              .withOpacity(0.3 + glowAnimation.value * 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      '${gridLoadPct.toStringAsFixed(1)}%  GRID UTILISATION',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
