import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/sensor_list_data_model.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:flutter/material.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/widgets/sensor_list/grid_body.dart';
import 'package:urban_os/widgets/sensor_list/sensor_list_card.dart';

typedef _T = AppColors;

class SensorBody extends StatelessWidget {
  final List<SensorModel> sensors;
  final ViewMode viewMode;
  final AnimationController entryAnim;
  final ScrollController scrollCtrl;
  final SensorModel? pinnedSensor;
  final ValueChanged<SensorModel> onPin;
  final ValueChanged<SensorModel> onNavigate;

  const SensorBody({
    super.key,
    required this.sensors,
    required this.viewMode,
    required this.entryAnim,
    required this.scrollCtrl,
    required this.pinnedSensor,
    required this.onPin,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    // Group by category for section headers in list mode
    final grouped = <String, List<SensorModel>>{};
    for (final s in sensors) {
      grouped.putIfAbsent(s.type.category, () => []).add(s);
    }

    if (viewMode == ViewMode.grid) {
      return GridBody(
        sensors: sensors,
        entryAnim: entryAnim,
        scrollCtrl: scrollCtrl,
        pinnedSensor: pinnedSensor,
        onPin: onPin,
        onNavigate: onNavigate,
      );
    }

    // ── LIST MODE with category sections ─────────────────────────────────
    final sections = grouped.entries.toList();
    return ListView.builder(
      controller: scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      itemCount: sections.length,
      itemBuilder: (ctx, si) {
        final cat = sections[si].key;
        final list = sections[si].value;
        final meta =
            categoryMeta[cat] ??
            const CatMeta('Other', _T.violet, Icons.device_hub_rounded);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: meta.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: meta.color.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(meta.icon, color: meta.color, size: 12),
                        const SizedBox(width: 6),
                        Text(
                          meta.label.toUpperCase(),
                          style: TextStyle(
                            color: meta.color,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Container(height: 1, color: _T.border)),
                  const SizedBox(width: 10),
                  Text(
                    '${list.length}',
                    style: const TextStyle(
                      color: _T.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Sensor cards
            ...list.asMap().entries.map((e) {
              final idx = e.key;
              final sensor = e.value;
              return AnimatedBuilder(
                animation: entryAnim,
                builder: (_, child) {
                  final delay = (si * list.length + idx) * 0.05;
                  final t = Curves.easeOutCubic.transform(
                    ((entryAnim.value - delay).clamp(0.0, 1.0)),
                  );
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - t)),
                    child: Opacity(opacity: t, child: child),
                  );
                },
                child: SensorListCard(
                  sensor: sensor,
                  isPinned: pinnedSensor?.id == sensor.id,
                  onTap: () => onNavigate(sensor),
                  onLongPress: () => onPin(sensor),
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
