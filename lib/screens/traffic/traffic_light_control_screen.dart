import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/infrastructure_provider.dart';
import 'package:urban_os/providers/sensor/sensor_provider.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/bg_painter.dart';
import 'package:urban_os/widgets/traffic_light_control/filter_tab.dart';
import 'package:urban_os/widgets/traffic_light_control/summary_strip.dart';
import 'package:urban_os/widgets/traffic_light_control/header.dart';
import 'package:urban_os/widgets/traffic_light_control/traffic_control_body.dart';

// ─────────────────────────────────────────
//  COLORS
// ─────────────────────────────────────────
typedef C = AppColors;

const kAccent = C.cyan;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class TrafficLightControlScreen extends StatefulWidget {
  const TrafficLightControlScreen({super.key});

  @override
  State<TrafficLightControlScreen> createState() => _TrafficLightControlState();
}

class _TrafficLightControlState extends State<TrafficLightControlScreen>
    with TickerProviderStateMixin {
  late List<Intersection> _intersections;
  int _selectedIdx = 0;
  int _activeTab = 0;

  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _tickCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _signalGlowCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _intersections = buildIntersections();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final infraProvider = context.read<InfrastructureProvider>();
        final roads = infraProvider.roads;
        final sensorProvider = context.read<SensorProvider>();
        final sensors = sensorProvider.sensors;
        if (roads.isNotEmpty && sensors.isNotEmpty) {
          setState(() {
            _intersections = buildIntersectionsFromProviders(roads, sensors);
            if (_intersections.isEmpty) _intersections = buildIntersections();
          });
        }
      } catch (e) {
        debugPrint('Failed to load from providers: $e');
      }
    });

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
    _signalGlowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _tickCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
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

    _tickCtrl.addListener(_onTick);
    _entranceCtrl.forward();
  }

  void _onTick() {
    if (!mounted) return;
    if (_tickCtrl.value < 0.02) {
      setState(() {
        for (final ix in _intersections) {
          if (ix.isEmergencyOverride) continue;
          ix.timer = (ix.timer - 1).clamp(0, 999);
          if (ix.timer == 0) _advancePhase(ix);
        }
      });
    }
  }

  void _advancePhase(Intersection ix) {
    ix.phase = ix.phase.next;
    ix.timer = ix.phase == SignalPhase.green
        ? ix.greenDuration
        : ix.phase == SignalPhase.yellow
        ? ix.yellowDuration
        : ix.redDuration;
  }

  List<Intersection> get _filtered {
    switch (_activeTab) {
      case 1:
        return _intersections
            .where((i) => i.phase == SignalPhase.green)
            .toList();
      case 2:
        return _intersections
            .where((i) => i.phase == SignalPhase.yellow)
            .toList();
      case 3:
        return _intersections.where((i) => i.phase == SignalPhase.red).toList();
      default:
        return _intersections;
    }
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _tickCtrl.dispose();
    _entranceCtrl.dispose();
    _signalGlowCtrl.dispose();
    super.dispose();
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
                    SignalControlHeader(
                      onEmergency: _showEmergencyDialog,
                      onBack: () => Navigator.maybePop(ctx),
                      onSettings: () {},
                    ),
                    SummaryStrip(
                      intersections: _intersections,
                      glowCtrl: _glowCtrl,
                      blinkCtrl: _blinkCtrl,
                    ),
                    FilterTabs(
                      activeTab: _activeTab,
                      onTabChanged: (idx) {
                        setState(() {
                          _activeTab = idx;
                        });
                      },
                    ),
                    Expanded(
                      child: TrafficControlBody(
                        intersections: _intersections,
                        filteredIntersections: _filtered,
                        selectedIdx: _selectedIdx,
                        glowCtrl: _glowCtrl,
                        blinkCtrl: _blinkCtrl,
                        pulseCtrl: _pulseCtrl,
                        onSelectedIdxChanged: (idx) {
                          setState(() {
                            _selectedIdx = idx;
                          });
                        },
                        buildDetailPanel: (Intersection ix) {
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ix.name,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Phase: ${ix.phase.name.toUpperCase()}'),
                                Text('Timer: ${ix.timer}s'),
                                if (ix.isAdaptive) const Text('Adaptive: Yes'),
                              ],
                            ),
                          );
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

  // ── Emergency Dialog ──
  void _showEmergencyDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      barrierColor: Colors.black87,
      builder: (_) => AlertDialog(
        backgroundColor: C.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: C.red.withOpacity(0.4)),
        ),
        title: Row(
          children: const [
            Icon(Icons.emergency_rounded, color: C.red, size: 20),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'EMERGENCY ALL-RED',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: C.red,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'Forces ALL intersections to RED phase indefinitely. '
          'Use only during emergencies.',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            color: C.mutedLt,
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                color: C.mutedLt,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                for (final ix in _intersections) {
                  ix.phase = SignalPhase.red;
                  ix.timer = 999;
                  ix.isEmergencyOverride = true;
                }
              });
              Navigator.pop(ctx);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: C.red.withOpacity(0.15),
                border: Border.all(color: C.red.withOpacity(0.5)),
              ),
              child: const Text(
                'CONFIRM',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  color: C.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
