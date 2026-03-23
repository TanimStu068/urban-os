import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

import 'package:urban_os/models/district/district_model.dart';

typedef C = AppColors;

class IncidentPanel extends StatelessWidget {
  final DistrictModel d;
  final Animation<double> blinkAnim;

  const IncidentPanel({super.key, required this.d, required this.blinkAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: blinkAnim,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: C.red.withOpacity(0.3 + blinkAnim.value * 0.1),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.report_problem_rounded, color: C.red, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${d.metrics.activeIncidents} ACTIVE INCIDENT${d.metrics.activeIncidents != 1 ? 'S' : ''}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: C.red,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Requires immediate attention · ${d.name}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: C.mutedLt,
                    ),
                    overflow: TextOverflow.ellipsis,
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
