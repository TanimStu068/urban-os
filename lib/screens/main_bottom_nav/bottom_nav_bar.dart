import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/screens/main_bottom_nav/nav_tab.dart';

typedef NavColors = AppColors;

//  BOTTOM NAVIGATION BAR
class UrbanOSBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabChanged;
  final List<NavTab> tabs;
  const UrbanOSBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.tabs,
  });

  @override
  State<UrbanOSBottomNavBar> createState() => _UrbanOSBottomNavBarState();
}

class _UrbanOSBottomNavBarState extends State<UrbanOSBottomNavBar>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late List<AnimationController> _tabControllers;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _tabControllers = List.generate(
      widget.tabs.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    _updateActiveTab(widget.currentIndex);
  }

  void _updateActiveTab(int index) {
    for (int i = 0; i < _tabControllers.length; i++) {
      if (i == index) {
        _tabControllers[i].forward();
      } else {
        _tabControllers[i].reverse();
      }
    }
  }

  @override
  void didUpdateWidget(UrbanOSBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _updateActiveTab(widget.currentIndex);
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    for (var controller in _tabControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleTabTap(int index) {
    if (widget.currentIndex != index) {
      widget.onTabChanged(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: NavColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: NavColors.dashboardColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF051520), Color(0xFF020810)],
              ),
            ),
          ),

          // Animated glow line at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (_, __) => Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      NavColors.dashboardColor.withOpacity(
                        0.3 + _glowController.value * 0.3,
                      ),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: NavColors.dashboardColor.withOpacity(
                        0.2 + _glowController.value * 0.2,
                      ),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Navigation items
          SafeArea(
            bottom: true,
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                widget.tabs.length,
                (index) => NavItem(
                  tab: widget.tabs[index],
                  isActive: widget.currentIndex == index,
                  controller: _tabControllers[index],
                  onTap: () => _handleTabTap(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
