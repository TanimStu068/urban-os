import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/system_data_model.dart';
import 'package:urban_os/widgets/system/category_tag.dart';
import 'package:urban_os/widgets/system/badge_row.dart';
import 'package:urban_os/widgets/system/tile_icon.dart';

typedef _C = AppColors;

class MedTileContent extends StatelessWidget {
  final SystemEntry entry;
  final AnimationController hotCtrl;
  const MedTileContent({super.key, required this.entry, required this.hotCtrl});

  @override
  Widget build(BuildContext context) {
    final e = entry;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TileIcon(entry: e, size: 38, hotCtrl: hotCtrl),
            const SizedBox(width: 6),
            Expanded(
              child: BadgeRow(entry: e, hotCtrl: hotCtrl),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          e.label,
          style: const TextStyle(
            color: _C.text,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          e.sublabel,
          style: const TextStyle(color: _C.textSub, fontSize: 9, height: 1.2),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            CategoryTag(entry: e),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: e.accent.withOpacity(0.6),
              size: 14,
            ),
          ],
        ),
      ],
    );
  }
}
