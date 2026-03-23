import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/urban_os_data_model.dart';
import 'package:urban_os/widgets/urbanos_drawer/drawer_item_tile.dart';

typedef _K = AppColors;

class SectionBlock extends StatelessWidget {
  final DrawerSection section;
  final int index;
  final bool isExpanded;
  final AnimationController hotCtrl;
  final String? activeLabel;
  final VoidCallback onToggle;
  final void Function(DrawerItem) onItemTap;

  const SectionBlock({
    super.key,
    required this.section,
    required this.index,
    required this.isExpanded,
    required this.hotCtrl,
    required this.activeLabel,
    required this.onToggle,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header tap target
        GestureDetector(
          onTap: onToggle,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Row(
              children: [
                // Colored section icon
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: section.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: section.color.withOpacity(0.25)),
                  ),
                  child: Icon(
                    section.sectionIcon,
                    color: section.color,
                    size: 13,
                  ),
                ),
                const SizedBox(width: 10),

                // Label
                Expanded(
                  child: Text(
                    section.title.toUpperCase(),
                    style: TextStyle(
                      color: section.color,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                // Item count
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: section.color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${section.items.length}',
                    style: TextStyle(
                      color: section.color.withOpacity(0.7),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Expand/collapse chevron
                AnimatedRotation(
                  turns: isExpanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: section.color.withOpacity(0.5),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Animated items expansion
        AnimatedCrossFade(
          firstChild: Column(
            children: section.items.asMap().entries.map((e) {
              return DrawerItemTile(
                item: e.value,
                sectionColor: section.color,
                hotCtrl: hotCtrl,
                isActive: activeLabel == e.value.label,
                delay: e.key,
                onTap: () => onItemTap(e.value),
              );
            }).toList(),
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 280),
          sizeCurve: Curves.easeInOutCubic,
        ),

        // Section bottom rule
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Container(height: 1, color: _K.border.withOpacity(0.7)),
        ),
      ],
    );
  }
}
