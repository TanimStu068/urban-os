import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/widgets/prediction/anomaly_list.dart';
import 'package:urban_os/widgets/prediction/forecast_list.dart';
import 'package:urban_os/widgets/prediction/header.dart';
import 'package:urban_os/widgets/prediction/mode_bar.dart';
import 'package:urban_os/widgets/prediction/predbg_painter.dart';
import 'package:urban_os/widgets/prediction/risk_heat_map.dart';
import 'package:urban_os/widgets/prediction/risk_list.dart';
import 'package:urban_os/widgets/prediction/signal_detail.dart';
import 'package:urban_os/widgets/prediction/summary_kpis_widget.dart';

typedef C = AppColors;

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen>
    with TickerProviderStateMixin {
  PredictMode _mode = PredictMode.anomaly;
  String? _selectedId;

  // Animation controllers
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _drawCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _drawAnim;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _rng = Random(17);
  final _scrollCtrl = ScrollController();

  late List<Prediction> _predictions;
  late List<RiskZone> _riskZones;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _drawCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _drawAnim = CurvedAnimation(parent: _drawCtrl, curve: Curves.easeOut);
    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.05), end: Offset.zero));

    _predictions = _generatePredictions();
    _riskZones = _generateRiskZones();
    _entranceCtrl.forward();
    _drawCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _drawCtrl.dispose();
    _entranceCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _setMode(PredictMode m) {
    setState(() {
      _mode = m;
      _selectedId = null;
    });
    _drawCtrl.forward(from: 0);
  }

  List<Prediction> _generatePredictions() {
    const sensors = [
      'TEMP-D3',
      'FLOW-C7',
      'PRESS-A2',
      'VIBR-B9',
      'CO2-E1',
      'NOISE-F4',
    ];
    const districts = ['ALPHA', 'BETA', 'GAMMA', 'DELTA', 'EPSILON', 'ZETA'];
    const summaries = [
      'Thermal spike pattern detected — HVAC anomaly likely',
      'Flow rate deviation suggests pipe blockage',
      'Pressure variance approaching critical threshold',
      'Vibration harmonics indicate bearing wear',
      'CO₂ accumulation trending above safety threshold',
      'Noise floor rising — motor degradation pattern',
    ];
    const details = [
      'Signal deviates 2.4σ from 30-day baseline. Pattern matches pre-failure HVAC cycle.',
      'Flow reduction 18% over 6h window. Consistent with partial obstruction.',
      'Pressure oscillation frequency shifted 12Hz. Predictive maintenance window: 48–72h.',
      'Third harmonic amplitude increased 340% vs baseline. Bearing replacement advised.',
      'CO₂ gradient 4.2 ppm/min. Ventilation failure predicted within 3–6 hours.',
      'Spectral density shift from 85–110Hz. Motor efficiency degradation confirmed.',
    ];

    final now = DateTime.now();
    return List.generate(6, (i) {
      final hist = List.generate(24, (j) {
        final base = 50.0 + i * 8;
        final trend = i < 3 ? j * 0.8 : -j * 0.3;
        return base + trend + _rng.nextDouble() * 12 - 4;
      });
      final forecast = List.generate(12, (j) {
        final last = hist.last;
        final trend = i < 3 ? 1.2 + j * 0.4 : -0.5 - j * 0.2;
        return last + trend * (j + 1) + _rng.nextDouble() * 6 - 2;
      });
      final upper = forecast.map((v) => v + 8 + _rng.nextDouble() * 4).toList();
      final lower = forecast.map((v) => v - 8 - _rng.nextDouble() * 4).toList();

      final conf = 0.45 + _rng.nextDouble() * 0.5;
      final level = conf < 0.55
          ? ConfidenceLevel.low
          : conf < 0.75
          ? ConfidenceLevel.medium
          : conf < 0.9
          ? ConfidenceLevel.high
          : ConfidenceLevel.critical;

      return Prediction(
        id: 'PRED-${(1000 + i).toString()}',
        sensorId: sensors[i],
        district: districts[i],
        confidence: conf,
        level: level,
        summary: summaries[i],
        detail: details[i],
        predictedAt: now.subtract(Duration(minutes: _rng.nextInt(180))),
        expectedAt: now.add(Duration(hours: 2 + _rng.nextInt(20))),
        signalHistory: hist,
        forecastLine: forecast,
        upperBound: upper,
        lowerBound: lower,
        isAnomaly: i < 4,
        anomalyScore: 0.3 + _rng.nextDouble() * 0.65,
      );
    });
  }

  List<RiskZone> _generateRiskZones() => [
    const RiskZone('ALPHA', 0.82, 7, 'Thermal anomaly'),
    const RiskZone('BETA', 0.61, 4, 'Flow deviation'),
    const RiskZone('GAMMA', 0.44, 2, 'Pressure variance'),
    const RiskZone('DELTA', 0.91, 11, 'Multi-sensor alert'),
    const RiskZone('EPSILON', 0.27, 1, 'CO₂ trend'),
    const RiskZone('ZETA', 0.55, 3, 'Vibration pattern'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<LogProvider>(
      builder: (ctx, lp, _) {
        final selected = _selectedId != null
            ? _predictions.firstWhere(
                (p) => p.id == _selectedId,
                orElse: () => _predictions.first,
              )
            : null;

        return Scaffold(
          backgroundColor: C.bg,
          body: AnimatedBuilder(
            animation: Listenable.merge([
              _bgCtrl,
              _glowCtrl,
              _scanCtrl,
              _blinkCtrl,
              _entranceCtrl,
            ]),
            builder: (_, __) => Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: PredBgPainter(
                      _bgCtrl.value,
                      _scanCtrl.value,
                      _glowCtrl.value,
                    ),
                  ),
                ),
                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideIn,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PredictiveHeader(
                            logProvider: lp,
                            glowAnimation: _glowCtrl,
                            blinkAnimation: _blinkCtrl,
                            modelCount: _predictions.length,
                          ),
                          // _buildHeader(lp),
                          PredictModeBar(
                            currentMode: _mode,
                            onModeChange: _setMode,
                          ),
                          // _buildModeBar(),
                          Expanded(
                            child: CustomScrollView(
                              controller: _scrollCtrl,
                              physics: const BouncingScrollPhysics(),
                              slivers: [
                                SliverToBoxAdapter(
                                  child: SummaryKpisWidget(
                                    predictions: _predictions,
                                    riskZones: _riskZones,
                                    glowAnimation: _glowCtrl,
                                  ),
                                ),
                                if (_mode == PredictMode.anomaly) ...[
                                  SliverToBoxAdapter(
                                    child: AnomalyListWidget(
                                      predictions: _predictions,
                                    ),
                                  ),
                                  if (selected != null)
                                    SliverToBoxAdapter(
                                      child: SignalDetailWidget(
                                        prediction: selected,
                                        drawAnimation: _drawAnim,
                                      ),
                                    ),
                                ],
                                if (_mode == PredictMode.forecast) ...[
                                  SliverToBoxAdapter(
                                    child: ForecastListWidget(
                                      predictions: _predictions,
                                    ),
                                  ),
                                  if (selected != null)
                                    SliverToBoxAdapter(
                                      child: _buildForecastChart(selected),
                                    ),
                                ],
                                if (_mode == PredictMode.risk) ...[
                                  SliverToBoxAdapter(
                                    child: RiskHeatMapWidget(
                                      riskZones: _riskZones,
                                      drawAnimation: _drawAnim,
                                      pulseAnimation: _pulseCtrl,
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: RiskListWidget(
                                      riskZones: _riskZones,
                                    ),
                                  ),
                                ],
                                const SliverToBoxAdapter(
                                  child: SizedBox(height: 32),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildForecastChart(Prediction p) =>
      SignalDetailWidget(prediction: p, drawAnimation: _drawAnim);
}
