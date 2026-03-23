import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/widgets/parking_analytics/card_widget.dart';
import 'package:urban_os/widgets/parking_analytics/legend_dot.dart';
import 'package:urban_os/widgets/parking_analytics/slot_grid_painter.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SlotGridCard extends StatelessWidget {
  final ParkingLot lot;
  final int liveOcc;
  final AnimationController slotCtrl;
  final AnimationController glowCtrl;
  final AnimationController pulseCtrl;
  final AnimationController blinkCtrl;

  const SlotGridCard({
    Key? key,
    required this.lot,
    required this.liveOcc,
    required this.slotCtrl,
    required this.glowCtrl,
    required this.pulseCtrl,
    required this.blinkCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'PARKING GRID',
      sub: 'Visual slot map — ${lot.totalSpaces} spaces',
      icon: Icons.grid_view_rounded,
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                slotCtrl,
                glowCtrl,
                pulseCtrl,
                blinkCtrl,
              ]),
              builder: (_, __) => CustomPaint(
                painter: SlotGridPainter(
                  total: lot.totalSpaces,
                  occupied: liveOcc,
                  reserved: lot.reserved,
                  disabled: lot.disabled,
                  progress: slotCtrl.value,
                  glowT: glowCtrl.value,
                  pulseT: pulseCtrl.value,
                  color: lot.status.color,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                LegendDot('OCCUPIED', lot.status.color),
                const SizedBox(width: 10),
                LegendDot('AVAILABLE', C.green),
                const SizedBox(width: 10),
                LegendDot('RESERVED', C.violet),
                const SizedBox(width: 10),
                LegendDot('DISABLED', C.mutedLt),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
