import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/widgets/water_management/water_management_models.dart';
import 'package:urban_os/widgets/water_management/water_management_header.dart';
import 'package:urban_os/widgets/water_management/water_management_kpi_strip.dart';
import 'package:urban_os/widgets/water_management/water_management_tab_bar.dart';
import 'package:urban_os/widgets/water_management/water_management_tab_body.dart';
import 'package:urban_os/widgets/water_management/water_management_painters.dart';

class WaterManagementScreen extends StatefulWidget {
  const WaterManagementScreen({super.key});

  @override
  State<WaterManagementScreen> createState() => _WMState();
}

class _WMState extends State<WaterManagementScreen>
    with TickerProviderStateMixin {
  late List<WaterTank> tanks;
  late List<WaterPipe> pipes;
  late List<WaterPump> pumps;
  late List<DistZone> zones;
  late List<WaterAlert> alerts;
  late List<HrUsage> hourly;

  int tab = 0;
  bool liveData = true;
  int? selTank;
  int? selPump;

  late AnimationController bgCtrl;
  late AnimationController glowCtrl;
  late AnimationController waveCtrl;
  late AnimationController flowCtrl;
  late AnimationController blinkCtrl;
  late AnimationController pulseCtrl;
  late AnimationController scanCtrl;
  late AnimationController entCtrl;
  late AnimationController liveCtrl;

  @override
  void initState() {
    super.initState();
    tanks = buildTanks();
    pipes = buildPipes();
    pumps = buildPumps();
    zones = buildZones();
    alerts = buildAlerts();
    hourly = buildHourly();
    _initAnims();
    entCtrl.forward();
  }

  void _initAnims() {
    bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    flowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
    entCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    liveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    liveCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && liveData && mounted) {
        _tick();
      }
    });
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      for (final t in tanks) {
        if (t.status == TankStatus.isolated) continue;
        final d =
            (t.inflow - t.outflow) * .0015 +
            (Random().nextDouble() - .45) * .25;
        t.levelPct = (t.levelPct + d).clamp(0, 100);
        if (t.levelPct <= 15) {
          t.status = TankStatus.critical;
        } else if (t.levelPct <= 30) {
          t.status = TankStatus.low;
        } else if (t.levelPct >= 97) {
          t.status = TankStatus.overflow;
        } else if (t.inflow > t.outflow + 4) {
          t.status = TankStatus.filling;
        } else if (t.outflow > t.inflow + 4) {
          t.status = TankStatus.draining;
        } else {
          t.status = TankStatus.normal;
        }
      }

      for (final p in pumps) {
        if (p.status != PumpStatus.running) continue;
        p.flowRateLS = (p.flowRateLS + (Random().nextDouble() - .5) * 2.5)
            .clamp(0, 150);
        p.pressureBar = (p.pressureBar + (Random().nextDouble() - .5) * .12)
            .clamp(0, 8);
      }

      for (final p in pipes) {
        if (!p.status.isActive) continue;
        p.flowRate = (p.flowRate + (Random().nextDouble() - .5) * 3).clamp(
          0,
          p.maxFlow,
        );
        p.pressureBar = (p.pressureBar + (Random().nextDouble() - .5) * .09)
            .clamp(0, 8);
      }
    });
  }

  @override
  void dispose() {
    for (final c in [
      bgCtrl,
      glowCtrl,
      waveCtrl,
      flowCtrl,
      blinkCtrl,
      pulseCtrl,
      scanCtrl,
      entCtrl,
      liveCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double get totalSupply => pumps
      .where((p) => p.status == PumpStatus.running)
      .fold(0.0, (s, p) => s + p.flowRateLS);
  double get totalDemand => zones.fold(0.0, (s, z) => s + z.demandLS);
  double get avgPressure {
    final fl = pipes.where((p) => p.status.isActive).toList();
    if (fl.isEmpty) return 0;
    return fl.fold(0.0, (s, p) => s + p.pressureBar) / fl.length;
  }

  double get avgTankLevel =>
      tanks.fold(0.0, (s, t) => s + t.levelPct) / tanks.length;
  int get activePumps =>
      pumps.where((p) => p.status == PumpStatus.running).length;
  int get faultPumps => pumps.where((p) => p.status == PumpStatus.fault).length;
  double get totalLeakLS => pipes.fold(
    0.0,
    (s, p) => s + (p.hasLeak ? p.flowRate * p.leakPct / 100 : 0),
  );
  int get leakCount => pipes.where((p) => p.hasLeak).length;
  int get critUnacked =>
      alerts.where((a) => a.level == AlertLevel.critical && !a.acked).length;
  int get warnUnacked =>
      alerts.where((a) => a.level == AlertLevel.warning && !a.acked).length;
  int get totalUnacked => alerts.where((a) => !a.acked).length;

  @override
  Widget build(BuildContext context) {
    final kpis = [
      KpiDef(
        Icons.water_drop_rounded,
        'AVG LEVEL',
        '${avgTankLevel.toStringAsFixed(1)}%',
        C.cyan,
        '${tanks.where((t) => t.status.isAlert).length} alert',
      ),
      KpiDef(
        Icons.speed_rounded,
        'SUPPLY',
        '${totalSupply.toStringAsFixed(0)} L/s',
        C.teal,
        'of ${totalDemand.toStringAsFixed(0)} L/s',
      ),
      KpiDef(
        Icons.compress_rounded,
        'PRESSURE',
        '${avgPressure.toStringAsFixed(1)} bar',
        C.sky,
        'avg active',
      ),
      KpiDef(
        Icons.bolt_rounded,
        'PUMPS',
        '$activePumps/${pumps.length}',
        C.green,
        faultPumps > 0 ? '$faultPumps fault' : 'all ok',
        faultPumps > 0 ? C.red : null,
      ),
      KpiDef(
        Icons.leak_add_rounded,
        'LEAKS',
        '$leakCount',
        leakCount > 0 ? C.amber : C.teal,
        '${totalLeakLS.toStringAsFixed(1)} L/s',
        leakCount > 0 ? C.amber : null,
      ),
      KpiDef(
        Icons.health_and_safety_rounded,
        'HEALTH',
        '${((avgTankLevel * .3 + (totalDemand > 0 ? (totalSupply / totalDemand * 100) : 100) * .3 + (activePumps / max(1, pumps.length) * 100) * .2 + (100 - leakCount * 20).clamp(0, 100) * .2).clamp(0, 100)).toStringAsFixed(0)}%',
        C.green,
        'GOOD',
      ),
    ];

    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: AlwaysStoppedAnimation(flowCtrl.value),
            builder: (_, __) => CustomPaint(
              painter: BgPainter(t: flowCtrl.value, glow: pulseCtrl.value),
              size: Size.infinite,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: AlwaysStoppedAnimation(flowCtrl.value),
              builder: (_, __) => CustomPaint(
                painter: WavePainter(flowCtrl.value),
                size: Size(MediaQuery.of(context).size.width, 100),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: AlwaysStoppedAnimation(0),
            builder: (_, __) => Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      C.cyan.withOpacity(.04),
                      C.cyan.withOpacity(.09),
                      C.cyan.withOpacity(.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                WaterManagementHeader(
                  liveData: liveData,
                  critUnacked: critUnacked,
                  onBack: () => Navigator.maybePop(context),
                  onToggleLive: () => setState(() => liveData = !liveData),
                  onShowCritical: () => setState(() => tab = 5),
                  blinkAnim: AlwaysStoppedAnimation(blinkCtrl.value),
                ),
                WaterManagementKpiStrip(items: kpis),
                WaterManagementTabBar(
                  selectedTab: tab,
                  totalUnacked: totalUnacked,
                  criticalUnacked: critUnacked,
                  onTabChanged: (i) => setState(() => tab = i),
                ),
                Expanded(
                  child: WaterManagementTabBody(
                    tab: tab,
                    liveData: liveData,
                    tanks: tanks,
                    pipes: pipes,
                    pumps: pumps,
                    zones: zones,
                    alerts: alerts,
                    hourly: hourly,
                    selectedTank: selTank,
                    selectedPump: selPump,
                    flowAnimValue: flowCtrl.value,
                    blinkAnimValue: blinkCtrl.value,
                    pulseAnimValue: pulseCtrl.value,
                    onTabChange: (i) => setState(() => tab = i),
                    onTankSelect: (i) => setState(() => selTank = i),
                    onPumpSelect: (i) => setState(() => selPump = i),
                    onLiveDataToggle: (value) =>
                        setState(() => liveData = value),
                    onShowAlertTab: () => setState(() => tab = 5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
