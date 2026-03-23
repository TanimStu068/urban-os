import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/energy_dashboard/gauge_painter.dart';
import 'package:urban_os/widgets/energy_dashboard/sec_label.dart';
import 'package:urban_os/widgets/energy_dashboard/spark_line_painter.dart';

typedef C = AppColors;

class SourceDetailCard extends StatefulWidget {
  final EnergySourceModel source;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;

  const SourceDetailCard({
    super.key,
    required this.source,
    required this.glowAnimation,
    required this.blinkAnimation,
  });

  @override
  State<SourceDetailCard> createState() => _SourceDetailCardState();
}

class _SourceDetailCardState extends State<SourceDetailCard> {
  late EnergySourceModel s;

  @override
  void initState() {
    super.initState();
    s = widget.source;
  }

  void _toggleActive() {
    setState(() {
      s.isActive = !s.isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.glowAnimation,
        widget.blinkAnimation,
      ]),
      builder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.bgCard.withOpacity(0.9),
          border: Border.all(
            color: s.isActive
                ? s.type.color.withOpacity(
                    0.25 + widget.glowAnimation.value * 0.1,
                  )
                : C.muted.withOpacity(0.15),
            width: s.isActive ? 1.2 : 1,
          ),
          boxShadow: s.isActive
              ? [
                  BoxShadow(
                    color: s.type.color.withOpacity(
                      0.05 + widget.glowAnimation.value * 0.03,
                    ),
                    blurRadius: 16,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: s.type.color.withOpacity(s.isActive ? 0.15 : 0.05),
                    border: Border.all(
                      color: s.type.color.withOpacity(s.isActive ? 0.4 : 0.15),
                    ),
                  ),
                  child: Icon(
                    s.type.icon,
                    color: s.isActive ? s.type.color : C.muted,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.type.label,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: s.isActive ? s.type.color : C.mutedLt,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        '${s.type.label} ENERGY SOURCE  ·  ${s.capacity.toInt()} kW capacity',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7.5,
                          color: C.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                // Toggle
                GestureDetector(
                  onTap: _toggleActive,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: s.isActive
                          ? s.type.color.withOpacity(0.18)
                          : C.bgCard2,
                      border: Border.all(
                        color: s.isActive
                            ? s.type.color.withOpacity(0.5)
                            : C.muted.withOpacity(0.3),
                      ),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 200),
                          left: s.isActive ? 24 : 2,
                          top: 3,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: s.isActive ? s.type.color : C.mutedLt,
                              boxShadow: s.isActive
                                  ? [
                                      BoxShadow(
                                        color: s.type.color.withOpacity(0.5),
                                        blurRadius: 5,
                                      ),
                                    ]
                                  : [],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Active section
            if (s.isActive) ...[
              // Output bar
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${s.output.toStringAsFixed(0)} kW',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: s.type.color,
                                shadows: [
                                  Shadow(
                                    color: s.type.color.withOpacity(0.4),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '/ ${s.capacity.toInt()} kW',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                                color: C.mutedLt,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Stack(
                          children: [
                            Container(
                              height: 14,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: C.bgCard2,
                                border: Border.all(color: C.gBdr),
                              ),
                            ),
                            AnimatedFractionallySizedBox(
                              duration: const Duration(milliseconds: 500),
                              widthFactor: (s.loadPct / 100).clamp(0, 1),
                              child: Container(
                                height: 14,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  gradient: LinearGradient(
                                    colors: [
                                      s.type.color.withOpacity(0.7),
                                      s.type.color,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: s.type.color.withOpacity(
                                        0.3 + widget.glowAnimation.value * 0.1,
                                      ),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  '${s.loadPct.toStringAsFixed(1)}% UTILISATION',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 7,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black45,
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Efficiency gauge
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CustomPaint(
                      painter: GaugePainter(
                        value: s.efficiency,
                        color: s.type.color,
                        glowT: widget.glowAnimation.value,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // History sparkline
              SecLabel('OUTPUT TREND  (24H)'),
              const SizedBox(height: 5),
              SizedBox(
                height: 36,
                child: CustomPaint(
                  painter: SparkLinePainter(
                    data: s.history,
                    color: s.type.color,
                    glowT: widget.glowAnimation.value,
                  ),
                  size: const Size(double.infinity, 36),
                ),
              ),
            ] else
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.power_off_rounded, color: C.mutedLt, size: 14),
                    SizedBox(width: 8),
                    Text(
                      'SOURCE OFFLINE — TAP TOGGLE TO ACTIVATE',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        color: C.mutedLt,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
