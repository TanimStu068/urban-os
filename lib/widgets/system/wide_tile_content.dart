import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/system_data_model.dart';
import 'package:urban_os/widgets/system/category_tag.dart';
import 'package:urban_os/widgets/system/arrow_btn.dart';
import 'package:urban_os/widgets/system/badge_row.dart';
import 'package:urban_os/widgets/system/tile_icon.dart';

typedef _C = AppColors;

class WideTileContent extends StatelessWidget {
  final SystemEntry entry;
  final AnimationController hotCtrl;
  const WideTileContent({
    super.key,
    required this.entry,
    required this.hotCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final e = entry;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TileIcon(entry: e, size: 46, hotCtrl: hotCtrl),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              BadgeRow(entry: e, hotCtrl: hotCtrl),
              const SizedBox(height: 3),
              Text(
                e.label,
                style: const TextStyle(
                  color: _C.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  height: 1.15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                e.sublabel,
                style: const TextStyle(
                  color: _C.textSub,
                  fontSize: 11,
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              CategoryTag(entry: e),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ArrowBtn(color: e.accent, size: 28),
      ],
    );
  }
}
