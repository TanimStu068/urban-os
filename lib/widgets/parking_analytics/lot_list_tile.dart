import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/widgets/parking_analytics/status_chip.dart';

typedef C = AppColors;

const kAccent = C.cyan;

class LotListTile extends StatelessWidget {
  final ParkingLot lot;
  final int liveOccupied;
  final bool isSelected;
  final double glowT, blinkT;
  final VoidCallback onTap;

  const LotListTile({
    super.key,
    required this.lot,
    required this.liveOccupied,
    required this.isSelected,
    required this.glowT,
    required this.blinkT,
    required this.onTap,
  });

  @override
  Widget build(BuildContext ctx) {
    final liveRate = liveOccupied / lot.totalSpaces;
    final col = lot.status.color;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? col.withOpacity(0.07)
              : C.bgCard.withOpacity(0.85),
          border: Border.all(
            color: isSelected ? col.withOpacity(0.4 + glowT * 0.1) : C.gBdr,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: col.withOpacity(0.07), blurRadius: 12)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: col.withOpacity(0.12),
                    border: Border.all(color: col.withOpacity(0.3)),
                  ),
                  child: Icon(
                    Icons.local_parking_rounded,
                    color: col,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lot.id,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? col : kAccent,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        lot.type,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 6.5,
                          color: C.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusChip(lot.status, blinkT, compact: true),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              lot.name,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                color: C.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  '$liveOccupied/${lot.totalSpaces}',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: col,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(liveRate * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    color: col.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Stack(
                children: [
                  Container(height: 4, color: col.withOpacity(0.1)),
                  FractionallySizedBox(
                    widthFactor: liveRate.clamp(0.0, 1.0),
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          colors: [col.withOpacity(0.5), col],
                        ),
                        boxShadow: [
                          BoxShadow(color: col.withOpacity(0.3), blurRadius: 3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
