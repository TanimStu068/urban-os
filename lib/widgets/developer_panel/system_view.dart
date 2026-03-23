import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/developer_panel_data_model.dart';
import 'package:urban_os/widgets/developer_panel/info_card.dart';
import 'package:urban_os/widgets/developer_panel/section_header.dart';

typedef C = AppColors;

class SystemView extends StatelessWidget {
  final SystemInfo sysInfo;

  const SystemView({super.key, required this.sysInfo});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Build info
          SectionHeader('BUILD INFORMATION'),
          const SizedBox(height: 8),
          InfoCard(
            label: 'App Version',
            value: sysInfo.appVersion,
            color: C.teal,
          ),
          const SizedBox(height: 4),
          InfoCard(
            label: 'Build Number',
            value: sysInfo.buildNumber,
            color: C.cyan,
          ),
          const SizedBox(height: 4),
          InfoCard(
            label: 'Environment',
            value: sysInfo.environment,
            color: sysInfo.environment == 'DEVELOPMENT' ? C.orange : C.green,
          ),
          const SizedBox(height: 4),
          InfoCard(
            label: 'Build Date',
            value:
                '${sysInfo.buildDate.year}-${sysInfo.buildDate.month.toString().padLeft(2, '0')}-${sysInfo.buildDate.day.toString().padLeft(2, '0')}',
            color: C.yellow,
          ),
          const SizedBox(height: 16),

          // Runtime info
          SectionHeader('RUNTIME ENVIRONMENT'),
          const SizedBox(height: 8),
          InfoCard(label: 'Platform', value: sysInfo.platform, color: C.green),
          const SizedBox(height: 4),
          InfoCard(
            label: 'Flutter',
            value: sysInfo.flutterVersion,
            color: C.mint,
          ),
          const SizedBox(height: 4),
          InfoCard(label: 'Dart', value: sysInfo.dartVersion, color: C.sky),
        ],
      ),
    );
  }
}
