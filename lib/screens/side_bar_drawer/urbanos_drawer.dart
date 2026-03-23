import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/auth/auth_provider.dart';
import 'package:urban_os/screens/auth/login_screen.dart';

// ── Screen imports ────────────────────────────────────────────────────────────
import 'package:urban_os/screens/dashboard/alerts_screen.dart';
import 'package:urban_os/screens/dashboard/city_health_screen.dart';
import 'package:urban_os/screens/safety/emergency_control_system.dart';
import 'package:urban_os/screens/safety/fire_monitoring_screen.dart';
import 'package:urban_os/screens/safety/cctv_activity_screen.dart';
import 'package:urban_os/screens/logs/event_logs_screen.dart';
import 'package:urban_os/screens/logs/alert_history_screen.dart';
import 'package:urban_os/screens/simulation/scenario_builder_screen.dart';
import 'package:urban_os/screens/simulation/event_injection_screen.dart';
import 'package:urban_os/screens/settings/profile_screen.dart';
import 'package:urban_os/screens/settings/system_settings_screen.dart';
import 'package:urban_os/screens/settings/developer_panel_screen.dart';
import 'package:urban_os/datamodel/urban_os_data_model.dart';
import 'package:urban_os/widgets/urbanos_drawer/grid_overlay_painter.dart';
import 'package:urban_os/widgets/urbanos_drawer/scan_line.dart';
import 'package:urban_os/widgets/urbanos_drawer/drawer_bg.dart';
import 'package:urban_os/widgets/urbanos_drawer/section_block.dart';
import 'package:urban_os/widgets/urbanos_drawer/slide_route.dart';
import 'package:urban_os/widgets/urbanos_drawer/drawer_header.dart';

// ═════════════════════════════════════════════════════════════════════════════
//  DESIGN TOKENS
// ═════════════════════════════════════════════════════════════════════════════
typedef _K = AppColors;

typedef C = AppColors;

// ═════════════════════════════════════════════════════════════════════════════
//  URBAN OS DRAWER
// ═════════════════════════════════════════════════════════════════════════════
class UrbanOSDrawer extends StatefulWidget {
  /// The currently active route label — highlights the matching item.
  final String? activeLabel;

  const UrbanOSDrawer({super.key, this.activeLabel});

  @override
  State<UrbanOSDrawer> createState() => _UrbanOSDrawerState();
}

class _UrbanOSDrawerState extends State<UrbanOSDrawer>
    with TickerProviderStateMixin {
  // ── controllers ─────────────────────────────────────────────────────────
  late final AnimationController _bgPulse;
  late final AnimationController _entryCtrl;
  late final AnimationController _hotCtrl;
  late final AnimationController _orbitCtrl;
  late final AnimationController _scanCtrl;

  // ── expanded section state ───────────────────────────────────────────
  final Set<int> _expanded = {0, 1, 2, 3, 4, 5, 6};

  // ── section data (exact order as specified) ──────────────────────────
  late final List<DrawerSection> _sections;

  @override
  void initState() {
    super.initState();

    _bgPulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _hotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _sections = _buildSections();
  }

  @override
  void dispose() {
    _bgPulse.dispose();
    _entryCtrl.dispose();
    _hotCtrl.dispose();
    _orbitCtrl.dispose();
    _scanCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────
  //  SECTION DEFINITIONS  (exact order from spec)
  // ─────────────────────────────────────────────────────────────────────
  List<DrawerSection> _buildSections() => [
    // ── 0: CITY MONITORING ──────────────────────────────────────────
    DrawerSection(
      title: 'City Monitoring',
      sectionIcon: Icons.monitor_heart_rounded,
      color: _K.cyan,
      items: [
        DrawerItem(
          label: 'Real-Time Alerts',
          icon: Icons.notifications_active_rounded,
          accent: _K.red,
          builder: () => const RealTimeAlertsScreen(),
          badge: 'LIVE',
          isBadgeHot: true,
        ),
        DrawerItem(
          label: 'City Health Score',
          icon: Icons.favorite_rounded,
          accent: _K.cyan,
          builder: () => const CityHealthScreen(),
        ),
      ],
    ),

    // ── 1: SAFETY & EMERGENCY ────────────────────────────────────────
    DrawerSection(
      title: 'Safety & Emergency',
      sectionIcon: Icons.security_rounded,
      color: _K.red,
      items: [
        DrawerItem(
          label: 'Emergency Center',
          icon: Icons.emergency_rounded,
          accent: _K.red,
          builder: () => const EmergencyControlSystemScreen(),
          badge: 'HOT',
          isBadgeHot: true,
        ),
        DrawerItem(
          label: 'Fire Monitoring',
          icon: Icons.local_fire_department_rounded,
          accent: _K.orange,
          builder: () => const FireMonitoringScreen(),
          isBadgeHot: true,
        ),
        DrawerItem(
          label: 'CCTV Activity',
          icon: Icons.videocam_rounded,
          accent: _K.violet,
          builder: () => const CCTVActivityScreen(),
        ),
      ],
    ),

    // ── 2: SYSTEM LOGS ───────────────────────────────────────────────
    DrawerSection(
      title: 'System Logs',
      sectionIcon: Icons.receipt_long_rounded,
      color: _K.violet,
      items: [
        DrawerItem(
          label: 'Event Logs',
          icon: Icons.list_alt_rounded,
          accent: _K.violet,
          builder: () => const EventLogsScreen(),
        ),
        DrawerItem(
          label: 'Alert History',
          icon: Icons.history_rounded,
          accent: _K.amber,
          builder: () => const AlertHistoryScreen(),
        ),
      ],
    ),

    // ── 3: SIMULATION ────────────────────────────────────────────────
    DrawerSection(
      title: 'Simulation',
      sectionIcon: Icons.science_rounded,
      color: _K.rose,
      items: [
        DrawerItem(
          label: 'Scenario Builder',
          icon: Icons.schema_rounded,
          accent: _K.rose,
          builder: () => const ScenarioBuilderScreen(),
          badge: 'LAB',
        ),
        DrawerItem(
          label: 'Event Injection',
          icon: Icons.play_circle_rounded,
          accent: _K.blue,
          builder: () => const EventInjectionScreen(),
        ),
      ],
    ),

    // ── 4: USER ──────────────────────────────────────────────────────
    DrawerSection(
      title: 'User',
      sectionIcon: Icons.person_rounded,
      color: _K.green,
      items: [
        DrawerItem(
          label: 'Profile',
          icon: Icons.manage_accounts_rounded,
          accent: _K.green,
          builder: () => const ProfileScreen(),
        ),
        DrawerItem(
          label: 'Logout',
          icon: Icons.logout_rounded,
          accent: _K.red, // red accent for warning
          builder: () => Container(), // we’ll handle via dialog, not navigation
        ),
      ],
    ),

    // ── 5: SETTINGS ──────────────────────────────────────────────────
    DrawerSection(
      title: 'Settings',
      sectionIcon: Icons.settings_rounded,
      color: _K.blue,
      items: [
        DrawerItem(
          label: 'System Settings',
          icon: Icons.tune_rounded,
          accent: _K.cyan,
          builder: () => const SystemSettingsScreen(),
        ),
      ],
    ),

    // ── 6: DEVELOPER ─────────────────────────────────────────────────
    DrawerSection(
      title: 'Developer',
      sectionIcon: Icons.code_rounded,
      color: _K.amber,
      items: [
        DrawerItem(
          label: 'Developer Panel',
          icon: Icons.terminal_rounded,
          accent: _K.amber,
          builder: () => const DeveloperPanelScreen(),
          badge: 'DEV',
        ),
      ],
    ),
  ];
  void _go(BuildContext ctx, DrawerItem item) {
    HapticFeedback.selectionClick();
    Navigator.pop(ctx); // close drawer first

    if (item.label == 'Logout') {
      _showFuturisticLogoutDialog(ctx); // <-- call the dialog
    } else {
      Navigator.push(ctx, SlideRoute(builder: item.builder));
    }
  }

  Future<void> _showFuturisticLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: C.bgCard3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [C.bgCard3, C.bgCard2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: C.teal.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_rounded, color: C.red, size: 36),
              const SizedBox(height: 12),
              const Text(
                'Logout from UrbanOS?',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: C.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to logout from your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: C.mutedLt,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel Button
                  GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: C.teal, width: 1.2),
                        gradient: LinearGradient(
                          colors: [C.bgCard2, C.bgCard3],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: C.teal.withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          color: C.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // Logout Button
                  GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [C.red, C.red.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: C.red.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          color: C.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      await context.read<AppAuthProvider>().logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: _K.drawerWidth,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // ── Animated background ─────────────────────────────────
          DrawerBg(pulse: _bgPulse),

          // ── Grid overlay ────────────────────────────────────────
          GridOverlay(),

          // ── Scan line ───────────────────────────────────────────
          ScanLine(ctrl: _scanCtrl),

          // ── Main scrollable content ──────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Header
                DrawerHeaderWidget(
                  orbitCtrl: _orbitCtrl,
                  hotCtrl: _hotCtrl,
                  entryCtrl: _entryCtrl,
                ),

                // Divider
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        _K.cyan.withOpacity(0.3),
                        _K.cyan.withOpacity(0.5),
                        _K.cyan.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Scrollable sections
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 40),
                    children: [
                      ..._sections.asMap().entries.map((entry) {
                        final i = entry.key;
                        final sec = entry.value;
                        final isExpanded = _expanded.contains(i);

                        return AnimatedBuilder(
                          animation: _entryCtrl,
                          builder: (_, child) {
                            final delay = i * 0.08;
                            final t = Curves.easeOutCubic.transform(
                              (((_entryCtrl.value - delay).clamp(0.0, 1.0))),
                            );
                            return Transform.translate(
                              offset: Offset(-20 * (1 - t), 0),
                              child: Opacity(
                                opacity: t.clamp(0.0, 1.0),
                                child: child,
                              ),
                            );
                          },
                          child: SectionBlock(
                            section: sec,
                            index: i,
                            isExpanded: isExpanded,
                            hotCtrl: _hotCtrl,
                            activeLabel: widget.activeLabel,
                            onToggle: () => setState(() {
                              if (isExpanded) {
                                _expanded.remove(i);
                              } else {
                                _expanded.add(i);
                              }
                            }),
                            onItemTap: (item) => _go(context, item),
                          ),
                        );
                      }),

                      // Bottom version tag
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: _K.cyan.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'UrbanOS v1.0.0 — Build 2025',
                              style: TextStyle(
                                color: _K.textDim,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
