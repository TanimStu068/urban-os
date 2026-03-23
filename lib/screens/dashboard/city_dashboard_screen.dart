import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/providers/city/city_provider.dart';
import 'package:urban_os/providers/district/district_provider.dart';
import 'package:urban_os/providers/sensor/sensor_provider.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/providers/automation/automation_provider.dart';
import 'package:urban_os/widgets/city/bg_painter.dart';
import 'package:urban_os/widgets/city_dashboard/automation_status.dart';
import 'package:urban_os/widgets/city_dashboard/city_health_hero.dart';
import 'package:urban_os/widgets/city_dashboard/city_map_section.dart';
import 'package:urban_os/widgets/city_dashboard/district_grid.dart';
import 'package:urban_os/widgets/city_dashboard/kpi_row.dart';
import 'package:urban_os/widgets/city_dashboard/live_alerts.dart';
import 'package:urban_os/widgets/city_dashboard/quick_action.dart';
import 'package:urban_os/widgets/city_dashboard/spark_line_section.dart';
import 'package:urban_os/widgets/city_dashboard/top_bar.dart';
import 'package:urban_os/widgets/city_dashboard/grid_overlay.dart';
import 'package:urban_os/widgets/city_dashboard/scan_beam.dart';
import 'package:urban_os/widgets/city_dashboard/scan_line_painter.dart';

typedef C = AppColors;

class CityDashboardScreen extends StatefulWidget {
  const CityDashboardScreen({super.key});
  @override
  State<CityDashboardScreen> createState() => _CityDashboardState();
}

class _CityDashboardState extends State<CityDashboardScreen>
    with TickerProviderStateMixin {
  // Sparkline history – fed by sensor updates
  final List<double> _energyHistory = List<double>.filled(
    12,
    68.0,
    growable: true,
  );
  final List<double> _trafficHistory = List<double>.filled(
    12,
    73.0,
    growable: true,
  );
  final List<double> _aqiHistory = List<double>.filled(
    12,
    112.0,
    growable: true,
  );

  // Animation controllers
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _liveCtrl;
  late AnimationController _healthRingCtrl;
  late AnimationController _radarCtrl;
  late AnimationController _alertBlinkCtrl;
  late AnimationController _cityMapCtrl;

  // Entrance animations
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _statsFade;
  late Animation<Offset> _statsSlide;
  late Animation<double> _mapFade;
  late Animation<double> _districtsFade;
  late Animation<double> _alertsFade;
  late Animation<double> _chartsFade;

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _setupAnimations();
    _entranceCtrl.forward();
    _liveCtrl.addListener(_onLiveTick);
  }

  void _setupControllers() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _liveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _healthRingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
    _radarCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _alertBlinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _cityMapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  void _setupAnimations() {
    _headerFade = _interval(0.00, 0.30).drive(Tween(begin: 0.0, end: 1.0));
    _headerSlide = _interval(
      0.00,
      0.30,
    ).drive(Tween(begin: const Offset(0, -.5), end: Offset.zero));
    _statsFade = _interval(0.15, 0.45).drive(Tween(begin: 0.0, end: 1.0));
    _statsSlide = _interval(
      0.15,
      0.45,
    ).drive(Tween(begin: const Offset(0, .3), end: Offset.zero));
    _mapFade = _interval(0.25, 0.55).drive(Tween(begin: 0.0, end: 1.0));
    _districtsFade = _interval(0.35, 0.65).drive(Tween(begin: 0.0, end: 1.0));
    _alertsFade = _interval(0.45, 0.72).drive(Tween(begin: 0.0, end: 1.0));
    _chartsFade = _interval(0.55, 0.85).drive(Tween(begin: 0.0, end: 1.0));
  }

  CurvedAnimation _interval(double begin, double end) => CurvedAnimation(
    parent: _entranceCtrl,
    curve: Interval(begin, end, curve: Curves.easeOut),
  );

  /// Pushes latest sensor readings into sparkline history every 3-second cycle
  void _onLiveTick() {
    if (!mounted || _liveCtrl.value >= 0.02) return;
    final sensors = context.read<SensorProvider>().sensors;
    setState(() {
      _pushSparkline(
        _energyHistory,
        _readSensor(sensors, SensorType.powerConsumption),
      );
      _pushSparkline(
        _trafficHistory,
        _readSensor(sensors, SensorType.congestionLevel),
      );
      _pushSparkline(_aqiHistory, _readSensor(sensors, SensorType.airQuality));
    });
  }

  double _readSensor(List<SensorModel> sensors, SensorType type) {
    final s = sensors.where((s) => s.type == type).firstOrNull;
    return s?.latestReading?.value ?? 0;
  }

  void _pushSparkline(List<double> list, double value) {
    if (value == 0) return;
    list.add(value);
    if (list.length > 14) list.removeAt(0);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _pulseCtrl.dispose();
    _scanCtrl.dispose();
    _entranceCtrl.dispose();
    _liveCtrl.dispose();
    _healthRingCtrl.dispose();
    _radarCtrl.dispose();
    _alertBlinkCtrl.dispose();
    _cityMapCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ─── build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Selectively watch slices so only affected sections rebuild
    final cityProvider = context.watch<CityProvider>();
    final districtProv = context.watch<DistrictProvider>();
    final sensorProv = context.watch<SensorProvider>();
    final logProv = context.watch<LogProvider>();
    final automationProv = context.watch<AutomationProvider>();

    final city = cityProvider.city;
    final districts = districtProv.districts;
    final sensors = sensorProv.sensors;
    final alerts = logProv.alerts;
    final rules = automationProv.rules;

    // ── Derived KPIs from live sensors ──────────────────────────────────────
    final energyVal = _readSensor(sensors, SensorType.powerConsumption);
    final trafficVal = _readSensor(sensors, SensorType.congestionLevel);
    final aqiVal = _readSensor(sensors, SensorType.airQuality);
    final waterVal = _readSensor(sensors, SensorType.waterFlow);

    final cityHealth =
        city?.health.overallScore ?? districtProv.averageHealthScore;
    final activeSensors = sensors.length;
    final activeAlerts = alerts.length;
    final automationCount = rules.where((r) => r.isEnabled).length;

    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          CustomPaint(
            painter: BgPainter(anim: _bgCtrl),
            size: Size.infinite,
          ),
          Positioned.fill(child: GridOverlay(anim: _glowCtrl)),
          Positioned.fill(child: CustomPaint(painter: ScanlinePainter())),
          ScanBeam(anim: _scanCtrl, h: size.height),

          SafeArea(
            child: CustomScrollView(
              controller: _scrollCtrl,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── TOP BAR
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _headerFade,
                    child: SlideTransition(
                      position: _headerSlide,
                      child: TopBar(
                        alerts: activeAlerts,
                        blinkCtrl: _alertBlinkCtrl,
                      ),
                    ),
                  ),
                ),

                // ── CITY HEALTH HERO
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _statsFade,
                    child: SlideTransition(
                      position: _statsSlide,
                      child: CityHealthHero(
                        health: cityHealth,
                        ringCtrl: _healthRingCtrl,
                        glowCtrl: _glowCtrl,
                        radarCtrl: _radarCtrl,
                        sensors: activeSensors,
                        alerts: activeAlerts,
                        automations: automationCount,
                        districtCount: districts.length,
                        onlineDistricts: districts.length,
                      ),
                    ),
                  ),
                ),

                // ── KPI CARDS
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _statsFade,
                    child: SlideTransition(
                      position: _statsSlide,
                      child: KpiRow(
                        energy: energyVal,
                        traffic: trafficVal,
                        aqi: aqiVal,
                        water: waterVal,
                        glowCtrl: _glowCtrl,
                      ),
                    ),
                  ),
                ),

                // ── CITY MAP
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _mapFade,
                    child: CityMapSection(
                      mapCtrl: _cityMapCtrl,
                      pulseCtrl: _pulseCtrl,
                      glowCtrl: _glowCtrl,
                      districts: districts,
                      sensorCount: activeSensors,
                      alertCount: activeAlerts,
                      ruleCount: rules.length,
                    ),
                  ),
                ),

                // ── DISTRICT GRID
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _districtsFade,
                    child: DistrictGrid(districts: districts),
                  ),
                ),

                // ── LIVE ALERTS
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _alertsFade,
                    child: LiveAlerts(
                      alerts: alerts,
                      blinkCtrl: _alertBlinkCtrl,
                    ),
                  ),
                ),

                // ── SPARKLINE CHARTS
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _chartsFade,
                    child: SparklineSection(
                      energyData: List.from(_energyHistory),
                      trafficData: List.from(_trafficHistory),
                      aqiData: List.from(_aqiHistory),
                      liveCtrl: _liveCtrl,
                    ),
                  ),
                ),

                // ── QUICK ACTIONS
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _chartsFade,
                    child: const QuickActions(),
                  ),
                ),

                // ── AUTOMATION ENGINE
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _chartsFade,
                    child: AutomationStatus(rules: rules, glowCtrl: _glowCtrl),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
