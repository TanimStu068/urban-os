import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/weather_simulation_data_model.dart';

typedef C = AppColors;

class WeatherAlertsWidget extends StatelessWidget {
  final List<WeatherAlert> alerts;
  final void Function(WeatherAlert) onDismiss;

  const WeatherAlertsWidget({
    super.key,
    required this.alerts,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final activeAlerts = alerts.where((a) => !a.dismissed).toList();
    if (activeAlerts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'WEATHER ALERTS',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: C.yellow,
              letterSpacing: 1.5,
            ),
          ),
        ),
        ...activeAlerts.map(
          (alert) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: alert.severity.withOpacity(0.1),
                border: Border.all(color: alert.severity.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Icon(alert.icon, color: alert.severity, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.title,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: alert.severity,
                          ),
                        ),
                        Text(
                          alert.description,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7,
                            color: C.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onDismiss(alert),
                    child: Icon(
                      Icons.close_rounded,
                      color: alert.severity,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
