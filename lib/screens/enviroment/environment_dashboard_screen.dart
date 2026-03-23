import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/sensor/sensor_provider.dart';
import 'package:urban_os/widgets/environment_dashboard/bg_painter.dart'
    as env_bg;
import 'package:urban_os/widgets/environment_dashboard/overview_tab.dart';
import 'package:urban_os/widgets/environment_dashboard/air_quality_tab.dart';
import 'package:urban_os/widgets/environment_dashboard/alert_row.dart';
import 'package:urban_os/widgets/environment_dashboard/climate_tab.dart';
import 'package:urban_os/widgets/environment_dashboard/dashboard_header.dart';
import 'package:urban_os/widgets/environment_dashboard/dashboard_tapbar.dart';
import 'package:urban_os/widgets/environment_dashboard/env_score_strip.dart';
import 'package:urban_os/widgets/environment_dashboard/noise_tab.dart';
import 'package:urban_os/widgets/environment_dashboard/api_donut_card.dart';
import 'package:urban_os/widgets/environment_dashboard/district_map.dart';
import 'package:urban_os/widgets/environment_dashboard/hourly_overview_chart.dart';
import 'package:urban_os/widgets/environment_dashboard/sensor_grid.dart';
import 'package:urban_os/widgets/environment_dashboard/weather_card.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/environment_dashboard/rain_painter.dart';
import 'package:urban_os/widgets/environment_dashboard/wind_compass_card.dart';

// Water management imports
import 'package:urban_os/widgets/water_management/water_management_models.dart'
    as wm;
import 'package:urban_os/widgets/water_management/water_management_kpi_strip.dart';
import 'package:urban_os/widgets/water_management/water_management_tab_body.dart';

typedef C = AppColors;

const kAccent = C.teal;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class EnvironmentDashboardScreen extends StatefulWidget {
  const EnvironmentDashboardScreen({super.key});
  @override
  State<EnvironmentDashboardScreen> createState() => _EnvDashboardState();
}

class _EnvDashboardState extends State<EnvironmentDashboardScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late List<EnvSensorReading> _sensors;
  late List<Pollutant> _pollutants;
  late List<DistrictEnvData> _districts;
  late List<EnvAlert> _alerts;
  late List<HourlyEnvPoint> _hourly;

  // Water management data
  late List<wm.WaterTank> _tanks;
  late List<wm.WaterPipe> _pipes;
  late List<wm.WaterPump> _pumps;
  late List<wm.DistZone> _zones;
  late List<wm.WaterAlert> _waterAlerts;
  late List<wm.HrUsage> _hourlyUsage;

  WeatherType _weather = WeatherType.cloudy;
  double _windDegree = 218.0; // SW
  bool _liveMode = true;
  ViewTab _tab = ViewTab.overview;

  // Water management state
  int _waterTab = 0;
  bool _waterLiveData = true;
  int? _selectedTank;
  int? _selectedPump;

  // ── animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _windCtrl;
  late AnimationController _rainCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _liveCtrl;
  late AnimationController _barAnimCtrl;

  // Water management animation controllers
  late AnimationController _waterBgCtrl;
  late AnimationController _waterGlowCtrl;
  late AnimationController _waterWaveCtrl;
  late AnimationController _waterFlowCtrl;
  late AnimationController _waterBlinkCtrl;
  late AnimationController _waterPulseCtrl;
  late AnimationController _waterScanCtrl;
  late AnimationController _waterEntCtrl;
  late AnimationController _waterLiveCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();

  // ── derived ──
  EnvSensorReading? _findSensor(String id) {
    try {
      return _sensors.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  EnvSensorReading get _tempSensor {
    final found = _findSensor('TMP');
    if (found != null) return found;
    try {
      return buildSensors().firstWhere((s) => s.id == 'TMP');
    } catch (e) {
      return EnvSensorReading(
        id: 'TMP',
        name: 'TEMPERATURE',
        unit: '°C',
        icon: Icons.thermostat_rounded,
        color: C.amber,
        value: 25.0,
        min: -10,
        max: 50,
        thresholdWarn: 35,
        thresholdCrit: 40,
        history24h: hist(24, 20, 30),
      );
    }
  }

  EnvSensorReading get _humSensor {
    final found = _findSensor('HUM');
    if (found != null) return found;
    try {
      return buildSensors().firstWhere((s) => s.id == 'HUM');
    } catch (e) {
      return EnvSensorReading(
        id: 'HUM',
        name: 'HUMIDITY',
        unit: '%',
        icon: Icons.water_drop_rounded,
        color: C.cyan,
        value: 50.0,
        min: 0,
        max: 100,
        thresholdWarn: 75,
        thresholdCrit: 90,
        history24h: hist(24, 40, 70),
      );
    }
  }

  EnvSensorReading get _noiseSensor {
    final found = _findSensor('NOI');
    if (found != null) return found;
    try {
      return buildSensors().firstWhere((s) => s.id == 'NOI');
    } catch (e) {
      return EnvSensorReading(
        id: 'NOI',
        name: 'NOISE LEVEL',
        unit: 'dB',
        icon: Icons.graphic_eq_rounded,
        color: C.violet,
        value: 55.0,
        min: 30,
        max: 120,
        thresholdWarn: 70,
        thresholdCrit: 85,
        history24h: hist(24, 45, 75),
      );
    }
  }

  EnvSensorReading get _windSensor {
    final found = _findSensor('WND');
    if (found != null) return found;
    try {
      return buildSensors().firstWhere((s) => s.id == 'WND');
    } catch (e) {
      return EnvSensorReading(
        id: 'WND',
        name: 'WIND SPEED',
        unit: 'km/h',
        icon: Icons.air_rounded,
        color: C.mint,
        value: 12.0,
        min: 0,
        max: 100,
        thresholdWarn: 50,
        thresholdCrit: 75,
        history24h: hist(24, 5, 20),
      );
    }
  }

  EnvSensorReading get _rainfallSensor {
    final found = _findSensor('RAN');
    if (found != null) return found;
    try {
      return buildSensors().firstWhere((s) => s.id == 'RAN');
    } catch (e) {
      return EnvSensorReading(
        id: 'RAN',
        name: 'RAINFALL',
        unit: 'mm/h',
        icon: Icons.grain_rounded,
        color: C.sky,
        value: 2.1,
        min: 0,
        max: 50,
        thresholdWarn: 20,
        thresholdCrit: 35,
        history24h: hist(24, 0, 8),
      );
    }
  }

  EnvSensorReading get _uvSensor {
    final found = _findSensor('UV');
    if (found != null) return found;
    try {
      return buildSensors().firstWhere((s) => s.id == 'UV');
    } catch (e) {
      return EnvSensorReading(
        id: 'UV',
        name: 'UV INDEX',
        unit: 'idx',
        icon: Icons.wb_sunny_rounded,
        color: C.yellow,
        value: 6.2,
        min: 0,
        max: 11,
        thresholdWarn: 6,
        thresholdCrit: 8,
        history24h: hist(24, 0, 10),
      );
    }
  }

  EnvSensorReading get _co2Sensor {
    final found = _findSensor('CO2');
    if (found != null) return found;
    try {
      return buildSensors().firstWhere((s) => s.id == 'CO2');
    } catch (e) {
      return EnvSensorReading(
        id: 'CO2',
        name: 'CO₂ LEVEL',
        unit: 'ppm',
        icon: Icons.factory_rounded,
        color: C.lime,
        value: 412.0,
        min: 350,
        max: 700,
        thresholdWarn: 500,
        thresholdCrit: 600,
        history24h: hist(24, 385, 450),
      );
    }
  }

  int get _unackAlerts => _alerts.where((a) => !a.acknowledged).length;

  double get _cityAqi => _districts.isNotEmpty
      ? _districts.fold(0.0, (s, d) => s + d.aqi) / _districts.length
      : 50.0;

  double get _envScore {
    final aqiScore = (1 - (_cityAqi - 30) / 200).clamp(0, 1) * 40;
    final noiseScore = (1 - (_noiseSensor.value - 40) / 60).clamp(0, 1) * 25;
    final tempScore =
        (1 - (_tempSensor.value - 20).abs() / 20).clamp(0, 1) * 20;
    final co2Sensor = _findSensor('CO2');
    final co2Score = co2Sensor != null
        ? (1 - (co2Sensor.value - 350) / 250).clamp(0, 1) * 15
        : 0.0;
    return (aqiScore + noiseScore + tempScore + co2Score)
        .clamp(0, 100)
        .toDouble();
  }

  @override
  void initState() {
    super.initState();
    // Try to load from SensorProvider, fallback to mock data
    try {
      final sensorProvider = context.read<SensorProvider>();
      _sensors = _buildSensorsFromProviders(sensorProvider);
      // Listen for future updates
      sensorProvider.addListener(_onSensorProviderUpdate);
    } catch (e) {
      // SensorProvider not available, use mock sensors
      _sensors = buildSensors();
    }
    _pollutants = buildPollutants();
    _districts = buildDistricts();
    _alerts = buildAlerts();
    _hourly = buildHourly();
    // Initialize water management data
    _tanks = wm.buildTanks();
    _pipes = wm.buildPipes();
    _pumps = wm.buildPumps();
    _zones = wm.buildZones();
    _waterAlerts = wm.buildAlerts();
    _hourlyUsage = wm.buildHourly();
    _initAnims();
    _entranceCtrl.forward();
    _barAnimCtrl.forward();
  }

  void _onSensorProviderUpdate() {
    if (!mounted) return;
    try {
      final sensorProvider = context.read<SensorProvider>();
      setState(() {
        _sensors = _buildSensorsFromProviders(sensorProvider);
      });
    } catch (e) {
      // Ignore if provider not available
    }
  }

  /// Build EnvSensorReading from SensorProvider data
  List<EnvSensorReading> _buildSensorsFromProviders(SensorProvider provider) {
    final readings = <EnvSensorReading>[];

    // Process sensors and create readings
    for (final sensor in provider.sensors) {
      if (sensorConfigs.containsKey(sensor.type)) {
        final config = sensorConfigs[sensor.type]!;
        final value = sensor.latestReading?.value ?? 0.0;
        final threshWarn = config['thresholdWarn'] as double;

        readings.add(
          EnvSensorReading(
            id: config['id'] as String,
            name: config['name'] as String,
            unit: config['unit'] as String,
            icon: config['icon'] as IconData,
            color: config['color'] as Color,
            value: value,
            min: config['min'] as double,
            max: config['max'] as double,
            thresholdWarn: threshWarn,
            thresholdCrit: config['thresholdCrit'] as double,
            history24h: hist(24, value * 0.7, value * 1.3),
          ),
        );
      }
    }

    return readings.isNotEmpty ? readings : buildSensors();
  }

  void _initAnims() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _windCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _rainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
    _barAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _liveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Water management animation controllers
    _waterBgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _waterGlowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _waterWaveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _waterFlowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _waterBlinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _waterPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _waterScanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
    _waterEntCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _waterLiveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _waterEntCtrl.forward();

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: const Offset(0, 0.03), end: Offset.zero));

    _liveCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed && _liveMode) _tickLive();
    });
  }

  void _tickLive() {
    if (!mounted || !_liveMode) return;
    final rng = Random();
    setState(() {
      for (final s in _sensors) {
        final delta = (rng.nextDouble() - 0.5) * (s.max - s.min) * 0.02;
        s.value = (s.value + delta).clamp(s.min, s.max);
      }
      for (final p in _pollutants) {
        final delta = (rng.nextDouble() - 0.5) * p.safeLimit * 0.04;
        p.value = (p.value + delta).clamp(0, p.safeLimit * 2.2);
      }
      for (final d in _districts) {
        d.aqi = (d.aqi + (rng.nextDouble() - 0.5) * 3).clamp(20, 200);
        d.temperature = (d.temperature + (rng.nextDouble() - 0.5) * 0.4).clamp(
          15,
          45,
        );
        d.noise = (d.noise + (rng.nextDouble() - 0.5) * 2).clamp(30, 100);
      }
      _windDegree = (_windDegree + (rng.nextDouble() - 0.5) * 8) % 360;
    });
  }

  @override
  void dispose() {
    try {
      final sensorProvider = context.read<SensorProvider>();
      sensorProvider.removeListener(_onSensorProviderUpdate);
    } catch (e) {
      // Ignore if provider not available
    }
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _windCtrl.dispose();
    _rainCtrl.dispose();
    _entranceCtrl.dispose();
    _liveCtrl.dispose();
    _barAnimCtrl.dispose();
    _waterBgCtrl.dispose();
    _waterGlowCtrl.dispose();
    _waterWaveCtrl.dispose();
    _waterFlowCtrl.dispose();
    _waterBlinkCtrl.dispose();
    _waterPulseCtrl.dispose();
    _waterScanCtrl.dispose();
    _waterEntCtrl.dispose();
    _waterLiveCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  //  ROOT BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: env_bg.BgPainter(
                t: _bgCtrl.value,
                glow: _glowCtrl.value,
                weather: _weather,
                windDeg: _windDegree,
              ),
              size: Size.infinite,
            ),
          ),
          // Weather particles
          if (_weather == WeatherType.rainy || _weather == WeatherType.stormy)
            AnimatedBuilder(
              animation: _rainCtrl,
              builder: (_, __) => CustomPaint(
                painter: RainPainter(
                  t: _rainCtrl.value,
                  intensity: _weather == WeatherType.stormy ? 1.0 : 0.5,
                ),
                size: Size.infinite,
              ),
            ),
          // Scan beam
          AnimatedBuilder(
            animation: _scanCtrl,
            builder: (_, __) => Positioned(
              top: _scanCtrl.value * size.height,
              left: 0,
              right: 0,
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      C.teal.withOpacity(0.04),
                      C.teal.withOpacity(0.10),
                      C.teal.withOpacity(0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Column(
                  children: [
                    DashboardHeader(
                      glowValue: _glowCtrl.value,
                      pulseValue: _pulseCtrl.value,
                      blinkValue: _blinkCtrl.value,
                      sensorCount: _sensors.length,
                      districtCount: _districts.length,
                      cityAqi: _cityAqi,
                      weather: _weather,
                      liveMode: _liveMode,
                      unackAlerts: _unackAlerts,
                      onBack: () => Navigator.maybePop(context),
                      onWeatherChange: (weather) =>
                          setState(() => _weather = weather),
                      onLiveToggle: (live) => setState(() => _liveMode = live),
                      onAlertTap: () => setState(() => _tab = ViewTab.alerts),
                    ),
                    EnvScoreStrip(
                      envScore: _envScore,
                      aqiValue: _cityAqi,
                      aqiLevel: aqiLevel,
                      tempSensor: _tempSensor,
                      humSensor: _humSensor,
                      noiseSensor: _noiseSensor,
                      windSensor: _windSensor,
                      glowValue: _glowCtrl.value,
                      blinkValue: _blinkCtrl.value,
                    ),
                    DashboardTabBar(
                      currentTab: _tab,
                      unackAlerts: _unackAlerts,
                      onTabSelected: (tab) => setState(() => _tab = tab),
                    ),
                    Expanded(child: _buildTabContent()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() => AnimatedSwitcher(
    duration: const Duration(milliseconds: 230),
    child: IndexedStack(
      key: ValueKey(_tab),
      index: _tab.index,
      children: [
        OverviewTab(
          aqiDonutCard: AqiDonutCard(
            cityAqi: _cityAqi,
            pollutants: _pollutants,
            glowCtrl: _glowCtrl,
            barAnim: _barAnimCtrl,
          ),
          windCompassCard: WindCompassCard(
            windDegree: _windDegree,
            windSensor: _windSensor,
            glowCtrl: _glowCtrl,
            windCtrl: _windCtrl,
          ),
          weatherCard: WeatherCard(
            weather: _weather,
            tempSensor: _tempSensor,
            humSensor: _humSensor,
            rainfallSensor: _rainfallSensor,
            uvSensor: _uvSensor,
            glowCtrl: _glowCtrl,
            pulseCtrl: _pulseCtrl,
          ),
          sensorGrid: SensorGrid(
            sensors: _sensors,
            glowCtrl: _glowCtrl,
            blinkCtrl: _blinkCtrl,
          ),
          districtMap: DistrictPollutionMap(
            districts: _districts,
            glowCtrl: _glowCtrl,
            blinkCtrl: _blinkCtrl,
          ),
          hourlyChart: HourlyOverviewChart(
            hourlyData: _hourly,
            glowCtrl: _glowCtrl,
          ),
          scrollController: _scrollCtrl,
        ),
        AirQualityTab(
          cityAqi: _cityAqi,
          pollutants: _pollutants,
          districts: _districts,
          hourly: _hourly,
          glowCtrl: _glowCtrl,
          barAnim: _barAnimCtrl,
          blinkCtrl: _blinkCtrl,
          aqiLevel: aqiLevel,
        ),
        ClimateTab(
          tempSensor: _tempSensor,
          humSensor: _humSensor,
          rainfallSensor: _rainfallSensor,
          uvSensor: _uvSensor,
          co2Sensor: _co2Sensor,
          hourlyData: _hourly,
          districts: _districts,
          glowCtrl: _glowCtrl,
          barAnim: _barAnimCtrl,
        ),
        NoiseTab(
          glowAnimation: _glowCtrl,
          blinkAnimation: _blinkCtrl,
          barAnimation: _barAnimCtrl,
          noiseSensor: _noiseSensor.value,
          districts: _districts,
          hourly: _hourly.map((h) => h.noise).toList(),
        ),
        _buildWaterTab(),
        _buildAlertsTab(),
      ],
    ),
  );

  Widget _buildAlertsTab() => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
    child: Column(
      children: [
        // Acknowledge all button
        if (_unackAlerts > 0)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: C.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: C.teal.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: C.teal, size: 20),
                const SizedBox(width: 8),
                Text(
                  'ACKNOWLEDGE ALL (${_unackAlerts})',
                  style: TextStyle(color: C.teal, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      for (final alert in _alerts) {
                        alert.acknowledged = true;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: C.teal,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        // Alerts list
        ..._alerts.map(
          (alert) => AlertRow(
            alert: alert,
            blinkT: _blinkCtrl.value,
            onAck: () {
              setState(() {
                alert.acknowledged = !alert.acknowledged;
              });
            },
          ),
        ),
      ],
    ),
  );

  List<wm.KpiDef> _buildWaterKpis() {
    final totalSupply = _pumps
        .where((p) => p.status == wm.PumpStatus.running)
        .fold(0.0, (s, p) => s + p.flowRateLS);
    final totalDemand = _zones.fold(0.0, (s, z) => s + z.demandLS);
    final avgPressure =
        _pipes
            .where((p) => p.status.isActive)
            .fold(0.0, (s, p) => s + p.pressureBar) /
        _pipes.where((p) => p.status.isActive).length;
    final avgTankLevel =
        _tanks.fold(0.0, (s, t) => s + t.levelPct) / _tanks.length;
    final activePumps = _pumps
        .where((p) => p.status == wm.PumpStatus.running)
        .length;
    final faultPumps = _pumps
        .where((p) => p.status == wm.PumpStatus.fault)
        .length;
    final leakCount = _pipes.where((p) => p.hasLeak).length;

    return [
      wm.KpiDef(
        Icons.water_drop_rounded,
        'AVG LEVEL',
        '${avgTankLevel.toStringAsFixed(1)}%',
        C.cyan,
        '${_tanks.where((t) => t.status.isAlert).length} alert',
      ),
      wm.KpiDef(
        Icons.speed_rounded,
        'SUPPLY',
        '${totalSupply.toStringAsFixed(0)} L/s',
        C.teal,
        'of ${totalDemand.toStringAsFixed(0)} L/s',
      ),
      wm.KpiDef(
        Icons.compress_rounded,
        'PRESSURE',
        '${avgPressure.toStringAsFixed(1)} bar',
        C.sky,
        'avg active',
      ),
      wm.KpiDef(
        Icons.bolt_rounded,
        'PUMPS',
        '$activePumps/${_pumps.length}',
        C.green,
        faultPumps > 0 ? '$faultPumps fault' : 'all ok',
        faultPumps > 0 ? C.red : null,
      ),
      wm.KpiDef(
        Icons.leak_add_rounded,
        'LEAKS',
        '$leakCount',
        leakCount > 0 ? C.amber : C.teal,
        '${_pipes.fold(0.0, (s, p) => s + (p.hasLeak ? p.flowRate * p.leakPct / 100 : 0)).toStringAsFixed(1)} L/s',
        leakCount > 0 ? C.amber : null,
      ),
      wm.KpiDef(
        Icons.health_and_safety_rounded,
        'HEALTH',
        '${((avgTankLevel * .3 + (totalDemand > 0 ? (totalSupply / totalDemand * 100) : 100) * .3 + (activePumps / max(1, _pumps.length) * 100) * .2 + (100 - leakCount * 20).clamp(0, 100) * .2).clamp(0, 100)).toStringAsFixed(0)}%',
        C.green,
        'GOOD',
      ),
    ];
  }

  Widget _buildWaterTab() {
    final kpis = _buildWaterKpis();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: [
          WaterManagementKpiStrip(items: kpis),
          const SizedBox(height: 16),
          WaterManagementTabBody(
            tab: _waterTab,
            liveData: _waterLiveData,
            tanks: _tanks,
            pipes: _pipes,
            pumps: _pumps,
            zones: _zones,
            alerts: _waterAlerts,
            hourly: _hourlyUsage,
            selectedTank: _selectedTank,
            selectedPump: _selectedPump,
            flowAnimValue: _waterFlowCtrl.value,
            blinkAnimValue: _waterBlinkCtrl.value,
            pulseAnimValue: _waterPulseCtrl.value,
            onTabChange: (index) => setState(() => _waterTab = index),
            onTankSelect: (index) => setState(() => _selectedTank = index),
            onPumpSelect: (index) => setState(() => _selectedPump = index),
            onLiveDataToggle: (value) => setState(() => _waterLiveData = value),
            onShowAlertTab: () => setState(() => _waterTab = 5),
          ),
        ],
      ),
    );
  }
}
