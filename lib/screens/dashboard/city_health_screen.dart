import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_health_data_model.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/providers/city/city_provider.dart';
import 'package:urban_os/providers/district/district_provider.dart';
import 'package:urban_os/providers/infrastructure_provider.dart';
import 'package:urban_os/providers/sensor/sensor_provider.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/providers/automation/automation_provider.dart';
import 'package:urban_os/widgets/city_health/bg_painter.dart';
import 'package:urban_os/widgets/city_health/alert_time_line.dart';
import 'package:urban_os/widgets/city_health/automation_summary.dart';
import 'package:urban_os/widgets/city_health/district_breakdown.dart';
import 'package:urban_os/widgets/city_health/grid_lines.dart';
import 'package:urban_os/widgets/city_health/header.dart';
import 'package:urban_os/widgets/city_health/health_hero.dart';
import 'package:urban_os/widgets/city_health/infrastructure_grid.dart';
import 'package:urban_os/widgets/city_health/multi_sparkline.dart';
import 'package:urban_os/widgets/city_health/scan_line.dart';
import 'package:urban_os/widgets/city_health/system_panel.dart';
import 'package:urban_os/widgets/city_health/system_tab_bar.dart';

//  ALIAS
typedef C = AppColors;

//  HELPER  – safe read of first sensor by type
double _sensorVal(List<SensorModel> sensors, SensorType type) =>
    sensors.where((s) => s.type == type).firstOrNull?.val ?? 0;

//  SCREEN
class CityHealthScreen extends StatefulWidget {
  const CityHealthScreen({super.key});
  @override
  State<CityHealthScreen> createState() => _CityHealthScreenState();
}

class _CityHealthScreenState extends State<CityHealthScreen>
    with TickerProviderStateMixin {
  // History buffers for sparklines (filled by timer-driven provider reads)
  final _energyHist = List<double>.filled(16, 60, growable: true);
  final _trafficHist = List<double>.filled(16, 55, growable: true);
  final _aqiHist = List<double>.filled(16, 100, growable: true);
  final _waterHist = List<double>.filled(16, 40, growable: true);
  final _infraHist = List<double>.filled(
    16,
    80,
    growable: true,
  ); // infra health over time

  // Selected district tab in district breakdown
  int _districtIdx = 0;
  // Selected system tab: 0=overview,1=sensors,2=infrastructure,3=alerts
  int _systemTab = 0;

  // Animation controllers
  late AnimationController _bgCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _liveCtrl;
  late AnimationController _ringCtrl;
  late AnimationController _radarCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _alertCtrl;

  // Entrance anims
  late Animation<double> _fadeHeader;
  late Animation<Offset> _slideHeader;
  late Animation<double> _fadeHero;
  late Animation<double> _fadeSys;
  late Animation<double> _fadeDistrict;
  late Animation<double> _fadeCharts;
  late Animation<double> _fadeAlerts;
  late Animation<double> _fadeInfra;

  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _setupAnims();
    _entranceCtrl.forward();
    _liveCtrl.addListener(_onTick);
  }

  void _setupControllers() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _liveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
    _radarCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _alertCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  CurvedAnimation _iv(double b, double e) => CurvedAnimation(
    parent: _entranceCtrl,
    curve: Interval(b, e, curve: Curves.easeOut),
  );

  void _setupAnims() {
    _fadeHeader = _iv(0.00, 0.25).drive(Tween(begin: 0.0, end: 1.0));
    _slideHeader = _iv(
      0.00,
      0.25,
    ).drive(Tween(begin: const Offset(0, -.6), end: Offset.zero));
    _fadeHero = _iv(0.10, 0.40).drive(Tween(begin: 0.0, end: 1.0));
    _fadeSys = _iv(0.20, 0.50).drive(Tween(begin: 0.0, end: 1.0));
    _fadeDistrict = _iv(0.30, 0.60).drive(Tween(begin: 0.0, end: 1.0));
    _fadeCharts = _iv(0.40, 0.70).drive(Tween(begin: 0.0, end: 1.0));
    _fadeAlerts = _iv(0.50, 0.80).drive(Tween(begin: 0.0, end: 1.0));
    _fadeInfra = _iv(0.60, 0.90).drive(Tween(begin: 0.0, end: 1.0));
  }

  void _onTick() {
    if (!mounted || _liveCtrl.value > 0.02) return;
    final sp = context.read<SensorProvider>().sensors;
    setState(() {
      _push(_energyHist, _sensorVal(sp, SensorType.powerConsumption));
      _push(_trafficHist, _sensorVal(sp, SensorType.congestionLevel));
      _push(_aqiHist, _sensorVal(sp, SensorType.airQuality));
      _push(_waterHist, _sensorVal(sp, SensorType.waterFlow));
      final ip = context.read<InfrastructureProvider>().infrastructureHealth;
      _push(_infraHist, ip);
    });
  }

  void _push(List<double> buf, double val) {
    if (val == 0) return;
    buf.add(val);
    if (buf.length > 20) buf.removeAt(0);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _pulseCtrl.dispose();
    _glowCtrl.dispose();
    _entranceCtrl.dispose();
    _liveCtrl.dispose();
    _ringCtrl.dispose();
    _radarCtrl.dispose();
    _scanCtrl.dispose();
    _alertCtrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // ─── BUILD ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Provider reads
    final cityProv = context.watch<CityProvider>();
    final distProv = context.watch<DistrictProvider>();
    final sensorProv = context.watch<SensorProvider>();
    final logProv = context.watch<LogProvider>();
    final autoProv = context.watch<AutomationProvider>();
    final infraProv = context.watch<InfrastructureProvider>();

    final city = cityProv.city;
    final districts = distProv.districts;
    final sensors = sensorProv.sensors;
    final alerts = logProv.alerts;
    final events = logProv.events;
    final rules = autoProv.rules;
    final buildings = infraProv.buildings;
    final roads = infraProv.roads;

    // Derived live values
    final cityHealth = city?.health.overallScore ?? distProv.averageHealthScore;
    final infraHealth = infraProv.infrastructureHealth;
    final congestion = infraProv.averageRoadCongestion;
    final bldRisk = infraProv.averageBuildingRisk;
    final activeAlerts = alerts.where((a) => a.isActive).length;
    final critAlerts = alerts
        .where((a) => a.severity.name.toLowerCase() == 'critical')
        .length;
    final activeSensors = sensors.length;
    final activeRules = rules.where((r) => r.isEnabled).length;
    final energyVal = _sensorVal(sensors, SensorType.powerConsumption);
    final trafficVal = _sensorVal(sensors, SensorType.congestionLevel);
    final aqiVal = _sensorVal(sensors, SensorType.airQuality);
    final waterVal = _sensorVal(sensors, SensorType.waterFlow);

    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          // Animated background
          CustomPaint(
            painter: BgPainter(anim: _bgCtrl),
            size: Size.infinite,
          ),
          Positioned.fill(child: GridLines(glow: _glowCtrl)),
          ScanLine(ctrl: _scanCtrl, height: size.height),

          SafeArea(
            child: CustomScrollView(
              controller: _scroll,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── HEADER ─────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeHeader,
                    child: SlideTransition(
                      position: _slideHeader,
                      child: Header(
                        cityName: city?.name ?? 'UrbanOS',
                        critAlerts: critAlerts,
                        alertCtrl: _alertCtrl,
                      ),
                    ),
                  ),
                ),

                // ── HERO HEALTH RING + GAUGES ──────────────────────────────
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeHero,
                    child: HealthHero(
                      cityHealth: cityHealth,
                      infraHealth: infraHealth,
                      ringCtrl: _ringCtrl,
                      radarCtrl: _radarCtrl,
                      glowCtrl: _glowCtrl,
                      pulseCtrl: _pulseCtrl,
                      activeSensors: activeSensors,
                      activeAlerts: activeAlerts,
                      activeRules: activeRules,
                      districts: districts.length,
                      buildings: buildings.length,
                      roads: roads.length,
                      energyVal: energyVal,
                      trafficVal: trafficVal,
                      aqiVal: aqiVal,
                      waterVal: waterVal,
                    ),
                  ),
                ),

                // ── SYSTEM TABS (Overview / Sensors / Infra / Alerts) ──────
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeSys,
                    child: SystemTabBar(
                      selected: _systemTab,
                      onSelect: (i) => setState(() => _systemTab = i),
                      alertCount: activeAlerts,
                      sensorCount: activeSensors,
                      ruleCount: activeRules,
                      infraScore: infraHealth,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeSys,
                    child: SystemPanel(
                      tab: _systemTab,
                      sensors: sensors,
                      alerts: alerts,
                      rules: rules,
                      buildings: buildings,
                      roads: roads,
                      infraHealth: infraHealth,
                      congestion: congestion,
                      bldRisk: bldRisk,
                      glowCtrl: _glowCtrl,
                      alertCtrl: _alertCtrl,
                    ),
                  ),
                ),

                // ── DISTRICT HEALTH BREAKDOWN ──────────────────────────────
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeDistrict,
                    child: DistrictBreakdown(
                      districts: districts,
                      selectedIdx: _districtIdx,
                      onSelect: (i) => setState(() => _districtIdx = i),
                      pulseCtrl: _pulseCtrl,
                      glowCtrl: _glowCtrl,
                    ),
                  ),
                ),

                // ── SPARKLINE CHARTS (5 channels) ─────────────────────────
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeCharts,
                    child: MultiSparklines(
                      energyHist: List.from(_energyHist),
                      trafficHist: List.from(_trafficHist),
                      aqiHist: List.from(_aqiHist),
                      waterHist: List.from(_waterHist),
                      infraHist: List.from(_infraHist),
                      liveCtrl: _liveCtrl,
                      glowCtrl: _glowCtrl,
                    ),
                  ),
                ),

                // ── ALERT TIMELINE ────────────────────────────────────────
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAlerts,
                    child: AlertTimeline(
                      alerts: alerts,
                      events: logProv.events,
                      alertCtrl: _alertCtrl,
                    ),
                  ),
                ),

                // ── INFRASTRUCTURE GRID ────────────────────────────────────
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeInfra,
                    child: InfrastructureGrid(
                      buildings: buildings,
                      roads: roads,
                      infraHealth: infraHealth,
                      congestion: congestion,
                      bldRisk: bldRisk,
                      glowCtrl: _glowCtrl,
                    ),
                  ),
                ),

                // ── AUTOMATION SUMMARY ─────────────────────────────────────
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeInfra,
                    child: AutomationSummary(
                      rules: rules,
                      events: events,
                      glowCtrl: _glowCtrl,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
