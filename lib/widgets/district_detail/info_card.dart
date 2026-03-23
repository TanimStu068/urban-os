import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/district_detail_data_model.dart';

import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/district/district_type.dart';
import 'package:urban_os/widgets/district_detail/info_row.dart';

typedef C = AppColors;

class InfoCard extends StatelessWidget {
  final DistrictModel d;

  const InfoCard({super.key, required this.d});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: C.gBdr),
      ),
      child: Column(
        children: [
          // Optional description section
          if (d.description != null) ...[
            Text(
              d.description!,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8.5,
                color: C.mutedLt,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 10),
            Container(height: 1, color: C.gBdr),
            const SizedBox(height: 10),
          ],

          // Info rows
          InfoRow('District ID', d.id, C.cyan),
          InfoRow('Type', d.type.displayName, typeColor(d.type)),
          if (d.population != null)
            InfoRow('Population', fmtNum(d.population!), C.violet),
          if (d.areaKm2 != null)
            InfoRow('Area', '${d.areaKm2!.toStringAsFixed(2)} km²', C.mutedLt),
          if (d.populationDensity != null)
            InfoRow(
              'Density',
              '${d.populationDensity!.toStringAsFixed(0)} /km²',
              C.mutedLt,
            ),
          if (d.latitude != null && d.longitude != null)
            InfoRow(
              'Coordinates',
              '${d.latitude!.toStringAsFixed(4)}, ${d.longitude!.toStringAsFixed(4)}',
              C.cyan,
            ),
          if (d.developmentStatus != null)
            InfoRow('Dev Status', d.developmentStatus!, C.amber),
          if (d.sustainabilityScore != null)
            InfoRow(
              'Sustainability',
              '${d.sustainabilityScore!.toStringAsFixed(1)}%',
              C.green,
            ),
          if (d.addedDate != null)
            InfoRow('Added', fmtDate(d.addedDate!), C.mutedLt),
          if (d.lastUpdateTime != null)
            InfoRow('Last Updated', fmtDate(d.lastUpdateTime!), C.mutedLt),
          InfoRow(
            'Status',
            d.isActive ? 'ACTIVE' : 'INACTIVE',
            d.isActive ? C.green : C.red,
          ),
          InfoRow('Primary Concern', d.type.primaryConcern, typeColor(d.type)),
        ],
      ),
    );
  }
}
