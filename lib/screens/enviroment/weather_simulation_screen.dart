import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/weather_simulation_data_model.dart';
import 'package:urban_os/widgets/weather_simulation/forecast_chart.dart';
import 'package:urban_os/widgets/weather_simulation/imfact_analysis.dart';
import 'package:urban_os/widgets/weather_simulation/metrics_grid.dart';
import 'package:urban_os/widgets/weather_simulation/rain_fall_painter.dart';
import 'package:urban_os/widgets/weather_simulation/simulation_Control.dart';
import 'package:urban_os/widgets/weather_simulation/weather_alert.dart';
import 'package:urban_os/widgets/weather_simulation/weather_display.dart';
import 'package:urban_os/widgets/weather_simulation/weather_header.dart';

typedef C = AppColors;

const kAccent = C.teal;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class WeatherSimulationScreen extends StatefulWidget {
  const WeatherSimulationScreen({super.key});

  @override
  State<WeatherSimulationScreen> createState() => _WeatherSimulationState();
}

class _WeatherSimulationState extends State<WeatherSimulationScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late List<WeatherSnapshot> _forecastData;
  late WeatherSnapshot _currentWeather;
  late List<WeatherAlert> _alerts;

  int _currentHour = 0;
  bool _isRunning = false;

  // Simulation controls
  double _tempOffset = 0;
  double _windMultiplier = 1.0;
  double _rainfallMultiplier = 1.0;

  // ── animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _weatherCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _rainCtrl;
  late AnimationController _playCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _forecastData = buildForecastData();
    _currentWeather = _forecastData[0];
    _alerts = buildAlerts(_currentWeather.condition);
    _initAnims();
    _entranceCtrl.forward();
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
    _weatherCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
    _rainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _playCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: const Offset(0, 0.03), end: Offset.zero));

    if (_isRunning) _playCtrl.repeat();
  }

  void _advanceSimulation() {
    if (_currentHour < _forecastData.length - 1) {
      setState(() {
        _currentHour++;
        _updateCurrentWeather();
        _alerts = buildAlerts(_currentWeather.condition);
      });
    }
  }

  void _updateCurrentWeather() {
    final base = _forecastData[_currentHour];
    _currentWeather = WeatherSnapshot(
      timestamp: base.timestamp,
      condition: base.condition,
      temperature: (base.temperature + _tempOffset).clamp(-50, 60),
      humidity: base.humidity.clamp(0, 100),
      windSpeed: (base.windSpeed * _windMultiplier).clamp(0, 150),
      windDirection: base.windDirection,
      rainfall: (base.rainfall * _rainfallMultiplier).clamp(0, 200),
      cloudCover: base.cloudCover,
      visibility: base.visibility,
      uvIndex: base.uvIndex,
      pressure: base.pressure,
      feelsLike: (base.feelsLike + _tempOffset).clamp(-50, 60),
    );
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _weatherCtrl.dispose();
    _pulseCtrl.dispose();
    _entranceCtrl.dispose();
    _rainCtrl.dispose();
    _playCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          // Dynamic background
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(sin(_bgCtrl.value * 2 * pi) * 0.5, -1),
                  end: Alignment(cos(_bgCtrl.value * 2 * pi) * 0.5, 1),
                  colors: [
                    _currentWeather.condition.color.withOpacity(0.08),
                    C.bg,
                  ],
                ),
              ),
            ),
          ),
          // Weather effect overlay
          if (_currentWeather.rainfall > 5)
            AnimatedBuilder(
              animation: _rainCtrl,
              builder: (_, __) => CustomPaint(
                painter: RainfallPainter(
                  t: _rainCtrl.value,
                  intensity: (_currentWeather.rainfall / 100).clamp(0, 1),
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
                      _currentWeather.condition.color.withOpacity(0.04),
                      _currentWeather.condition.color.withOpacity(0.10),
                      _currentWeather.condition.color.withOpacity(0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Column(
                  children: [
                    WeatherHeaderWidget(
                      currentWeather: _currentWeather,
                      glowAnimation: _glowCtrl,
                      weatherAnimation: _weatherCtrl,
                      onBack: () => Navigator.pop(context),
                    ),
                    Expanded(child: _buildContent()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() => SingleChildScrollView(
    controller: _scrollCtrl,
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Large weather display
        WeatherDisplayWidget(
          currentWeather: _currentWeather,
          glowAnimation: _glowCtrl,
          weatherAnimation: _weatherCtrl,
        ),
        const SizedBox(height: 12),
        // Current metrics
        MetricsGridWidget(
          currentWeather: _currentWeather,
          glowAnimation: _glowCtrl,
        ),
        const SizedBox(height: 12),
        // Alerts
        if (_alerts.isNotEmpty) ...[
          WeatherAlertsWidget(
            alerts: _alerts,
            onDismiss: (alert) {
              setState(() {
                alert.dismissed = true;
              });
            },
          ),
          const SizedBox(height: 12),
        ],
        // Simulation controls
        SimulationControlsWidget(
          tempOffset: _tempOffset,
          windMultiplier: _windMultiplier,
          rainfallMultiplier: _rainfallMultiplier,
          currentHour: _currentHour,
          onTempChanged: (val) => setState(() {
            _tempOffset = val;
            _updateCurrentWeather();
          }),
          onWindChanged: (val) => setState(() {
            _windMultiplier = val;
            _updateCurrentWeather();
          }),
          onRainfallChanged: (val) => setState(() {
            _rainfallMultiplier = val;
            _updateCurrentWeather();
          }),
          onAdvanceSimulation: _advanceSimulation,
          onResetSimulation: () => setState(() => _currentHour = 0),
        ),
        const SizedBox(height: 12),
        // Forecast chart
        ForecastChartWidget(
          forecastData: _forecastData,
          currentHour: _currentHour,
          glowCtrl: _glowCtrl,
        ),
        const SizedBox(height: 12),
        // Impact analysis
        ImpactAnalysisWidget(currentWeather: _currentWeather),
      ],
    ),
  );
}
