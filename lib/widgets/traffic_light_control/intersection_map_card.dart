import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/card_widget.dart';
import 'package:urban_os/widgets/traffic_light_control/intersection_map_painter.dart';

class IntersectionMapCard extends StatelessWidget {
  final Intersection ix;
  final AnimationController glowCtrl;
  final AnimationController pulseCtrl;
  final AnimationController blinkCtrl;

  const IntersectionMapCard({
    Key? key,
    required this.ix,
    required this.glowCtrl,
    required this.pulseCtrl,
    required this.blinkCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'INTERSECTION MAP',
      sub: 'Real-time flow',
      icon: Icons.map_rounded,
      child: SizedBox(
        height: 160,
        child: AnimatedBuilder(
          animation: Listenable.merge([glowCtrl, pulseCtrl, blinkCtrl]),
          builder: (_, __) => CustomPaint(
            painter: IntersectionMapPainter(
              ix: ix,
              glowT: glowCtrl.value,
              pulseT: pulseCtrl.value,
              blinkT: blinkCtrl.value,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}
