import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/traffic_dashboard/mini_stat.dart';

typedef C = AppColors;
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

class PeakLegend extends StatelessWidget {
  const PeakLegend({super.key});
  @override
  Widget build(BuildContext ctx) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      MiniStat('PEAK HOUR', '08:00', kAccent),
      MiniStat('PEAK VOLUME', '1,280/h', C.red),
      MiniStat('NIGHT MIN', '65/h', C.green),
    ],
  );
}
