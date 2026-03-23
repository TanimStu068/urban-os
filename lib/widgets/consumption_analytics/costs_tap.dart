import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/cost_stat.dart';
import 'package:urban_os/widgets/consumption_analytics/traffislider.dart';
import 'package:urban_os/widgets/consumption_analytics/vdiv.dart';
import 'package:urban_os/widgets/rule_builder/panel.dart';

typedef C = AppColors;

class CostsTab extends StatelessWidget {
  final double tariffPeak;
  final double tariffOffPeak;
  final List<DistrictConsumption> districts;
  final bool showCostMode;
  final double totalCost;

  final Animation<double> glowAnimation;
  final Animation<double> barAnimation;

  final ValueChanged<double> onPeakChanged;
  final ValueChanged<double> onOffPeakChanged;

  const CostsTab({
    super.key,
    required this.tariffPeak,
    required this.tariffOffPeak,
    required this.districts,
    required this.showCostMode,
    required this.totalCost,
    required this.glowAnimation,
    required this.barAnimation,
    required this.onPeakChanged,
    required this.onOffPeakChanged,
  });

  @override
  Widget build(BuildContext context) {
    final blendedRate = (tariffPeak * 0.6 + tariffOffPeak * 0.4);
    final maxCost = districts.isNotEmpty
        ? districts.map((x) => x.cost).reduce(max)
        : 1.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: [
          // ─── TARIFF CONFIG ───
          Panel(
            title: 'TARIFF CONFIGURATION',
            icon: Icons.settings_rounded,
            color: C.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TariffSlider(
                        label: 'PEAK TARIFF',
                        value: tariffPeak,
                        min: 0.05,
                        max: 0.35,
                        color: C.amber,
                        onChanged: onPeakChanged,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TariffSlider(
                        label: 'OFF-PEAK TARIFF',
                        value: tariffOffPeak,
                        min: 0.02,
                        max: 0.20,
                        color: C.cyan,
                        onChanged: onOffPeakChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'BLENDED RATE: \$${blendedRate.toStringAsFixed(3)}/kWh',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    color: C.mutedLt,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ─── COST BREAKDOWN ───
          Panel(
            title: 'COST BREAKDOWN BY DISTRICT',
            icon: Icons.payments_rounded,
            color: C.green,
            child: Column(
              children: districts.map((d) {
                final cost = showCostMode
                    ? d.cost
                    : d.total * tariffPeak * 0.0006;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([glowAnimation, barAnimation]),
                    builder: (_, __) => Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            d.name,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              color: d.color,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: C.bgCard2,
                                  border: Border.all(color: C.gBdr),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor:
                                    (cost / maxCost).clamp(0, 1) *
                                    barAnimation.value,
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: LinearGradient(
                                      colors: [
                                        d.color.withOpacity(0.45),
                                        d.color.withOpacity(0.7),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: d.color.withOpacity(
                                          0.15 + glowAnimation.value * 0.06,
                                        ),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text(
                                      '\$${cost.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 8,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black45,
                                            blurRadius: 2,
                                          ),
                                        ],
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
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // ─── COST SUMMARY ───
          Panel(
            title: 'COST SUMMARY',
            icon: Icons.calculate_rounded,
            color: C.teal,
            child: Row(
              children: [
                CostStat(
                  'DAILY EST.',
                  '\$${(totalCost * 24).toStringAsFixed(0)}',
                  C.amber,
                ),
                VDiv(),
                CostStat(
                  'WEEKLY EST.',
                  '\$${(totalCost * 168).toStringAsFixed(0)}',
                  C.cyan,
                ),
                VDiv(),
                CostStat(
                  'MONTHLY EST.',
                  '\$${(totalCost * 720).toStringAsFixed(0)}',
                  C.green,
                ),
                VDiv(),
                CostStat(
                  'ANNUAL PROJ.',
                  '\$${(totalCost * 8760).toStringAsFixed(0)}',
                  C.violet,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ─── SAVINGS ───
          Panel(
            title: 'SAVINGS OPPORTUNITIES',
            icon: Icons.eco_rounded,
            color: C.lime,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // Keep your existing _SavingRow widgets here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
