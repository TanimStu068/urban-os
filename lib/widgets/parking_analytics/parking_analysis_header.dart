import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/parking_analytics/circle_btn.dart';

typedef C = AppColors;

class ParkingAnalyticsHeader extends StatelessWidget {
  final AnimationController blinkCtrl;
  final List<ParkingLot> lots;
  final VoidCallback? onBack;
  final VoidCallback? onFilter;
  final VoidCallback? onMore;

  const ParkingAnalyticsHeader({
    Key? key,
    required this.blinkCtrl,
    required this.lots,
    this.onBack,
    this.onFilter,
    this.onMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final full = lots.where((l) => l.status == ParkingStatus.full).length;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: C.bgCard.withOpacity(0.92),
        border: Border(bottom: BorderSide(color: C.gBdr)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.maybePop(context),
            child: CircleBtn(Icons.arrow_back_ios_rounded, sz: 14),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [C.cyan, C.teal],
                ).createShader(b),
                child: const Text(
                  'PARKING ANALYTICS',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.5,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'CITY-WIDE  ·  ${lots.length} LOTS  ·  LIVE',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  letterSpacing: 2,
                  color: C.mutedLt,
                ),
              ),
            ],
          ),
          const Spacer(),
          AnimatedBuilder(
            animation: blinkCtrl,
            builder: (_, __) {
              return full > 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: C.red.withOpacity(0.08 + blinkCtrl.value * 0.04),
                        border: Border.all(
                          color: C.red.withOpacity(
                            0.35 + blinkCtrl.value * 0.15,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: C.red.withOpacity(
                                0.6 + blinkCtrl.value * 0.4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: C.red.withOpacity(
                                    0.5 * blinkCtrl.value,
                                  ),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$full FULL',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              letterSpacing: 1.2,
                              color: C.red,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onFilter,
            child: CircleBtn(Icons.filter_list_rounded, sz: 16),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onMore,
            child: CircleBtn(Icons.more_vert_rounded, sz: 18),
          ),
        ],
      ),
    );
  }
}
