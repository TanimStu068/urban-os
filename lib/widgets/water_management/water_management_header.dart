import 'package:flutter/material.dart';
import 'water_management_models.dart';
import 'water_management_shared.dart';

class WaterManagementHeader extends StatelessWidget {
  final bool liveData;
  final int critUnacked;
  final VoidCallback onBack;
  final VoidCallback onToggleLive;
  final VoidCallback onShowCritical;
  final Animation<double> blinkAnim;

  const WaterManagementHeader({
    super.key,
    required this.liveData,
    required this.critUnacked,
    required this.onBack,
    required this.onToggleLive,
    required this.onShowCritical,
    required this.blinkAnim,
  });

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: C.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: C.gBdr),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: C.cyan,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: C.cyan.withOpacity(.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: C.cyan.withOpacity(.3)),
              boxShadow: [
                BoxShadow(color: C.cyan.withOpacity(.15), blurRadius: 12),
              ],
            ),
            child: Icon(Icons.water_rounded, color: C.cyan, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'WATER MANAGEMENT',
                      style: TextStyle(
                        color: C.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedBuilder(
                      animation: blinkAnim,
                      builder: (_, __) => Opacity(
                        opacity: liveData ? blinkAnim.value : 0.3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: liveData
                                ? C.green.withOpacity(.15)
                                : C.mutedHi.withOpacity(.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: liveData
                                  ? C.green.withOpacity(.4)
                                  : C.mutedHi.withOpacity(.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              WaterDot(liveData ? C.green : C.mutedHi, 3),
                              const SizedBox(width: 4),
                              WaterLabel(
                                text: liveData ? 'LIVE' : 'PAUSED',
                                color: liveData ? C.green : C.mutedHi,
                                size: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                WaterLabel(
                  text: 'URBAN-OS  ·  UTILITIES  ·  SECTOR 4-B',
                  color: C.mutedHi,
                  size: 9,
                ),
              ],
            ),
          ),
          if (critUnacked > 0)
            GestureDetector(
              onTap: onShowCritical,
              child: AnimatedBuilder(
                animation: blinkAnim,
                builder: (_, __) {
                  final p = blinkAnim.value;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: C.red.withOpacity(.12 + p * .06),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: C.red.withOpacity(.4 + p * .2)),
                      boxShadow: [
                        BoxShadow(
                          color: C.red.withOpacity(.1 + p * .1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_rounded, color: C.red, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '$critUnacked',
                          style: TextStyle(
                            color: C.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          GestureDetector(
            onTap: onToggleLive,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: liveData ? C.cyan.withOpacity(.1) : C.bgCard2,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: liveData ? C.cyan.withOpacity(.35) : C.gBdr,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    liveData ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: liveData ? C.cyan : C.mutedHi,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  WaterLabel(
                    text: liveData ? 'PAUSE' : 'RESUME',
                    color: liveData ? C.cyan : C.mutedHi,
                    size: 8.5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
