// ═════════════════════════════════════════════════════════════════════════════
//  DRAWER ITEM MODEL
// ═════════════════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

class DrawerItem {
  final String label;
  final IconData icon;
  final Color accent;
  final Widget Function() builder;
  final String? badge; // small text badge e.g. "LIVE", "2"
  final bool isBadgeHot; // pulsing red dot

  const DrawerItem({
    required this.label,
    required this.icon,
    required this.accent,
    required this.builder,
    this.badge,
    this.isBadgeHot = false,
  });
}

class DrawerSection {
  final String title;
  final IconData sectionIcon;
  final Color color;
  final List<DrawerItem> items;

  const DrawerSection({
    required this.title,
    required this.sectionIcon,
    required this.color,
    required this.items,
  });
}
