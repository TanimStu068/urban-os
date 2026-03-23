import 'package:flutter/material.dart';
import 'package:urban_os/widgets/splash/stat_card.dart';

class StatsRow extends StatelessWidget {
  final bool isSmallScreen;
  const StatsRow({super.key, this.isSmallScreen = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatCard(value: '240+', label: 'SENSORS', isSmall: isSmallScreen),
          SizedBox(width: isSmallScreen ? 12 : 20),
          StatCard(value: '8', label: 'DISTRICTS', isSmall: isSmallScreen),
          SizedBox(width: isSmallScreen ? 12 : 20),
          StatCard(value: '40+', label: 'MODULES', isSmall: isSmallScreen),
        ],
      ),
    );
  }
}
