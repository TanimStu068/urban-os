import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/system_setting/setting_section.dart';
import 'package:urban_os/widgets/system_setting/toggle_setting.dart';

typedef C = AppColors;

class SystemSection extends StatelessWidget {
  final bool automaticUpdatesEnabled;
  final ValueChanged<bool> onAutomaticUpdatesChanged;
  final VoidCallback onAppVersionTap;

  const SystemSection({
    super.key,
    required this.automaticUpdatesEnabled,
    required this.onAutomaticUpdatesChanged,
    required this.onAppVersionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'SYSTEM',
      color: C.teal,
      children: [
        ToggleSetting(
          label: 'Automatic Updates',
          description: automaticUpdatesEnabled ? 'Enabled' : 'Disabled',
          icon: Icons.system_update_rounded,
          value: automaticUpdatesEnabled,
          color: C.teal,
          onChanged: onAutomaticUpdatesChanged,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onAppVersionTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: C.bgCard.withOpacity(0.85),
              border: Border.all(color: C.teal.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: C.teal.withOpacity(0.15),
                  ),
                  child: const Center(
                    child: Icon(Icons.info_rounded, color: C.teal, size: 14),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'App Version',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7.5,
                          color: C.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '2.1.0 (Build 2024.03.07)',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 6.5,
                          color: C.mutedLt,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: C.teal,
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
