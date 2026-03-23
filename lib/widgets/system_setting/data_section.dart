import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/system_setting/setting_section.dart';
import 'package:urban_os/widgets/system_setting/toggle_setting.dart';

typedef C = AppColors;

class DataSection extends StatelessWidget {
  final bool locationServicesEnabled;
  final ValueChanged<bool> onLocationChanged;
  final bool dataCollectionEnabled;
  final ValueChanged<bool> onDataCollectionChanged;

  const DataSection({
    super.key,
    required this.locationServicesEnabled,
    required this.onLocationChanged,
    required this.dataCollectionEnabled,
    required this.onDataCollectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'DATA & PRIVACY',
      color: C.red,
      children: [
        ToggleSetting(
          label: 'Location Services',
          description: locationServicesEnabled ? 'Enabled' : 'Disabled',
          icon: Icons.location_on_rounded,
          value: locationServicesEnabled,
          color: C.red,
          onChanged: onLocationChanged,
        ),
        const SizedBox(height: 8),
        ToggleSetting(
          label: 'Data Collection',
          description: dataCollectionEnabled
              ? 'Sharing • Analytics'
              : 'Not sharing • Analytics',
          icon: Icons.analytics_rounded,
          value: dataCollectionEnabled,
          color: C.violet,
          onChanged: onDataCollectionChanged,
        ),
      ],
    );
  }
}
