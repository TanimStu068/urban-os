import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/environment_dashboard/panel.dart';
import 'package:urban_os/widgets/environment_dashboard/big_aqi_gauge_painter.dart';
import 'package:urban_os/widgets/environment_dashboard/mini_badge.dart';
import 'package:urban_os/widgets/environment_dashboard/pollutant_row_card.dart';
import 'package:urban_os/widgets/environment_dashboard/single_line_painter.dart';

typedef C = AppColors;

class AirQualityTab extends StatelessWidget {
  final double cityAqi;
  final List<Pollutant> pollutants;
  final List<DistrictEnvData> districts;
  final List<HourlyEnvPoint> hourly;
  final AnimationController glowCtrl;
  final AnimationController barAnim;
  final AnimationController blinkCtrl;
  final AqiLevel Function(double) aqiLevel;

  const AirQualityTab({
    super.key,
    required this.cityAqi,
    required this.pollutants,
    required this.districts,
    required this.hourly,
    required this.glowCtrl,
    required this.barAnim,
    required this.blinkCtrl,
    required this.aqiLevel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: [
          // Big AQI gauge
          Panel(
            title: 'AIR QUALITY INDEX',
            icon: Icons.air_rounded,
            color: aqiLevel(cityAqi).color,
            child: SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => CustomPaint(
                  painter: BigAqiGaugePainter(
                    aqi: cityAqi,
                    glow: glowCtrl.value,
                  ),
                  size: const Size(double.infinity, 200),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Pollutants detail
          Panel(
            title: 'POLLUTANT BREAKDOWN',
            icon: Icons.science_rounded,
            color: C.lime,
            child: Column(
              children: pollutants
                  .map(
                    (p) => PollutantRowCard(
                      pollutant: p,
                      glowCtrl: glowCtrl,
                      blinkCtrl: blinkCtrl,
                      barAnim: barAnim,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),

          // AQI by district
          Panel(
            title: 'AQI BY DISTRICT',
            icon: Icons.bar_chart_rounded,
            color: C.teal,
            child: Column(
              children: districts.map((d) {
                final lvl = aqiLevel(d.aqi);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([glowCtrl, barAnim]),
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
                                height: 18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: C.bgCard2,
                                  border: Border.all(color: C.gBdr),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: (d.aqi / 200 * barAnim.value)
                                    .clamp(0, 1),
                                child: Container(
                                  height: 18,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: LinearGradient(
                                      colors: [
                                        lvl.color.withOpacity(0.5),
                                        lvl.color,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: lvl.color.withOpacity(
                                          0.2 + glowCtrl.value * 0.08,
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
                                    padding: const EdgeInsets.only(right: 7),
                                    child: Text(
                                      '${d.aqi.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 8,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black54,
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
                        const SizedBox(width: 7),
                        MiniBadge(lvl.label.split(' ').first, lvl.color),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // AQI trend 24h
          Panel(
            title: 'AQI TREND (24H)',
            icon: Icons.show_chart_rounded,
            color: C.teal,
            child: SizedBox(
              height: 100,
              child: AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => CustomPaint(
                  painter: SingleLinePainter(
                    data: hourly.map((h) => h.aqi).toList(),
                    color: C.teal,
                    glow: glowCtrl.value,
                    label: 'AQI',
                    dangerLine: 100,
                    dangerColor: C.amber,
                  ),
                  size: const Size(double.infinity, 100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
