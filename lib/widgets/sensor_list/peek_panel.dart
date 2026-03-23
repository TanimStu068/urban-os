import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/datamodel/sensor_list_data_model.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/widgets/sensor_list/detail_tile.dart';
import 'package:urban_os/widgets/sensor_list/live_value.dart';
import 'package:urban_os/widgets/sensor_list/sensor_avatar.dart';

typedef T = AppColors;

class PeekPanel extends StatelessWidget {
  final SensorModel sensor;
  final VoidCallback onClose;
  final VoidCallback onOpen;

  const PeekPanel({
    super.key,
    required this.sensor,
    required this.onClose,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final s = sensor;
    final cat = catOf(s.type);
    final reading = s.latestReading;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onVerticalDragEnd: (d) {
          if (d.primaryVelocity != null && d.primaryVelocity! > 200) {
            onClose();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: T.surfaceHi,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: cat.color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: T.bg.withOpacity(0.85),
                blurRadius: 40,
                offset: const Offset(0, -10),
              ),
              BoxShadow(
                color: cat.color.withOpacity(0.1),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle + close
              Row(
                children: [
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: T.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: T.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: T.border),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: T.textSecondary,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Sensor identity
              Row(
                children: [
                  SensorAvatar(
                    type: s.type,
                    cat: cat,
                    state: s.state,
                    size: 48,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.name,
                          style: const TextStyle(
                            color: T.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.id,
                          style: TextStyle(
                            color: cat.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (reading != null)
                    LiveValue(
                      value: reading.value,
                      unit: reading.unit ?? s.type.unit,
                      color: cat.color,
                      fontSize: 28,
                    ),
                ],
              ),
              const SizedBox(height: 18),

              // Details grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 2.2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  DetailTile(
                    icon: Icons.my_location_rounded,
                    label: 'Location',
                    value: s.location ?? '—',
                  ),
                  DetailTile(
                    icon: Icons.apartment_rounded,
                    label: 'District',
                    value: s.districtId.replaceAll('_', ' '),
                  ),
                  DetailTile(
                    icon: Icons.category_rounded,
                    label: 'Category',
                    value: cat.label,
                  ),
                  DetailTile(
                    icon: Icons.battery_full_rounded,
                    label: 'Battery',
                    value: '${s.batteryPercentage ?? '—'}%',
                  ),
                  DetailTile(
                    icon: Icons.signal_wifi_4_bar_rounded,
                    label: 'Signal',
                    value: '${s.signalStrength ?? '—'} dBm',
                  ),
                  DetailTile(
                    icon: Icons.gps_fixed_rounded,
                    label: 'Coords',
                    value: s.latitude != null
                        ? '${s.latitude!.toStringAsFixed(3)}, ${s.longitude!.toStringAsFixed(3)}'
                        : '—',
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Open detail button
              GestureDetector(
                onTap: onOpen,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cat.color, cat.color.withOpacity(0.6)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: cat.color.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'OPEN SENSOR DETAIL',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.black,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
