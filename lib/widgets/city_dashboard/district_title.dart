import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_dashboard_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';

typedef C = AppColors;

class DistrictTile extends StatelessWidget {
  final DistrictModel district;
  const DistrictTile({super.key, required this.district});

  @override
  Widget build(BuildContext context) {
    final col = district.displayColor;
    final health = district.healthPercent;
    final alerts = district.alertCount;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: col.withOpacity(.05),
        border: Border.all(color: col.withOpacity(.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: col.withOpacity(.12),
              border: Border.all(color: col.withOpacity(.3)),
            ),
            child: Icon(district.displayIcon, color: col, size: 13),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  district.name,
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: col,
                    letterSpacing: 1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Stack(
                          children: [
                            Container(height: 3, color: col.withOpacity(.1)),
                            FractionallySizedBox(
                              widthFactor: health / 100,
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [col.withOpacity(.6), col],
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${health.toInt()}%',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        color: col,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (alerts > 0)
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: C.red,
              ),
              child: Center(
                child: Text(
                  '$alerts',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
