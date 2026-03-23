import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';

class RoadStatusRow extends StatelessWidget {
  final RoadSegment road;
  final bool isSelected;
  final double glowT, blinkT;
  final VoidCallback onTap;
  const RoadStatusRow({
    super.key,
    required this.road,
    required this.isSelected,
    required this.glowT,
    required this.blinkT,
    required this.onTap,
  });

  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: isSelected
            ? road.color.withOpacity(.08)
            : C.bgCard2.withOpacity(.5),
        border: Border.all(
          color: isSelected ? road.color.withOpacity(.4 + glowT * .1) : C.gBdr,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: road.color.withOpacity(
                road.incidents > 0 ? .6 + blinkT * .4 : .7,
              ),
              boxShadow: [
                BoxShadow(color: road.color.withOpacity(.4), blurRadius: 5),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  road.name,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: C.white,
                    letterSpacing: .3,
                  ),
                ),
                Text(
                  '${road.type}  ·  ${road.speed}km/h',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.muted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Stack(
                children: [
                  Container(height: 4, color: road.color.withOpacity(.12)),
                  FractionallySizedBox(
                    widthFactor: road.congestion / 100,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [road.color.withOpacity(.5), road.color],
                        ),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: road.color.withOpacity(.3),
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
            '${road.congestion}%',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: road.color,
            ),
          ),
          if (road.incidents > 0) ...[
            const SizedBox(width: 6),
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: C.red,
              ),
              child: Center(
                child: Text(
                  '${road.incidents}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
