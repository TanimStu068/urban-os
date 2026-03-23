import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_health_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/widgets/city_health/card.dart';
import 'package:urban_os/widgets/city_health/card_header.dart';
import 'package:urban_os/widgets/city_health/district_detail.dart';
import 'package:urban_os/widgets/city_health/empty_state.dart';

typedef C = AppColors;

class DistrictBreakdown extends StatelessWidget {
  final List<DistrictModel> districts;
  final int selectedIdx;
  final ValueChanged<int> onSelect;
  final AnimationController pulseCtrl, glowCtrl;
  const DistrictBreakdown({
    super.key,
    required this.districts,
    required this.selectedIdx,
    required this.onSelect,
    required this.pulseCtrl,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    if (districts.isEmpty) {
      return CardWidget(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: EmptyState(
          icon: Icons.map_rounded,
          message: 'No districts available',
        ),
      );
    }
    final sel = districts[selectedIdx.clamp(0, districts.length - 1)];

    return CardWidget(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            title: 'DISTRICT HEALTH (${districts.length})',
            icon: Icons.grid_view_rounded,
            color: C.cyan,
          ),

          // Horizontal chip selector
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: districts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final d = districts[i];
                final isSel = i == selectedIdx;
                final col = d.typeColor;
                return GestureDetector(
                  onTap: () => onSelect(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isSel ? col.withOpacity(.15) : C.bgCard,
                      border: Border.all(
                        color: isSel ? col.withOpacity(.5) : C.gBdr,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          d.typeIcon,
                          color: isSel ? col : C.muted,
                          size: 10,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          d.name,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            letterSpacing: 1,
                            color: isSel ? col : C.muted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // Selected district detail
          DistrictDetail(
            district: sel,
            pulseCtrl: pulseCtrl,
            glowCtrl: glowCtrl,
          ),

          const SizedBox(height: 12),

          // All-district health bars
          ...districts.take(8).map((d) {
            final h = d.healthScore;
            final col = d.healthColor;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      d.name,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        color: C.mutedLt,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Stack(
                        children: [
                          Container(height: 4, color: col.withOpacity(.1)),
                          FractionallySizedBox(
                            widthFactor: h / 100,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [col.withOpacity(.6), col],
                                ),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: col.withOpacity(.3),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${h.toInt()}%',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: col,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (d.incidentCount > 0)
                    Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.red,
                      ),
                      child: Center(
                        child: Text(
                          '${d.incidentCount}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 6,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
