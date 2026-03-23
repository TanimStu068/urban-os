import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/sensor/sensor_state.dart';
import 'package:urban_os/widgets/sensor_list/stat_tile.dart';

typedef _T = AppColors;

class StatsBar extends StatelessWidget {
  final int total, online, alerts, offline, lowBat;
  final ValueChanged<SensorState?> onFilterState;
  final SensorState? activeState;

  const StatsBar({
    super.key,
    required this.total,
    required this.online,
    required this.alerts,
    required this.offline,
    required this.lowBat,
    required this.onFilterState,
    required this.activeState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            StatTile(
              label: 'TOTAL',
              value: '$total',
              color: _T.cyan,
              icon: Icons.sensors_rounded,
              active: activeState == null,
              onTap: () => onFilterState(null),
            ),
            const SizedBox(width: 8),
            StatTile(
              label: 'ONLINE',
              value: '$online',
              color: _T.green,
              icon: Icons.wifi_rounded,
              active: activeState == SensorState.online,
              onTap: () => onFilterState(SensorState.online),
            ),
            const SizedBox(width: 8),
            StatTile(
              label: 'ALERTS',
              value: '$alerts',
              color: _T.red,
              icon: Icons.warning_amber_rounded,
              active: false,
              onTap: () {},
            ),
            const SizedBox(width: 8),
            StatTile(
              label: 'OFFLINE',
              value: '$offline',
              color: _T.orange,
              icon: Icons.wifi_off_rounded,
              active: activeState == SensorState.offline,
              onTap: () => onFilterState(SensorState.offline),
            ),
            const SizedBox(width: 8),
            StatTile(
              label: 'LOW BAT',
              value: '$lowBat',
              color: _T.amber,
              icon: Icons.battery_alert_rounded,
              active: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
