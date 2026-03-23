import 'package:flutter/material.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/widgets/sensor_list/sensor_grid_card.dart';

class GridBody extends StatelessWidget {
  final List<SensorModel> sensors;
  final AnimationController entryAnim;
  final ScrollController scrollCtrl;
  final SensorModel? pinnedSensor;
  final ValueChanged<SensorModel> onPin;
  final ValueChanged<SensorModel> onNavigate;

  const GridBody({
    super.key,
    required this.sensors,
    required this.entryAnim,
    required this.scrollCtrl,
    required this.pinnedSensor,
    required this.onPin,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.82,
      ),
      itemCount: sensors.length,
      itemBuilder: (ctx, i) {
        final sensor = sensors[i];
        return AnimatedBuilder(
          animation: entryAnim,
          builder: (_, child) {
            final delay = i * 0.04;
            final t = Curves.easeOutCubic.transform(
              ((entryAnim.value - delay).clamp(0.0, 1.0)),
            );
            return Transform.translate(
              offset: Offset(0, 16 * (1 - t)),
              child: Opacity(opacity: t, child: child),
            );
          },
          child: SensorGridCard(
            sensor: sensor,
            isPinned: pinnedSensor?.id == sensor.id,
            onTap: () => onNavigate(sensor),
            onLongPress: () => onPin(sensor),
          ),
        );
      },
    );
  }
}
