import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/system_setting_data_model.dart';
import 'package:urban_os/widgets/system_setting/freqency_selector.dart';
import 'package:urban_os/widgets/system_setting/setting_section.dart';
import 'package:urban_os/widgets/system_setting/toggle_setting.dart';

typedef C = AppColors;

class PerformanceSection extends StatelessWidget {
  final bool lowPowerMode;
  final ValueChanged<bool> onLowPowerModeChanged;
  final DataUpdateFrequency updateFrequency;
  final ValueChanged<DataUpdateFrequency> onFrequencyChanged;

  const PerformanceSection({
    super.key,
    required this.lowPowerMode,
    required this.onLowPowerModeChanged,
    required this.updateFrequency,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'PERFORMANCE',
      color: C.green,
      children: [
        ToggleSetting(
          label: 'Low Power Mode',
          description: lowPowerMode
              ? 'Enabled • Reduces refresh rate'
              : 'Disabled • Reduces refresh rate',
          icon: Icons.battery_saver_rounded,
          value: lowPowerMode,
          color: C.red,
          onChanged: onLowPowerModeChanged,
        ),
        const SizedBox(height: 8),
        FrequencySelector(
          label: 'Data Update Frequency',
          description: 'How often sensor data refreshes',
          selected: updateFrequency,
          onChanged: onFrequencyChanged,
        ),
      ],
    );
  }
}
