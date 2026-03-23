import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/system_setting/setting_section.dart';
import 'package:urban_os/widgets/system_setting/slider_setting.dart';
import 'package:urban_os/widgets/system_setting/toggle_setting.dart';

typedef C = AppColors;

class DisplaySection extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final double brightnessLevel;
  final ValueChanged<double> onBrightnessChanged;
  final bool animationsEnabled;
  final ValueChanged<bool> onAnimationsChanged;
  final AnimationController sliderCtrl;

  const DisplaySection({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
    required this.brightnessLevel,
    required this.onBrightnessChanged,
    required this.animationsEnabled,
    required this.onAnimationsChanged,
    required this.sliderCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'DISPLAY',
      color: C.cyan,
      children: [
        ToggleSetting(
          label: 'Dark Mode',
          description: darkMode ? 'Enabled' : 'Disabled',
          icon: Icons.dark_mode_rounded,
          value: darkMode,
          color: C.cyan,
          onChanged: onDarkModeChanged,
        ),
        const SizedBox(height: 8),
        SliderSetting(
          label: 'Brightness',
          value: brightnessLevel,
          min: 0,
          max: 1,
          icon: Icons.brightness_6_rounded,
          color: C.yellow,
          onChanged: onBrightnessChanged,
          sliderCtrl: sliderCtrl,
        ),
        const SizedBox(height: 8),
        ToggleSetting(
          label: 'Animations',
          description: animationsEnabled ? 'Enabled' : 'Disabled',
          icon: Icons.animation_rounded,
          value: animationsEnabled,
          color: C.mint,
          onChanged: onAnimationsChanged,
        ),
      ],
    );
  }
}
