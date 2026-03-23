import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/profile/stat_item.dart';
import 'package:urban_os/widgets/profile/section_header.dart';
import 'package:urban_os/widgets/profile/info_row.dart';
import 'package:urban_os/widgets/profile/toggle_item.dart';
import 'package:urban_os/datamodel/profile_screen_data_model.dart';

typedef C = AppColors;

class SecurityView extends StatefulWidget {
  final UserProfile user;
  final ScrollController scrollController;

  const SecurityView({
    super.key,
    required this.user,
    required this.scrollController,
  });

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  late UserProfile _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ACCOUNT INFO
          SectionHeader('ACCOUNT INFORMATION'),
          const SizedBox(height: 8),
          InfoRow(label: 'User ID', value: _user.id, color: C.cyan),
          const SizedBox(height: 6),
          InfoRow(label: 'Email', value: _user.email, color: C.teal),
          const SizedBox(height: 6),
          InfoRow(label: 'Phone', value: _user.contactPhone, color: C.mint),
          const SizedBox(height: 6),
          InfoRow(label: 'Bio', value: _user.bio, color: C.sky),

          const SizedBox(height: 16),

          // SECURITY SETTINGS
          SectionHeader('SECURITY SETTINGS'),
          const SizedBox(height: 8),
          ToggleItem(
            label: 'Two-Factor Authentication',
            description:
                '${_user.twoFactorEnabled ? 'Enabled' : 'Disabled'} • Authenticator App',
            icon: Icons.shield_rounded,
            isEnabled: _user.twoFactorEnabled,
            color: _user.twoFactorEnabled ? C.green : C.orange,
            onToggle: () {}, // keep empty or wire later
          ),

          const SizedBox(height: 6),

          ToggleItem(
            label: 'Push Notifications',
            description:
                '${_user.notificationsEnabled ? 'Enabled' : 'Disabled'} • Login & Security',
            icon: Icons.notifications_active_rounded,
            isEnabled: _user.notificationsEnabled,
            color: _user.notificationsEnabled ? C.cyan : C.mutedLt,
            onToggle: () {
              setState(() {
                _user.notificationsEnabled = !_user.notificationsEnabled;
              });
            },
          ),

          const SizedBox(height: 16),

          // ACCOUNT ACTIVITY
          SectionHeader('ACCOUNT ACTIVITY'),
          const SizedBox(height: 8),
          StatItem(
            label: 'Days Active',
            value: _user.daysActive,
            icon: Icons.calendar_today_rounded,
            color: C.yellow,
          ),
          const SizedBox(height: 6),
          StatItem(
            label: 'Login Streak',
            value: '${_user.loginStreak} days',
            icon: Icons.local_fire_department_rounded,
            color: C.red,
          ),
          const SizedBox(height: 6),
          StatItem(
            label: 'Total Logins',
            value: _user.totalLogins.toString(),
            icon: Icons.login_rounded,
            color: C.green,
          ),
          const SizedBox(height: 6),
          StatItem(
            label: 'Last Login',
            value: '${_user.hoursSinceLogin}h ago',
            icon: Icons.access_time_rounded,
            color: C.cyan,
          ),
        ],
      ),
    );
  }
}
