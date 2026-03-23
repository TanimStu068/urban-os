import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';
import 'package:urban_os/widgets/prediction/legend_dot.dart';
import 'package:urban_os/widgets/prediction/signal_painter.dart';

typedef C = AppColors;

class SignalDetailWidget extends StatelessWidget {
  final Prediction prediction;
  final Animation<double> drawAnimation;

  const SignalDetailWidget({
    super.key,
    required this.prediction,
    required this.drawAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: prediction.level.color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'SIGNAL TRACE · ${prediction.sensorId}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    color: prediction.level.color,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: C.cyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: C.cyan.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'HISTORY + FORECAST',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: C.cyan,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            AnimatedBuilder(
              animation: drawAnimation,
              builder: (_, __) => SizedBox(
                height: 140,
                child: CustomPaint(
                  painter: SignalPainter(prediction, drawAnimation.value),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                LegendDot(C.cyan, 'HISTORY'),
                const SizedBox(width: 12),
                LegendDot(prediction.level.color, 'FORECAST'),
                const SizedBox(width: 12),
                LegendDot(prediction.level.color.withOpacity(0.3), 'CONF BAND'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
