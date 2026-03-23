import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/urban_os_data_model.dart';

typedef _K = AppColors;

class DrawerItemTile extends StatefulWidget {
  final DrawerItem item;
  final Color sectionColor;
  final AnimationController hotCtrl;
  final bool isActive;
  final int delay;
  final VoidCallback onTap;

  const DrawerItemTile({
    super.key,
    required this.item,
    required this.sectionColor,
    required this.hotCtrl,
    required this.isActive,
    required this.delay,
    required this.onTap,
  });

  @override
  State<DrawerItemTile> createState() => _DrawerItemTileState();
}

class _DrawerItemTileState extends State<DrawerItemTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isActive = widget.isActive;
    final isHot = item.isBadgeHot;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) => _pressCtrl.reverse(),
      onTapCancel: () => _pressCtrl.reverse(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pressCtrl, widget.hotCtrl]),
        builder: (_, child) {
          return Transform.scale(
            scale: 1.0 - _pressCtrl.value * 0.02,
            child: child,
          );
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 2, 12, 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: isActive
                ? item.accent.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? item.accent.withOpacity(0.4)
                  : Colors.transparent,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: item.accent.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Left accent bar (active only)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 3,
                height: 28,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isActive ? item.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: item.accent.withOpacity(0.6),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              ),

              // Icon
              AnimatedBuilder(
                animation: widget.hotCtrl,
                builder: (_, __) => Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: (isHot && !isActive)
                        ? item.accent.withOpacity(
                            0.08 + widget.hotCtrl.value * 0.06,
                          )
                        : item.accent.withOpacity(isActive ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: isHot
                          ? item.accent.withOpacity(
                              0.25 + widget.hotCtrl.value * 0.2,
                            )
                          : item.accent.withOpacity(isActive ? 0.35 : 0.15),
                    ),
                    boxShadow: (isHot || isActive)
                        ? [
                            BoxShadow(
                              color: item.accent.withOpacity(
                                isHot
                                    ? 0.15 + widget.hotCtrl.value * 0.12
                                    : 0.15,
                              ),
                              blurRadius: 10,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    item.icon,
                    color: item.accent.withOpacity(isActive ? 1 : 0.8),
                    size: 17,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Label
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: isActive ? _K.text : _K.text.withOpacity(0.75),
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ),

              // Badge
              if (item.badge != null || item.isBadgeHot)
                AnimatedBuilder(
                  animation: widget.hotCtrl,
                  builder: (_, __) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: item.accent.withOpacity(
                        item.isBadgeHot
                            ? 0.12 + widget.hotCtrl.value * 0.08
                            : 0.1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: item.accent.withOpacity(
                          item.isBadgeHot
                              ? 0.3 + widget.hotCtrl.value * 0.2
                              : 0.25,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.isBadgeHot) ...[
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: item.accent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: item.accent.withOpacity(0.7),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        if (item.badge != null)
                          Text(
                            item.badge!,
                            style: TextStyle(
                              color: item.accent,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              // Active arrow indicator
              if (isActive) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.chevron_right_rounded,
                  color: item.accent.withOpacity(0.7),
                  size: 16,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
