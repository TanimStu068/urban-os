import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';
import 'package:urban_os/widgets/parking_analytics/filter_tab.dart';
import 'package:urban_os/widgets/parking_analytics/bg_painter.dart';
import 'package:urban_os/widgets/parking_analytics/paking_body.dart';
import 'package:urban_os/widgets/parking_analytics/summary_strip.dart';
import 'package:urban_os/widgets/parking_analytics/parking_analysis_header.dart';

typedef C = AppColors;

const kAccent = C.cyan;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class ParkingAnalyticsScreen extends StatefulWidget {
  const ParkingAnalyticsScreen({super.key});
  @override
  State<ParkingAnalyticsScreen> createState() => _ParkingAnalyticsState();
}

class _ParkingAnalyticsState extends State<ParkingAnalyticsScreen>
    with TickerProviderStateMixin {
  int _selectedLotIdx = 0;
  late ValueNotifier<int> _chartMode; // 0=occupancy 1=revenue
  int _activeTab = 0; // 0=All 1=Available 2=Full

  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _chartCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _slotCtrl;
  late AnimationController _tickCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  // Simulated live: small random drift on occupied counts
  late List<int> _liveOccupied;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _liveOccupied = lots.map((l) => l.occupied).toList();
    _chartMode = ValueNotifier(0);

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _chartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _slotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _tickCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.06), end: Offset.zero));

    _tickCtrl.addListener(_tickLive);
    _entranceCtrl.forward();
  }

  void _tickLive() {
    if (!mounted) return;
    if (_tickCtrl.value < 0.015) {
      setState(() {
        for (int i = 0; i < _liveOccupied.length; i++) {
          final delta = _rng.nextInt(3) - 1; // -1, 0, +1
          _liveOccupied[i] = (_liveOccupied[i] + delta).clamp(
            0,
            lots[i].totalSpaces,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _chartCtrl.dispose();
    _slotCtrl.dispose();
    _tickCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  List<ParkingLot> get _filteredLots {
    switch (_activeTab) {
      case 1:
        return lots.where((l) => l.status == ParkingStatus.available).toList();
      case 2:
        return lots
            .where(
              (l) =>
                  l.status == ParkingStatus.full ||
                  l.status == ParkingStatus.filling,
            )
            .toList();
      default:
        return lots;
    }
  }

  // Totals
  int get _totalSpaces => lots.fold(0, (s, l) => s + l.totalSpaces);
  int get _totalOccupied => _liveOccupied.fold(0, (s, v) => s + v);
  int get _totalAvailable => _totalSpaces - _totalOccupied;
  double get _totalOccupancyRate => _totalOccupied / _totalSpaces;
  double get _totalRevenue => lots.fold(0.0, (s, l) => s + l.totalRevenue);

  List<Prediction> getPredictions(ParkingLot lot, double rate) {
    // Mock predictions
    return [];
  }

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
              painter: BgPainter(t: _bgCtrl.value),
              size: Size.infinite,
            ),
          ),
          AnimatedBuilder(
            animation: _scanCtrl,
            builder: (_, __) => Positioned(
              top: _scanCtrl.value * size.height,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      kAccent.withOpacity(0.05),
                      kAccent.withOpacity(0.1),
                      kAccent.withOpacity(0.05),
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
                    ParkingAnalyticsHeader(
                      blinkCtrl: _blinkCtrl,
                      lots: lots,
                      onBack: () => Navigator.pop(context),
                      onFilter: () => print('Filter tapped'),
                      onMore: () => print('More tapped'),
                    ),
                    SummaryStrip(
                      totalSpaces: _totalSpaces,
                      totalOccupied: _totalOccupied,
                      totalAvailable: _totalAvailable,
                      totalOccupancyRate: _totalOccupancyRate,
                      totalRevenue: _totalRevenue,
                      glowCtrl: _glowCtrl,
                      blinkCtrl: _blinkCtrl,
                    ),
                    FilterTabs(
                      activeTab: _activeTab,
                      onTabChanged: (idx) {
                        setState(() {
                          _activeTab = idx;
                          // optionally filter your list here based on the tab
                        });
                      },
                    ),
                    Expanded(
                      child: ParkingBody(
                        filteredLots: _filteredLots,
                        selectedLotIdx: _selectedLotIdx,
                        liveOccupied: _liveOccupied,
                        glowCtrl: _glowCtrl,
                        blinkCtrl: _blinkCtrl,
                        chartCtrl: _chartCtrl,
                        slotCtrl: _slotCtrl,
                        pulseCtrl: _pulseCtrl,
                        chartMode: _chartMode,
                        getPredictions: getPredictions,
                        onLotSelected: (idx) {
                          setState(() {
                            _selectedLotIdx = idx;
                            _chartCtrl.forward(from: 0);
                            _slotCtrl.forward(from: 0);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
