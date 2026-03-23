import 'package:flutter/material.dart';

class OverviewTab extends StatelessWidget {
  final Widget aqiDonutCard;
  final Widget windCompassCard;
  final Widget weatherCard;
  final Widget sensorGrid;
  final Widget districtMap;
  final Widget hourlyChart;
  final ScrollController scrollController;

  const OverviewTab({
    super.key,
    required this.aqiDonutCard,
    required this.windCompassCard,
    required this.weatherCard,
    required this.sensorGrid,
    required this.districtMap,
    required this.hourlyChart,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: AQI donut + wind compass + weather card
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: aqiDonutCard),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: windCompassCard),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: weatherCard),
            ],
          ),
          const SizedBox(height: 12),
          // Sensor grid
          sensorGrid,
          const SizedBox(height: 12),
          // District pollution map
          districtMap,
          const SizedBox(height: 12),
          // Hourly trend overview
          hourlyChart,
        ],
      ),
    );
  }
}
