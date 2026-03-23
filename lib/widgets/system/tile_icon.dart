import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/system_data_model.dart';

class TileIcon extends StatelessWidget {
  final SystemEntry entry;
  final double size;
  final AnimationController hotCtrl;
  const TileIcon({
    super.key,
    required this.entry,
    required this.size,
    required this.hotCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: hotCtrl,
      builder: (_, __) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: entry.accent.withOpacity(
            entry.isHot ? 0.12 + hotCtrl.value * 0.08 : 0.1,
          ),
          borderRadius: BorderRadius.circular(size * 0.3),
          border: Border.all(
            color: entry.accent.withOpacity(
              entry.isHot ? 0.35 + hotCtrl.value * 0.2 : 0.25,
            ),
          ),
          boxShadow: entry.isHot
              ? [
                  BoxShadow(
                    color: entry.accent.withOpacity(0.2 + hotCtrl.value * 0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Icon(entry.icon, color: entry.accent, size: size * 0.46),
      ),
    );
  }
}
