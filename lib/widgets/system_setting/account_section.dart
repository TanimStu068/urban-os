import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/screens/settings/delete_account_screen.dart';
import 'package:urban_os/screens/settings/notifications_screen.dart';
import 'package:urban_os/screens/settings/onboarding_screens.dart';
import 'package:urban_os/screens/settings/profile_screen.dart';
import 'package:urban_os/widgets/system_setting/divider.dart';
import 'package:urban_os/widgets/system_setting/nav_setting.dart';
import 'package:urban_os/widgets/system_setting/setting_section.dart';

typedef C = AppColors;

class AccountSection extends StatelessWidget {
  final void Function(Widget screen) navigateTo;

  const AccountSection({super.key, required this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'ACCOUNT',
      color: C.sky,
      children: [
        NavSetting(
          label: 'Profile',
          description: 'Manage your identity & credentials',
          icon: Icons.person_rounded,
          color: C.sky,
          onTap: () => navigateTo(const ProfileScreen()),
        ),
        DividerWidget(color: C.sky),
        NavSetting(
          label: 'Notifications',
          description: 'Alerts, badges & push preferences',
          icon: Icons.notifications_rounded,
          color: C.amber,
          onTap: () => navigateTo(const NotificationScreen()),
        ),
        DividerWidget(color: C.sky),
        NavSetting(
          label: 'Onboarding',
          description: 'Replay the getting-started flow',
          icon: Icons.rocket_launch_rounded,
          color: C.mint,
          onTap: () => navigateTo(const OnboardingScreen()),
        ),
        DividerWidget(color: C.sky),
        NavSetting(
          label: 'Delete Account',
          description: 'Permanently remove your account',
          icon: Icons.delete_forever_rounded,
          color: C.red,
          onTap: () => navigateTo(const DeleteAccountScreen()),
        ),
      ],
    );
  }
}
