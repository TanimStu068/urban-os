import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/environment_dashboard/cbtn.dart';

typedef C = AppColors;
typedef WeatherChangeCallback = void Function(WeatherType weather);
typedef LiveToggleCallback = void Function(bool liveMode);
typedef AlertTapCallback = void Function();

class DashboardHeader extends StatelessWidget {
  final double glowValue;
  final double pulseValue;
  final double blinkValue;
  final int sensorCount;
  final int districtCount;
  final double cityAqi;
  final WeatherType weather;
  final bool liveMode;
  final int unackAlerts;
  final VoidCallback onBack;
  final WeatherChangeCallback onWeatherChange;
  final LiveToggleCallback onLiveToggle;
  final AlertTapCallback onAlertTap;

  const DashboardHeader({
    super.key,
    required this.glowValue,
    required this.pulseValue,
    required this.blinkValue,
    required this.sensorCount,
    required this.districtCount,
    required this.cityAqi,
    required this.weather,
    required this.liveMode,
    required this.unackAlerts,
    required this.onBack,
    required this.onWeatherChange,
    required this.onLiveToggle,
    required this.onAlertTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(
        [],
      ), // external animations can be used in the callbacks
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.gBdr)),
          boxShadow: [
            BoxShadow(
              color: C.teal.withOpacity(0.04 + glowValue * 0.02),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBack,
              child: CBtn(Icons.arrow_back_ios_rounded, sz: 14),
            ),
            const SizedBox(width: 12),
            // Animated icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.teal.withOpacity(0.10),
                border: Border.all(
                  color: C.teal.withOpacity(0.3 + glowValue * 0.18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: C.teal.withOpacity(0.15 + glowValue * 0.12),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: const Icon(Icons.eco_rounded, color: C.teal, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [C.teal, C.green],
                    ).createShader(b),
                    child: const Text(
                      'ENVIRONMENT COMMAND',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '$sensorCount SENSORS  ·  $districtCount DISTRICTS  ·  ${cityAqi.toStringAsFixed(0)} AQI CITY AVG',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      letterSpacing: 1.8,
                      color: C.mutedLt,
                    ),
                  ),
                ],
              ),
            ),
            // Weather selector
            GestureDetector(
              onTap: () {
                final idx = (weather.index + 1) % WeatherType.values.length;
                onWeatherChange(WeatherType.values[idx]);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: weather.color.withOpacity(0.1),
                  border: Border.all(color: weather.color.withOpacity(0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(weather.icon, color: weather.color, size: 13),
                    const SizedBox(width: 5),
                    Text(
                      weather.label.split(' ').first,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7.5,
                        color: weather.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Live toggle
            GestureDetector(
              onTap: () => onLiveToggle(!liveMode),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: liveMode
                      ? C.green.withOpacity(0.08 + blinkValue * 0.04)
                      : C.bgCard2,
                  border: Border.all(
                    color: liveMode
                        ? C.green.withOpacity(0.4 + blinkValue * 0.15)
                        : C.muted.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: liveMode
                            ? C.green.withOpacity(0.6 + blinkValue * 0.4)
                            : C.muted,
                        boxShadow: liveMode
                            ? [
                                BoxShadow(
                                  color: C.green.withOpacity(0.5),
                                  blurRadius: 6,
                                ),
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      liveMode ? 'LIVE' : 'PAUSED',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        color: liveMode ? C.green : C.mutedLt,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Alert bell
            Stack(
              clipBehavior: Clip.none,
              children: [
                CBtn(
                  Icons.notifications_active_rounded,
                  sz: 15,
                  onTap: onAlertTap,
                ),
                if (unackAlerts > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.red,
                      ),
                      child: Center(
                        child: Text(
                          '$unackAlerts',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
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
