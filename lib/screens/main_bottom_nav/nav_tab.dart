import 'package:flutter/material.dart';

class NavTab {
  final IconData icon;
  final String label;
  final Color color;
  final Widget screen;

  NavTab({
    required this.icon,
    required this.label,
    required this.color,
    required this.screen,
  });
}

class NavItem extends StatelessWidget {
  final NavTab tab;
  final bool isActive;
  final AnimationController controller;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.tab,
    required this.isActive,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final scale = 0.8 + controller.value * 0.2;
            final iconScale = 1.0 + controller.value * 0.15;
            final opacity = 0.5 + controller.value * 0.5;
            final glowRadius = 8 + controller.value * 12;

            return Stack(
              alignment: Alignment.center,
              children: [
                // Glow background (appears when active)
                if (controller.value > 0.1)
                  Container(
                    width: 60,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tab.color.withOpacity((controller.value * 0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: tab.color.withOpacity(0.3 * controller.value),
                          blurRadius: glowRadius,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),

                // Content
                Transform.scale(
                  scale: scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon container with border
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: tab.color.withOpacity(opacity),
                            width: 1.5,
                          ),
                          boxShadow: [
                            if (controller.value > 0.3)
                              BoxShadow(
                                color: tab.color.withOpacity(
                                  controller.value * 0.4,
                                ),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                          ],
                        ),
                        child: Transform.scale(
                          scale: iconScale,
                          child: Icon(
                            tab.icon,
                            color: tab.color.withOpacity(opacity),
                            size: 22,
                          ),
                        ),
                      ),

                      const SizedBox(height: 1),

                      // Label
                      Flexible(
                        child: Text(
                          tab.label,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            letterSpacing: 1.5,
                            color: tab.color.withOpacity(opacity),
                            fontWeight: controller.value > 0.5
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                // Active indicator line
                if (controller.value > 0.2)
                  Positioned(
                    bottom: 2,
                    child: Container(
                      width: 28 * controller.value,
                      height: 2,
                      decoration: BoxDecoration(
                        color: tab.color,
                        borderRadius: BorderRadius.circular(1),
                        boxShadow: [
                          BoxShadow(
                            color: tab.color.withOpacity(
                              0.6 * controller.value,
                            ),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
