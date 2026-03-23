import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/system_data_model.dart';
import 'package:urban_os/widgets/system/animated_stat_pill.dart';
import 'package:urban_os/widgets/system/stat_pill.dart';

typedef _C = AppColors;

class SystemStats extends StatelessWidget {
  final List<Section> sections;
  final AnimationController hotCtrl;

  const SystemStats({super.key, required this.sections, required this.hotCtrl});

  @override
  Widget build(BuildContext context) {
    final total = sections.fold(0, (a, s) => a + s.entries.length);
    final hotCount = sections
        .expand((s) => s.entries)
        .where((e) => e.isHot)
        .length;
    final liveCount = sections
        .expand((s) => s.entries)
        .where((e) => e.badge == 'LIVE')
        .length;

    // FIX: removed fixed height container — let children determine height naturally
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 2),
      child: Row(
        children: [
          StatPill(
            value: '$total',
            label: 'MODULES',
            icon: Icons.grid_view_rounded,
            color: _C.cyan,
          ),
          const SizedBox(width: 6),
          StatPill(
            value: '${sections.length}',
            label: 'SYSTEMS',
            icon: Icons.category_rounded,
            color: _C.green,
          ),
          const SizedBox(width: 6),
          AnimatedStatPill(
            value: '$hotCount',
            label: 'CRITICAL',
            icon: Icons.warning_amber_rounded,
            color: _C.red,
            ctrl: hotCtrl,
          ),
          const SizedBox(width: 6),
          StatPill(
            value: '$liveCount',
            label: 'LIVE FEEDS',
            icon: Icons.wifi_tethering_rounded,
            color: _C.amber,
          ),
        ],
      ),
    );
  }
}
