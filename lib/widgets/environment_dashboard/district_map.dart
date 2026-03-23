import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';
import 'package:urban_os/widgets/environment_dashboard/mini_badge.dart';
import 'package:urban_os/widgets/environment_dashboard/pollution_map_painter.dart';

typedef C = AppColors;

AQILevel _aqiLevel(double aqi) {
  if (aqi <= 50) return AQILevel(label: 'Good', color: C.green, index: 0);
  if (aqi <= 100) return AQILevel(label: 'Moderate', color: C.yellow, index: 1);
  if (aqi <= 150) {
    return AQILevel(label: 'Unhealthy', color: C.orange, index: 2);
  }
  if (aqi <= 200) {
    return AQILevel(label: 'Very Unhealthy', color: C.red, index: 3);
  }
  return AQILevel(label: 'Hazardous', color: C.violet, index: 4);
}

class AQILevel {
  final String label;
  final Color color;
  final int index;
  AQILevel({required this.label, required this.color, required this.index});
}

class DistrictPollutionMap extends StatefulWidget {
  final List<DistrictEnvData> districts;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;

  const DistrictPollutionMap({
    super.key,
    required this.districts,
    required this.glowCtrl,
    required this.blinkCtrl,
  });

  @override
  State<DistrictPollutionMap> createState() => _DistrictPollutionMapState();
}

class _DistrictPollutionMapState extends State<DistrictPollutionMap> {
  String? _selectedDistrictId;

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'DISTRICT POLLUTION MAP',
      icon: Icons.map_rounded,
      color: C.teal,
      badge: '${widget.districts.length} ZONES',
      badgeColor: C.teal,
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: AnimatedBuilder(
              animation: Listenable.merge([widget.glowCtrl, widget.blinkCtrl]),
              builder: (_, __) => GestureDetector(
                onTapUp: (details) {
                  final w = MediaQuery.of(context).size.width - 56;
                  for (final dist in widget.districts) {
                    final nx = dist.gridPos.dx * w;
                    final ny = dist.gridPos.dy * 220;
                    if ((details.localPosition - Offset(nx, ny)).distance <
                        28) {
                      setState(
                        () => _selectedDistrictId =
                            _selectedDistrictId == dist.id ? null : dist.id,
                      );
                    }
                  }
                },
                child: CustomPaint(
                  painter: PollutionMapPainter(
                    districts: widget.districts,
                    glow: widget.glowCtrl.value,
                    blink: widget.blinkCtrl.value,
                    selectedId: _selectedDistrictId,
                  ),
                  size: const Size(double.infinity, 220),
                ),
              ),
            ),
          ),
          if (_selectedDistrictId != null) ...[
            const SizedBox(height: 8),
            _buildSelectedDistrictDetail(),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectedDistrictDetail() {
    try {
      final d = widget.districts.firstWhere((x) => x.id == _selectedDistrictId);
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: d.color.withOpacity(0.07),
          border: Border.all(color: d.color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.location_city_rounded, color: d.color, size: 14),
            const SizedBox(width: 8),
            Text(
              d.name,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: d.color,
              ),
            ),
            const Spacer(),
            MiniBadge(
              'AQI ${d.aqi.toStringAsFixed(0)}',
              _aqiLevel(d.aqi).color,
            ),
            const SizedBox(width: 6),
            MiniBadge('${d.temperature.toStringAsFixed(1)}°C', C.amber),
            const SizedBox(width: 6),
            MiniBadge('${d.noise.toStringAsFixed(0)} dB', C.violet),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => setState(() => _selectedDistrictId = null),
              child: const Icon(
                Icons.close_rounded,
                color: C.mutedLt,
                size: 14,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}
