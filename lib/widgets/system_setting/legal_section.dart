import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/screens/settings/privacy_and_policy_screen.dart';
import 'package:urban_os/screens/settings/term_and_condition_screen.dart';
import 'package:urban_os/widgets/system_setting/divider.dart';
import 'package:urban_os/widgets/system_setting/nav_setting.dart';
import 'package:urban_os/widgets/system_setting/setting_section.dart';

typedef C = AppColors;

class LegalSection extends StatelessWidget {
  final void Function(Widget screen) navigateTo;

  const LegalSection({super.key, required this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'LEGAL',
      color: C.mutedLt,
      children: [
        NavSetting(
          label: 'Privacy Policy',
          description: 'How we handle your data',
          icon: Icons.shield_rounded,
          color: C.red,
          onTap: () => navigateTo(const PrivacyAndPolicyScreen()),
        ),
        DividerWidget(color: C.mutedLt),
        NavSetting(
          label: 'Terms & Conditions',
          description: 'Usage rules & agreements',
          icon: Icons.gavel_rounded,
          color: C.amber,
          onTap: () => navigateTo(const TermAndConditionScreen()),
        ),
      ],
    );
  }
}
