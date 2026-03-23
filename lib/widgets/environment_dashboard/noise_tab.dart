import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/environment_dashboard/noise_wave_form_painter.dart';
import 'package:urban_os/widgets/environment_dashboard/panel.dart';
import 'package:urban_os/widgets/environment_dashboard/noise_hour_bar_painter.dart';
import 'package:urban_os/widgets/environment_dashboard/single_line_painter.dart';
import 'package:urban_os/widgets/environment_dashboard/wval.dart';

typedef C = AppColors;

class NoiseTab extends StatelessWidget {
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;
  final Animation<double> barAnimation;

  final double noiseSensor;
  final List districts;
  final List<double> hourly;

  const NoiseTab({
    super.key,
    required this.glowAnimation,
    required this.blinkAnimation,
    required this.barAnimation,
    required this.noiseSensor,
    required this.districts,
    required this.hourly,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: [
          /// =======================
          /// BIG NOISE WAVEFORM
          /// =======================
          Panel(
            title: 'CITY NOISE MONITOR',
            icon: Icons.graphic_eq_rounded,
            color: C.violet,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      glowAnimation,
                      blinkAnimation,
                    ]),
                    builder: (_, __) => CustomPaint(
                      painter: NoiseWaveformPainter(
                        value: noiseSensor,
                        glow: glowAnimation.value,
                        animT: blinkAnimation.value,
                      ),
                      size: const Size(double.infinity, 100),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                /// VALUES
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    WVal(
                      'CURRENT',
                      noiseSensor.toStringAsFixed(1),
                      'dB',
                      C.violet,
                    ),
                    WVal(
                      'PEAK',
                      (noiseSensor * 1.12).toStringAsFixed(1),
                      'dB',
                      C.red,
                    ),
                    WVal(
                      'AVG',
                      (noiseSensor * 0.88).toStringAsFixed(1),
                      'dB',
                      C.amber,
                    ),
                    WVal('LIMIT', '70', 'dB', C.mutedLt),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// =======================
          /// NOISE BY DISTRICT
          /// =======================
          Panel(
            title: 'NOISE BY DISTRICT',
            icon: Icons.bar_chart_rounded,
            color: C.violet,
            child: Column(
              children: districts.map((d) {
                final noiseCol = d.noise > 80
                    ? C.red
                    : d.noise > 70
                    ? C.amber
                    : C.green;

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

                        /// BAR
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: C.bgCard2,
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor:
                                    ((d.noise - 30) / 70 * barAnimation.value)
                                        .clamp(0, 1),
                                child: Container(
                                  height: 18,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: LinearGradient(
                                      colors: [
                                        noiseCol.withOpacity(0.5),
                                        noiseCol,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: noiseCol.withOpacity(
                                          0.2 + glowAnimation.value * 0.08,
                                        ),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// LIMIT LINE (70 dB)
                              Positioned(
                                left:
                                    (40 / 70) *
                                    (MediaQuery.of(context).size.width - 120),
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 1.5,
                                  color: C.amber.withOpacity(0.4),
                                ),
                              ),

                              /// VALUE TEXT
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Text(
                                      '${d.noise.toStringAsFixed(0)} dB',
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 7.5,
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

          /// =======================
          /// 24H TREND
          /// =======================
          Panel(
            title: 'NOISE TREND (24H)',
            icon: Icons.show_chart_rounded,
            color: C.violet,
            child: SizedBox(
              height: 100,
              child: AnimatedBuilder(
                animation: glowAnimation,
                builder: (_, __) => CustomPaint(
                  painter: SingleLinePainter(
                    data: hourly,
                    color: C.violet,
                    glow: glowAnimation.value,
                    label: 'dB',
                    dangerLine: 70,
                    dangerColor: C.amber,
                  ),
                  size: const Size(double.infinity, 100),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// =======================
          /// HEATMAP
          /// =======================
          Panel(
            title: 'NOISE INTENSITY BY HOUR',
            icon: Icons.grid_4x4_rounded,
            color: C.violet,
            child: SizedBox(
              height: 48,
              child: AnimatedBuilder(
                animation: glowAnimation,
                builder: (_, __) => CustomPaint(
                  painter: NoiseHourBarPainter(
                    data: hourly,
                    glow: glowAnimation.value,
                  ),
                  size: const Size(double.infinity, 48),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
