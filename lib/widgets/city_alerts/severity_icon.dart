import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_alert_data_model.dart';

typedef C = AppColors;

class SeverityIcon extends StatelessWidget {
  final UISeverity sev;
  final bool acked, isCrit;
  final AnimationController blinkCtrl;
  const SeverityIcon({
    super.key,
    required this.sev,
    required this.acked,
    required this.blinkCtrl,
    required this.isCrit,
  });

  @override
  Widget build(BuildContext context) {
    final color = sev.color;
    return AnimatedBuilder(
      animation: blinkCtrl,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        children: [
          if (isCrit)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity(.15 + blinkCtrl.value * .2),
                  width: 1,
                ),
                color: Colors.transparent,
              ),
            ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: acked
                  ? C.bgCard2
                  : color.withOpacity(
                      .1 + (isCrit ? blinkCtrl.value * .07 : 0),
                    ),
              border: Border.all(
                color: acked ? C.muted.withOpacity(.3) : color.withOpacity(.4),
                width: isCrit ? 1.2 : 1,
              ),
              boxShadow: isCrit
                  ? [
                      BoxShadow(
                        color: color.withOpacity(.25 * blinkCtrl.value),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: Icon(sev.icon, color: acked ? C.muted : color, size: 16),
          ),
        ],
      ),
    );
  }
}
