import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/district_list_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/district/district_type.dart';
import 'package:urban_os/widgets/district_list/action_btn.dart';
import 'package:urban_os/widgets/district_list/detail_chip.dart';
import 'package:urban_os/widgets/district_list/health_ring_painter.dart';
import 'package:urban_os/widgets/district_list/mini_bar.dart';

class DistrictCard extends StatefulWidget {
  final DistrictModel district;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;
  final Animation<double> pulseAnimation;
  final Function(DistrictModel) openDetails;
  final Function(DistrictModel) openAnalysis;
  final VoidCallback openMap;

  const DistrictCard({
    super.key,
    required this.district,
    required this.glowAnimation,
    required this.blinkAnimation,
    required this.pulseAnimation,
    required this.openDetails,
    required this.openAnalysis,
    required this.openMap,
  });

  @override
  State<DistrictCard> createState() => _DistrictCardState();
}

class _DistrictCardState extends State<DistrictCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.district;
    final health = d.healthPercentage;
    final isCritical = d.metrics.hasCriticalIssues;
    final col = healthColor(health);
    final typeCol = typeColor(d.type);

    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.glowAnimation,
        widget.blinkAnimation,
        widget.pulseAnimation,
      ]),
      builder: (_, __) => GestureDetector(
        onTap: () => setState(() => isExpanded = !isExpanded),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: C.bgCard.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isCritical
                  ? C.red.withOpacity(0.35 + widget.blinkAnimation.value * 0.12)
                  : isExpanded
                  ? C.cyan.withOpacity(0.4 + widget.glowAnimation.value * 0.1)
                  : C.gBdr,
              width: isExpanded ? 1.2 : 1.0,
            ),
            boxShadow: isCritical
                ? [BoxShadow(color: C.red.withOpacity(0.06), blurRadius: 12)]
                : isExpanded
                ? [BoxShadow(color: C.cyan.withOpacity(0.04), blurRadius: 16)]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Card header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  children: [
                    // Health ring
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: CustomPaint(
                        painter: HealthRingPainter(
                          health / 100,
                          col,
                          widget.pulseAnimation.value,
                        ),
                        child: Center(
                          child: Text(
                            '${health.toInt()}',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 10,
                              color: col,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Name + info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  d.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: C.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (isCritical)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: C.red.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                      color: C.red.withOpacity(0.4),
                                    ),
                                  ),
                                  child: const Text(
                                    'CRITICAL',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 6.5,
                                      color: C.red,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: typeCol.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  d.type.displayName,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 7.5,
                                    color: typeCol,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                d.id,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 7.5,
                                  color: C.mutedLt,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Quick stats
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.sensors_rounded,
                              color: C.cyan,
                              size: 10,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${d.sensorCount}',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9,
                                color: C.cyan,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.bolt_rounded, color: C.amber, size: 10),
                            const SizedBox(width: 3),
                            Text(
                              '${d.actuatorCount}',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9,
                                color: C.amber,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        if (d.metrics.activeIncidents > 0)
                          Row(
                            children: [
                              Icon(
                                Icons.report_rounded,
                                color: C.red,
                                size: 10,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${d.metrics.activeIncidents}',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 9,
                                  color: C.red,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isExpanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: C.mutedLt,
                      size: 16,
                    ),
                  ],
                ),
              ),

              // ── Metric mini-bars ──
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Row(
                  children: [
                    MiniBar('TRAFFIC', d.metrics.averageTraffic, C.amber),
                    const SizedBox(width: 6),
                    MiniBar('SAFETY', d.metrics.safetyScore, C.green),
                    const SizedBox(width: 6),
                    MiniBar(
                      'AQI',
                      (100 - d.metrics.airQualityIndex.clamp(0, 100)),
                      C.cyan,
                    ),
                  ],
                ),
              ),

              // ── Expanded section ──
              if (isExpanded) ...[
                Container(height: 1, color: C.gBdr),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      if (d.description != null) ...[
                        Text(
                          d.description!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            color: C.mutedLt,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],

                      // Details grid
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (d.population != null)
                            DetailChip(
                              Icons.people_rounded,
                              'POP',
                              fmtNum(d.population!),
                              C.violet,
                            ),
                          if (d.areaKm2 != null)
                            DetailChip(
                              Icons.square_foot_rounded,
                              'AREA',
                              '${d.areaKm2!.toStringAsFixed(1)} km²',
                              C.cyan,
                            ),
                          if (d.populationDensity != null)
                            DetailChip(
                              Icons.density_medium_rounded,
                              'DENSITY',
                              '${d.populationDensity!.toStringAsFixed(0)}/km²',
                              C.mutedLt,
                            ),
                          if (d.sustainabilityScore != null)
                            DetailChip(
                              Icons.eco_rounded,
                              'SUSTAIN',
                              '${d.sustainabilityScore!.toStringAsFixed(0)}%',
                              C.green,
                            ),
                          if (d.metrics.averageTemperature != null)
                            DetailChip(
                              Icons.thermostat_rounded,
                              'TEMP',
                              '${d.metrics.averageTemperature!.toStringAsFixed(1)}°C',
                              C.amber,
                            ),
                          if (d.metrics.noiseLevelDb != null)
                            DetailChip(
                              Icons.volume_up_rounded,
                              'NOISE',
                              '${d.metrics.noiseLevelDb!.toStringAsFixed(0)} dB',
                              C.red,
                            ),
                          if (d.metrics.renewableEnergyPercent != null)
                            DetailChip(
                              Icons.energy_savings_leaf_rounded,
                              'RENEW',
                              '${d.metrics.renewableEnergyPercent!.toStringAsFixed(0)}%',
                              C.green,
                            ),
                          DetailChip(
                            Icons.power_rounded,
                            'ENERGY',
                            '${d.metrics.energyConsumption.toStringAsFixed(1)} MWh',
                            C.amber,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Action row
                      Row(
                        children: [
                          ActionBtn(
                            'DETAILS',
                            Icons.info_outline_rounded,
                            C.cyan,
                            () => widget.openDetails(d),
                          ),
                          const SizedBox(width: 6),
                          ActionBtn(
                            'ANALYSIS',
                            Icons.bar_chart_rounded,
                            C.violet,
                            () => widget.openAnalysis(d),
                          ),
                          const SizedBox(width: 6),
                          ActionBtn(
                            'MAP',
                            Icons.map_rounded,
                            C.green,
                            widget.openMap,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
