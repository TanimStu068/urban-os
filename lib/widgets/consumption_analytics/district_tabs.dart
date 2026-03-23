import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/chip_btn.dart';
import 'package:urban_os/widgets/consumption_analytics/sort_pill.dart';
import 'package:urban_os/widgets/consumption_analytics/district_card.dart';

typedef C = AppColors;

class DistrictsTab extends StatelessWidget {
  final List<DistrictConsumption> districts;
  final String? selectedDistrictId;

  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;
  final Animation<double> barAnim;

  final VoidCallback onResetSelection;
  final Function(DistrictConsumption d) onDistrictTap;

  const DistrictsTab({
    super.key,
    required this.districts,
    required this.selectedDistrictId,
    required this.onResetSelection,
    required this.onDistrictTap,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.barAnim,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: [
          _buildTopBar(),
          const SizedBox(height: 10),

          /// District cards
          ...districts.map(
            (d) => DistrictCard(
              d: d,
              isSelected: selectedDistrictId == d.id,
              onTap: () => onDistrictTap(d),
              glowCtrl: glowCtrl,
              blinkCtrl: blinkCtrl,
              barAnim: barAnim,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- TOP BAR ----------------
  Widget _buildTopBar() {
    return Row(
      children: [
        const Text(
          'SORT:',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            color: C.mutedLt,
          ),
        ),
        const SizedBox(width: 8),

        SortPill('CONSUMPTION', true, () {}),
        const SizedBox(width: 5),
        SortPill('CHANGE', false, () {}),
        const SizedBox(width: 5),
        SortPill('COST', false, () {}),

        const Spacer(),

        ChipBtn(
          'DRILL DOWN',
          selectedDistrictId != null,
          onResetSelection,
          C.amber,
        ),
      ],
    );
  }
}
