import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/system_data_model.dart';
import 'package:urban_os/widgets/system/med_tile_content.dart';
import 'package:urban_os/widgets/system/wide_tile_content.dart';

typedef _C = AppColors;

class SystemTile extends StatefulWidget {
  final SystemEntry entry;
  final AnimationController hotCtrl;
  final VoidCallback onTap;
  final bool isWide;

  const SystemTile({
    super.key,
    required this.entry,
    required this.hotCtrl,
    required this.onTap,
    this.isWide = false,
  });

  @override
  State<SystemTile> createState() => _SystemTileState();
}

class _SystemTileState extends State<SystemTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final isHot = e.isHot;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        _press.forward();
        HapticFeedback.selectionClick();
      },
      onTapUp: (_) => _press.reverse(),
      onTapCancel: () => _press.reverse(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_press, widget.hotCtrl]),
        builder: (_, child) {
          final scale = 1.0 - _press.value * 0.025;
          return Transform.scale(scale: scale, child: child);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          // FIX: use fixed heights that both wide and medium tiles can fill
          height: widget.isWide ? 100 : 160,
          decoration: BoxDecoration(
            color: isHot ? e.accent.withOpacity(0.07) : _C.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isHot
                  ? e.accent.withOpacity(0.25 + widget.hotCtrl.value * 0.25)
                  : _C.border,
              width: isHot ? 1.5 : 1,
            ),
            boxShadow: isHot
                ? [
                    BoxShadow(
                      color: e.accent.withOpacity(
                        0.1 + widget.hotCtrl.value * 0.08,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(18),
                  ),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topRight,
                        radius: 1,
                        colors: [
                          e.accent.withOpacity(0.12),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -8,
                left: -8,
                child: Opacity(
                  opacity: 0.04,
                  child: Icon(
                    Icons.hexagon_outlined,
                    color: e.accent,
                    size: 70,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: widget.isWide
                    ? WideTileContent(entry: e, hotCtrl: widget.hotCtrl)
                    : MedTileContent(entry: e, hotCtrl: widget.hotCtrl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
