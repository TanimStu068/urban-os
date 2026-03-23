import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/widgets/city_dashboard/district_title.dart';
import 'package:urban_os/widgets/city_dashboard/section_header.dart';

typedef C = AppColors;

class DistrictGrid extends StatelessWidget {
  final List<DistrictModel> districts;
  const DistrictGrid({super.key, required this.districts});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.gBdr),
        color: C.bgCard.withOpacity(.85),
      ),
      child: Column(
        children: [
          SectionHeader(
            title: 'DISTRICT STATUS',
            sub: '${districts.length} zones monitored',
            icon: Icons.grid_view_rounded,
            color: C.teal,
            trailing: null,
          ),
          if (districts.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No districts loaded',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: C.muted,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: districts.length,
                itemBuilder: (_, i) => DistrictTile(district: districts[i]),
              ),
            ),
        ],
      ),
    );
  }
}
