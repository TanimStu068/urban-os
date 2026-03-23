import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/loader/mock_data_loader.dart';
import 'package:urban_os/providers/auth/auth_provider.dart';
import 'package:urban_os/providers/infrastructure_provider.dart';
import 'package:urban_os/services/analytics/analytics_service.dart';

import '../services/infrastructure/infrastructure_service.dart';
import '../services/simulation/simulation_engine.dart';

import '../providers/log/log_provider.dart';
import '../providers/sensor/sensor_provider.dart';
import '../providers/city/city_provider.dart';
import '../providers/district/district_provider.dart';
import '../providers/automation/automation_provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// ───────────── SERVICES ─────────────
        Provider<InfrastructureService>(create: (_) => InfrastructureService()),

        Provider<SimulationEngine>(
          create: (context) => SimulationEngine(
            infrastructureService: context.read<InfrastructureService>(),
          ),
        ),

        // Provider<AnalyticsService>(create: (_) => AnalyticsService()),
        Provider<AnalyticsService>(
          create: (context) =>
              AnalyticsService(context.read<InfrastructureService>()),
        ),

        Provider<MockDataLoader>(create: (_) => MockDataLoader()),

        /// ───────────── CORE PROVIDERS ─────────────
        ChangeNotifierProvider<LogProvider>(create: (_) => LogProvider()),

        ChangeNotifierProvider<InfrastructureProvider>(
          create: (context) =>
              InfrastructureProvider(context.read<InfrastructureService>()),
        ),
        ChangeNotifierProvider<AppAuthProvider>(
          create: (_) => AppAuthProvider(),
        ),

        ChangeNotifierProvider<SensorProvider>(
          create: (context) => SensorProvider(
            context.read<InfrastructureService>(),
            context.read<LogProvider>(),
          ),
        ),

        ChangeNotifierProvider<CityProvider>(
          create: (context) => CityProvider(
            context.read<InfrastructureService>(),
            context.read<LogProvider>(),
            context.read<SimulationEngine>(),
          ),
        ),

        ChangeNotifierProvider<DistrictProvider>(
          create: (context) => DistrictProvider(context.read<MockDataLoader>()),
        ),

        ChangeNotifierProvider<AutomationProvider>(
          create: (context) => AutomationProvider(
            infrastructure: context.read<InfrastructureService>(),
            simulationEngine: context.read<SimulationEngine>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
