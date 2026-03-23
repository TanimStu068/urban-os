import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/environment_dashboard/mini_badge.dart';
import 'package:urban_os/widgets/environment_dashboard/radial_gauge_painter.dart';
import 'package:urban_os/widgets/environment_dashboard/spark_fill.dart';

typedef C = AppColors;

class SensorDetailCard extends StatelessWidget {
  final EnvSensorReading sensor;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;

  const SensorDetailCard({
    super.key,
    required this.sensor,
    required this.glowCtrl,
    required this.blinkCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowCtrl, blinkCtrl]),
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.bgCard.withOpacity(0.9),
          border: Border.all(
            color: sensor.statusColor.withOpacity(0.25 + glowCtrl.value * 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: sensor.statusColor.withOpacity(
                0.05 + glowCtrl.value * 0.03,
              ),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header row
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: sensor.color.withOpacity(0.12),
                    border: Border.all(color: sensor.color.withOpacity(0.3)),
                  ),
                  child: Icon(sensor.icon, color: sensor.color, size: 13),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    sensor.name,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: sensor.color,
                    ),
                  ),
                ),
                MiniBadge(
                  sensor.isCritical
                      ? 'CRIT'
                      : sensor.isWarning
                      ? 'WARN'
                      : 'OK',
                  sensor.statusColor,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Radial gauge
            SizedBox(
              height: 70,
              child: CustomPaint(
                painter: RadialGaugePainter(
                  value: sensor.normalizedValue,
                  color: sensor.statusColor,
                  glow: glowCtrl.value,
                  label: '${sensor.value.toStringAsFixed(1)} ${sensor.unit}',
                ),
                size: const Size(double.infinity, 70),
              ),
            ),
            const SizedBox(height: 6),

            // Mini sparkline
            SizedBox(
              height: 28,
              child: CustomPaint(
                painter: SparkFill(
                  data: sensor.history24h,
                  color: sensor.color,
                  glow: glowCtrl.value,
                  dangerLine: sensor.thresholdWarn / sensor.max,
                ),
                size: const Size(double.infinity, 28),
              ),
            ),
            const SizedBox(height: 4),

            // Min / Warn / Max row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MIN: ${sensor.min.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6.5,
                    color: C.muted,
                  ),
                ),
                Text(
                  'WARN: ${sensor.thresholdWarn.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6.5,
                    color: C.amber,
                  ),
                ),
                Text(
                  'MAX: ${sensor.max.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6.5,
                    color: C.muted,
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
