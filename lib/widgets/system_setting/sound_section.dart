import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/system_setting/setting_section.dart';
import 'package:urban_os/widgets/system_setting/slider_setting.dart';
import 'package:urban_os/widgets/system_setting/toggle_setting.dart';

typedef C = AppColors;

class SoundSection extends StatelessWidget {
  final bool soundsEnabled;
  final ValueChanged<bool> onSoundsChanged;
  final double volumeLevel;
  final ValueChanged<double> onVolumeChanged;
  final bool hapticFeedbackEnabled;
  final ValueChanged<bool> onHapticChanged;
  final AnimationController sliderCtrl;

  const SoundSection({
    super.key,
    required this.soundsEnabled,
    required this.onSoundsChanged,
    required this.volumeLevel,
    required this.onVolumeChanged,
    required this.hapticFeedbackEnabled,
    required this.onHapticChanged,
    required this.sliderCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'SOUND & HAPTICS',
      color: C.orange,
      children: [
        ToggleSetting(
          label: 'Audio Feedback',
          description: soundsEnabled ? 'Enabled' : 'Disabled',
          icon: Icons.volume_up_rounded,
          value: soundsEnabled,
          color: C.orange,
          onChanged: onSoundsChanged,
        ),
        const SizedBox(height: 8),
        SliderSetting(
          label: 'Volume',
          value: volumeLevel,
          min: 0,
          max: 1,
          icon: Icons.volume_down_rounded,
          color: C.orange,
          onChanged: onVolumeChanged,
          sliderCtrl: sliderCtrl,
        ),
        const SizedBox(height: 8),
        ToggleSetting(
          label: 'Haptic Feedback',
          description: hapticFeedbackEnabled ? 'Enabled' : 'Disabled',
          icon: Icons.vibration_rounded,
          value: hapticFeedbackEnabled,
          color: C.pink,
          onChanged: onHapticChanged,
        ),
      ],
    );
  }
}
