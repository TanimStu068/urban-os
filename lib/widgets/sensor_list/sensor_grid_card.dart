import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/widgets/sensor_list/battery_bar.dart';
import 'package:urban_os/widgets/sensor_list/live_value.dart';
import 'package:urban_os/widgets/sensor_list/mini_tag.dart';
import 'package:urban_os/widgets/sensor_list/sensor_avatar.dart';
import 'package:urban_os/datamodel/sensor_list_data_model.dart';

typedef T = AppColors;

class SensorGridCard extends StatelessWidget {
  final SensorModel sensor;
  final bool isPinned;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const SensorGridCard({
    super.key,
    required this.sensor,
    required this.isPinned,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final s = sensor;
    final cat = catOf(s.type);
    final currentStateColor = stateColor(s.state);
    final reading = s.latestReading;
    final isAlert = reading?.isAlert ?? false;
    final batPct = s.batteryPercentage ?? 100;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isAlert ? T.red.withOpacity(0.07) : T.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPinned
                ? cat.color.withOpacity(0.5)
                : (isAlert ? T.red.withOpacity(0.3) : T.border),
            width: isPinned ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: avatar + state + alert
            Row(
              children: [
                SensorAvatar(type: s.type, cat: cat, state: s.state, size: 36),
                const Spacer(),
                if (isAlert)
                  Icon(Icons.warning_amber_rounded, color: T.red, size: 16),
                const SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentStateColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: currentStateColor.withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Name
            Text(
              s.name,
              style: const TextStyle(
                color: T.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Type tag
            MiniTag(label: s.type.displayName, color: cat.color),
            const Spacer(),

            // Reading value
            if (reading != null)
              LiveValue(
                value: reading.value,
                unit: reading.unit ?? s.type.unit,
                color: isAlert ? T.red : cat.color,
                fontSize: 22,
              )
            else
              Text(
                '—',
                style: const TextStyle(color: T.textMuted, fontSize: 22),
              ),
            const SizedBox(height: 10),

            // Battery bar
            BatteryBar(percent: batPct),
            const SizedBox(height: 6),

            // District
            Text(
              s.districtId.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(
                color: T.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
