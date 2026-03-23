import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/screens/settings/about_app_screen.dart';
import 'package:urban_os/screens/settings/developer_panel_screen.dart';
import 'package:urban_os/screens/settings/help_and_support.dart';
import 'package:urban_os/widgets/system_setting/divider.dart';
import 'package:urban_os/widgets/system_setting/nav_setting.dart';
import 'package:urban_os/widgets/system_setting/setting_section.dart';

typedef C = AppColors;

class InfoSection extends StatelessWidget {
  final void Function(Widget screen) navigateTo;

  const InfoSection({super.key, required this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'INFO & SUPPORT',
      color: C.violet,
      children: [
        NavSetting(
          label: 'Help & Support',
          description: 'FAQs, contact & troubleshooting',
          icon: Icons.help_rounded,
          color: C.violet,
          onTap: () => navigateTo(const HelpAndSupportScreen()),
        ),
        DividerWidget(color: C.violet),
        NavSetting(
          label: 'About App',
          description: 'Version info, credits & changelog',
          icon: Icons.info_outline_rounded,
          color: C.cyan,
          onTap: () => navigateTo(const AboutAppScreen()),
        ),
        DividerWidget(color: C.violet),
        NavSetting(
          label: 'Developer Panel',
          description: 'Advanced diagnostics & debug tools',
          icon: Icons.developer_mode_rounded,
          color: C.green,
          badge: 'DEV',
          onTap: () => navigateTo(const DeveloperPanelScreen()),
        ),
      ],
    );
  }
}
