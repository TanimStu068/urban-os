import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/automation_rule/vdv.dart';
import 'package:urban_os/widgets/environment_dashboard/kpi_cell.dart';
import 'package:urban_os/widgets/environment_dashboard/mini_score_painter.dart';

typedef C = AppColors;
typedef AqiLevelCallback = AqiLevel Function(double aqi);

class EnvScoreStrip extends StatelessWidget {
  final double envScore;
  final double aqiValue;
  final AqiLevelCallback aqiLevel;
  final EnvSensorReading tempSensor;
  final EnvSensorReading humSensor;
  final EnvSensorReading noiseSensor;
  final EnvSensorReading windSensor;
  final double glowValue;
  final double blinkValue;

  const EnvScoreStrip({
    super.key,
    required this.envScore,
    required this.aqiValue,
    required this.aqiLevel,
    required this.tempSensor,
    required this.humSensor,
    required this.noiseSensor,
    required this.windSensor,
    required this.glowValue,
    required this.blinkValue,
  });

  @override
  Widget build(BuildContext context) {
    final lvl = aqiLevel(aqiValue);

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: C.bgCard.withOpacity(0.9),
        border: Border.all(color: C.teal.withOpacity(0.18 + glowValue * 0.08)),
        boxShadow: [
          BoxShadow(
            color: C.teal.withOpacity(0.05 + glowValue * 0.02),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          // Env score gauge mini
          SizedBox(
            width: 48,
            height: 48,
            child: CustomPaint(
              painter: MiniScorePainter(score: envScore, glow: glowValue),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                envScore.toStringAsFixed(0),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: C.teal,
                  shadows: [Shadow(color: C.teal, blurRadius: 8)],
                ),
              ),
              const Text(
                'ENV SCORE',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 6.5,
                  color: C.mutedLt,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const VDiv(),
          KpiCell(
            'CITY AQI',
            aqiValue.toStringAsFixed(0),
            '',
            lvl.color,
            glowValue,
            icon: Icons.air_rounded,
            blink: lvl.index >= 3,
            blinkT: blinkValue,
          ),
          const VDiv(),
          KpiCell(
            'TEMPERATURE',
            tempSensor.value.toStringAsFixed(1),
            '°C',
            tempSensor.statusColor,
            glowValue,
            icon: Icons.thermostat_rounded,
          ),
          const VDiv(),
          KpiCell(
            'HUMIDITY',
            humSensor.value.toStringAsFixed(0),
            '%',
            humSensor.statusColor,
            glowValue,
            icon: Icons.water_drop_rounded,
          ),
          const VDiv(),
          KpiCell(
            'NOISE',
            noiseSensor.value.toStringAsFixed(0),
            'dB',
            noiseSensor.statusColor,
            glowValue,
            icon: Icons.graphic_eq_rounded,
            blink: noiseSensor.isCritical,
            blinkT: blinkValue,
          ),
          const VDiv(),
          KpiCell(
            'WIND',
            windSensor.value.toStringAsFixed(0),
            'km/h',
            C.mint,
            glowValue,
            icon: Icons.air_rounded,
          ),
          const VDiv(),
          // AQI level badge
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: lvl.color.withOpacity(0.12 + blinkValue * 0.04),
                    border: Border.all(
                      color: lvl.color.withOpacity(0.4 + blinkValue * 0.15),
                    ),
                  ),
                  child: Text(
                    lvl.label,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: lvl.color,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
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
