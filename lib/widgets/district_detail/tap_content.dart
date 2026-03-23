import 'package:flutter/material.dart';

import 'package:urban_os/models/district/district_model.dart';

class TabContent extends StatelessWidget {
  final DistrictModel d;
  final int tab;
  final ScrollController scrollCtrl;

  final List<Widget> Function(DistrictModel) buildOverview;
  final List<Widget> Function(DistrictModel) buildSensorsTab;
  final List<Widget> Function(DistrictModel) buildActuatorsTab;
  final List<Widget> Function(DistrictModel) buildHistoryTab;

  const TabContent({
    super.key,
    required this.d,
    required this.tab,
    required this.scrollCtrl,
    required this.buildOverview,
    required this.buildSensorsTab,
    required this.buildActuatorsTab,
    required this.buildHistoryTab,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollCtrl,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              if (tab == 0) ...buildOverview(d),
              if (tab == 1) ...buildSensorsTab(d),
              if (tab == 2) ...buildActuatorsTab(d),
              if (tab == 3) ...buildHistoryTab(d),
            ]),
          ),
        ),
      ],
    );
  }
}
