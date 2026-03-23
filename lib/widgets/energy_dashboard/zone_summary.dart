import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/energy_dashboard/sort_pill.dart';
import 'package:urban_os/widgets/energy_dashboard/section_title.dart';
import 'package:urban_os/widgets/energy_dashboard/zone_card.dart';

typedef C = AppColors;

class ZoneSummary extends StatelessWidget {
  final List<PowerZone> zones;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;
  final String zoneSort;
  final int selectedZone;
  final void Function(String sortKey) onSortChanged;
  final void Function(int index) onZoneSelected;

  const ZoneSummary({
    super.key,
    required this.zones,
    required this.glowAnimation,
    required this.blinkAnimation,
    required this.zoneSort,
    required this.selectedZone,
    required this.onSortChanged,
    required this.onZoneSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...zones];
    switch (zoneSort) {
      case 'load':
        sorted.sort((a, b) => b.loadPct.compareTo(a.loadPct));
        break;
      case 'name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'status':
        sorted.sort((a, b) => b.status.index.compareTo(a.status.index));
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SectionTitle('ZONE STATUS  (${zones.length})', C.amber),
            const Spacer(),
            SortPill('LOAD', zoneSort == 'load', () => onSortChanged('load')),
            const SizedBox(width: 5),
            SortPill('NAME', zoneSort == 'name', () => onSortChanged('name')),
            const SizedBox(width: 5),
            SortPill(
              'STATUS',
              zoneSort == 'status',
              () => onSortChanged('status'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.4,
          ),
          itemCount: sorted.length,
          itemBuilder: (_, i) => AnimatedBuilder(
            animation: Listenable.merge([glowAnimation, blinkAnimation]),
            builder: (_, __) => ZoneCard(
              zone: sorted[i],
              isSelected: selectedZone == i,
              glowT: glowAnimation.value,
              blinkT: blinkAnimation.value,
              onTap: () => onZoneSelected(selectedZone == i ? -1 : i),
            ),
          ),
        ),
      ],
    );
  }
}
