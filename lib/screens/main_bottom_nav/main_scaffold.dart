import 'package:flutter/material.dart';
import 'package:urban_os/screens/analytics/charts_trends_screen.dart';
import 'package:urban_os/screens/automation/automation_rule_list_screen.dart';
import 'package:urban_os/screens/dashboard/city_dashboard_screen.dart';
import 'package:urban_os/screens/districts/district_list_screen.dart';
import 'package:urban_os/screens/main_bottom_nav/bottom_nav_bar.dart';
import 'package:urban_os/screens/main_bottom_nav/nav_tab.dart';
import 'package:urban_os/screens/side_bar_drawer/urbanos_drawer.dart';
import 'package:urban_os/screens/systems/system_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final List<NavTab> tabs = [
    NavTab(
      icon: Icons.dashboard_rounded,
      label: 'DASHBOARD',
      color: NavColors.dashboardColor,
      screen: const CityDashboardScreen(),
    ),
    NavTab(
      icon: Icons.map_rounded,
      label: 'DISTRICTS',
      color: NavColors.districtsColor,
      screen: const DistrictListScreen(),
    ),
    NavTab(
      icon: Icons.settings_remote_rounded,
      label: 'SYSTEMS',
      color: NavColors.systemsColor,
      screen: const SystemScreen(),
    ),
    NavTab(
      icon: Icons.auto_awesome_rounded,
      label: 'AUTOMATION',
      color: NavColors.automationColor,
      screen: const AutomationRuleListScreen(),
    ),
    NavTab(
      icon: Icons.analytics_rounded,
      label: 'ANALYTICS',
      color: NavColors.analyticsColor,
      screen: const ChartsTrendsScreen(),
    ),
  ];

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavColors.bg,
      drawer: const UrbanOSDrawer(activeLabel: 'City Health Score'),
      body: IndexedStack(
        index: _currentIndex,
        children: tabs.map((tab) => tab.screen).toList(),
      ),
      bottomNavigationBar: UrbanOSBottomNavBar(
        currentIndex: _currentIndex,
        onTabChanged: _onTabChange,
        tabs: tabs,
      ),
    );
  }
}
