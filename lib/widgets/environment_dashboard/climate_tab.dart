import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';
import 'package:urban_os/widgets/environment_dashboard/climate_chart_painter.dart';
import 'package:urban_os/widgets/environment_dashboard/sensor_detail_card.dart';

typedef C = AppColors;

class ClimateTab extends StatelessWidget {
  final EnvSensorReading tempSensor;
  final EnvSensorReading humSensor;
  final EnvSensorReading rainfallSensor;
  final EnvSensorReading uvSensor;
  final EnvSensorReading co2Sensor;
  final List<HourlyEnvPoint> hourlyData;
  final List<DistrictEnvData> districts;
  final AnimationController glowCtrl;
  final AnimationController barAnim;

  const ClimateTab({
    super.key,
    required this.tempSensor,
    required this.humSensor,
    required this.rainfallSensor,
    required this.uvSensor,
    required this.co2Sensor,
    required this.hourlyData,
    required this.districts,
    required this.glowCtrl,
    required this.barAnim,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: [
          // Temperature & humidity gauges
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SensorDetailCard(
                  sensor: tempSensor,
                  glowCtrl: glowCtrl,
                  blinkCtrl: glowCtrl,
                ),
              ), // Use your new SensorDetailCard
              const SizedBox(width: 10),
              Expanded(
                child: SensorDetailCard(
                  sensor: humSensor,
                  glowCtrl: glowCtrl,
                  blinkCtrl: glowCtrl,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Rainfall + UV + CO2
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SensorDetailCard(
                  sensor: rainfallSensor,
                  glowCtrl: glowCtrl,
                  blinkCtrl: glowCtrl,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SensorDetailCard(
                  sensor: uvSensor,
                  glowCtrl: glowCtrl,
                  blinkCtrl: glowCtrl,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SensorDetailCard(
                  sensor: co2Sensor,
                  glowCtrl: glowCtrl,
                  blinkCtrl: glowCtrl,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Multi-line climate chart
          Panel(
            title: 'CLIMATE PARAMETERS (24H)',
            icon: Icons.multiline_chart_rounded,
            color: C.amber,
            child: SizedBox(
              height: 140,
              child: AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => CustomPaint(
                  painter: ClimateChartPainter(
                    data: hourlyData,
                    glow: glowCtrl.value,
                  ),
                  size: const Size(double.infinity, 140),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // District temperature map
          Panel(
            title: 'TEMPERATURE BY DISTRICT',
            icon: Icons.thermostat_rounded,
            color: C.amber,
            child: Column(
              children: districts
                  .map(
                    (d) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AnimatedBuilder(
                        animation: Listenable.merge([glowCtrl, barAnim]),
                        builder: (_, __) {
                          final norm = (d.temperature - 20) / 20;
                          final col = Color.lerp(
                            C.cyan,
                            C.red,
                            norm.clamp(0, 1),
                          )!;
                          return Row(
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
                                      height: 16,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: C.bgCard2,
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor:
                                          norm.clamp(0, 1) * barAnim.value,
                                      child: Container(
                                        height: 16,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              C.cyan.withOpacity(0.5),
                                              col,
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: col.withOpacity(
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
                                          padding: const EdgeInsets.only(
                                            right: 6,
                                          ),
                                          child: Text(
                                            '${d.temperature.toStringAsFixed(1)}°C',
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
                          );
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
