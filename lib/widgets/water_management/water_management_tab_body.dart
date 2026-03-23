import 'dart:math';
import 'package:flutter/material.dart';
import 'water_management_models.dart';
import 'water_management_shared.dart';
import 'water_management_painters.dart';

class WaterManagementTabBody extends StatelessWidget {
  final int tab;
  final bool liveData;
  final List<WaterTank> tanks;
  final List<WaterPipe> pipes;
  final List<WaterPump> pumps;
  final List<DistZone> zones;
  final List<WaterAlert> alerts;
  final List<HrUsage> hourly;
  final int? selectedTank;
  final int? selectedPump;
  final double flowAnimValue;
  final double blinkAnimValue;
  final double pulseAnimValue;
  final void Function(int index) onTabChange;
  final void Function(int? index) onTankSelect;
  final void Function(int? index) onPumpSelect;
  final void Function(bool value) onLiveDataToggle;
  final void Function() onShowAlertTab;

  const WaterManagementTabBody({
    super.key,
    required this.tab,
    required this.liveData,
    required this.tanks,
    required this.pipes,
    required this.pumps,
    required this.zones,
    required this.alerts,
    required this.hourly,
    required this.selectedTank,
    required this.selectedPump,
    required this.flowAnimValue,
    required this.blinkAnimValue,
    required this.pulseAnimValue,
    required this.onTabChange,
    required this.onTankSelect,
    required this.onPumpSelect,
    required this.onLiveDataToggle,
    required this.onShowAlertTab,
  });

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
  double get healthScore {
    final ts = avgTankLevel;
    final ss = (totalDemand > 0 ? (totalSupply / totalDemand * 100) : 100)
        .clamp(0, 100);
    final ps = (activePumps / max(1, pumps.length) * 100);
    final ls = (100 - leakCount * 20.0).clamp(0, 100);
    return (ts * .3 + ss * .3 + ps * .2 + ls * .2).clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(.02, 0),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey(tab),
        child: switch (tab) {
          0 => _tabOverview(),
          1 => _tabTanks(),
          2 => _tabNetwork(),
          3 => _tabPumps(),
          4 => _tabQuality(),
          5 => _tabAlerts(),
          _ => const SizedBox(),
        },
      ),
    );
  }

  Widget _tabOverview() => ListView(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _supplyDemandCard()),
          const SizedBox(width: 10),
          Expanded(child: _systemHealthCard()),
        ],
      ),
      const SizedBox(height: 10),
      _tankCarouselSection(),
      const SizedBox(height: 10),
      _hourlyChartCard(),
      const SizedBox(height: 10),
      _zoneOverviewCard(),
      const SizedBox(height: 10),
      _alertPreviewCard(),
    ],
  );

  Widget _supplyDemandCard() {
    final ratio = (totalDemand > 0
        ? (totalSupply / totalDemand).clamp(0, 1.5)
        : 1.0);
    final fill = (ratio).clamp(0, 1.0);
    final sc = ratio >= 1.0
        ? C.teal
        : ratio >= 0.85
        ? C.amber
        : C.red;
    return WaterGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.swap_vert_rounded, color: C.cyan, size: 14),
              const SizedBox(width: 6),
              WaterLabel(text: 'SUPPLY / DEMAND', size: 9, letterSpacing: 1.0),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: CustomPaint(
              painter: SDArcPainter(fill.toDouble(), sc),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(ratio * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: sc,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                    ),
                    WaterLabel(text: 'COVERED', color: C.mutedHi, size: 8),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _sdRow('SUPPLY', '${totalSupply.toStringAsFixed(0)} L/s', C.teal),
          const SizedBox(height: 4),
          _sdRow('DEMAND', '${totalDemand.toStringAsFixed(0)} L/s', C.cyan),
          const SizedBox(height: 4),
          _sdRow(
            'DEFICIT',
            ratio < 1
                ? '${(totalDemand - totalSupply).toStringAsFixed(0)} L/s'
                : '—',
            ratio < 1 ? C.red : C.mutedHi,
          ),
        ],
      ),
    );
  }

  Widget _sdRow(String label, String value, Color color) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      WaterLabel(text: label, size: 9),
      Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
        ),
      ),
    ],
  );

  Widget _systemHealthCard() {
    final s = healthScore;
    final c = s >= 70
        ? C.green
        : s >= 50
        ? C.amber
        : C.red;
    final label = s >= 80
        ? 'OPTIMAL'
        : s >= 65
        ? 'GOOD'
        : s >= 50
        ? 'FAIR'
        : 'DEGRADED';

    return WaterGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.health_and_safety_rounded, color: c, size: 14),
              const SizedBox(width: 6),
              WaterLabel(text: 'SYSTEM HEALTH', size: 9, letterSpacing: 1.0),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: CustomPaint(
              painter: HealthRingPainter(s / 100, c, pulseAnimValue),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${s.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: c,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                    ),
                    WaterLabel(text: label, color: c.withOpacity(.8), size: 8),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _hRow('TANK LEVELS', avgTankLevel / 100, C.cyan),
          const SizedBox(height: 5),
          _hRow('PUMP STATUS', activePumps / pumps.length, C.green),
          const SizedBox(height: 5),
          _hRow(
            'PIPE NETWORK',
            (1 - leakCount / pipes.length * .5).clamp(0, 1),
            C.sky,
          ),
        ],
      ),
    );
  }

  Widget _hRow(String label, double value, Color color) {
    final pct = value.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WaterLabel(text: label, size: 8.5),
            WaterLabel(
              text: '${(pct * 100).toStringAsFixed(0)}%',
              color: color,
              size: 8.5,
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Stack(
            children: [
              Container(height: 4, color: C.muted.withOpacity(.3)),
              FractionallySizedBox(
                widthFactor: pct,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(.6), color],
                    ),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(.4), blurRadius: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tankCarouselSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(Icons.water_rounded, color: C.cyan, size: 13),
            const SizedBox(width: 6),
            WaterLabel(
              text: 'STORAGE TANKS',
              size: 9.5,
              color: C.mutedHi,
              letterSpacing: 1.2,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => onTabChange(1),
              child: WaterLabel(
                text: 'VIEW ALL ›',
                color: C.cyan,
                size: 9,
                letterSpacing: .8,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 128,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tanks.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => _miniTankCard(tanks[i]),
        ),
      ),
    ],
  );

  Widget _miniTankCard(WaterTank t) {
    final blink = t.status.isAlert ? blinkAnimValue : 1.0;
    return Container(
      width: 110,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: C.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: t.status.color.withOpacity(
            t.status.isAlert ? .3 * blink + .1 : .2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: t.status.color.withOpacity(
              t.status.isAlert ? .08 * blink : .04,
            ),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(t.status.icon, color: t.status.color, size: 12),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: t.status.color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: WaterLabel(
                  text: t.status.label,
                  color: t.status.color,
                  size: 7,
                  letterSpacing: .5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            t.id,
            style: TextStyle(
              color: t.status.color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            t.name,
            style: const TextStyle(
              color: C.white,
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WaterLabel(text: 'LEVEL', size: 7.5),
              WaterLabel(
                text: '${t.levelPct.toStringAsFixed(0)}%',
                color: t.status.color,
                size: 8.5,
              ),
            ],
          ),
          const SizedBox(height: 3),
          Stack(
            children: [
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: C.muted.withOpacity(.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: t.levelPct / 100,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [t.status.color.withOpacity(.6), t.status.color],
                    ),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: t.status.color.withOpacity(.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hourlyChartCard() => WaterGlassCard(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: C.sky, size: 14),
            const SizedBox(width: 6),
            WaterLabel(text: '24-HOUR FLOW PATTERN', size: 9.5),
            const Spacer(),
            Row(
              children: [
                WaterDot(C.teal, 3),
                const SizedBox(width: 4),
                WaterLabel(text: 'SUPPLY', color: C.teal, size: 8),
              ],
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                WaterDot(C.cyan, 3),
                const SizedBox(width: 4),
                WaterLabel(text: 'USAGE', color: C.cyan, size: 8),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 110,
          child: CustomPaint(
            painter: HourlyPainter(hourly, flowAnimValue),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [0, 4, 8, 12, 16, 20, 23].map((h) {
            final label = h == 0
                ? '12A'
                : h < 12
                ? '${h}A'
                : h == 12
                ? '12P'
                : '${h - 12}P';
            return WaterLabel(text: label, size: 7.5, color: C.mutedHi);
          }).toList(),
        ),
      ],
    ),
  );

  Widget _zoneOverviewCard() => WaterGlassCard(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.map_rounded, color: C.violet, size: 14),
            const SizedBox(width: 6),
            WaterLabel(text: 'DISTRIBUTION ZONES', size: 9.5),
            const Spacer(),
            GestureDetector(
              onTap: () => onTabChange(2),
              child: WaterLabel(
                text: 'NETWORK ›',
                color: C.cyan,
                size: 9,
                letterSpacing: .8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Correctly spread the map results into the children list
        ...zones
            .map(
              (z) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: z.type.color.withOpacity(.1),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: z.type.color.withOpacity(.2)),
                      ),
                      child: Icon(z.type.icon, color: z.type.color, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  z.name,
                                  style: const TextStyle(
                                    color: C.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              WaterLabel(
                                text:
                                    '${z.supplyLS.toStringAsFixed(0)}/${z.demandLS.toStringAsFixed(0)} L/s',
                                color: z.statusColor,
                                size: 9,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Stack(
                            children: [
                              Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: C.muted.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: z.ratio.clamp(0, 1.0),
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        z.statusColor.withOpacity(.6),
                                        z.statusColor,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: z.statusColor.withOpacity(.4),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: z.statusColor.withOpacity(.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: z.statusColor.withOpacity(.25),
                        ),
                      ),
                      child: Text(
                        '${(z.ratio * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: z.statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(), // <--- important
      ],
    ),
  );

  // Widget _zoneOverviewCard() => WaterGlassCard(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //   Row(children: [Icon(Icons.map_rounded, color: C.violet, size: 14), const SizedBox(width: 6), WaterLabel(text: 'DISTRIBUTION ZONES', size: 9.5), const Spacer(),
  //     GestureDetector(onTap: () => onTabChange(2), child: WaterLabel(text: 'NETWORK ›', color: C.cyan, size: 9, letterSpacing: .8)),
  //   ]),
  //   const SizedBox(height: 12),
  //   ...zones.map((z) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
  //     Container(width: 28, height: 28, decoration: BoxDecoration(color: z.type.color.withOpacity(.1), borderRadius: BorderRadius.circular(7), border: Border.all(color: z.type.color.withOpacity(.2))), child: Icon(z.type.icon, color: z.type.color, size: 14)),
  //     const SizedBox(width: 8),
  //     Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       Row(children: [Expanded(child: Text(z.name, style: const TextStyle(color: C.white, fontSize: 11, fontWeight: FontWeight.w600))), WaterLabel(text: '${z.supplyLS.toStringAsFixed(0)}/${z.demandLS.toStringAsFixed(0)} L/s', color: z.statusColor, size: 9)]),
  //       const SizedBox(height: 4),
  //       Stack(children: [
  //         Container(height: 3, decoration: BoxDecoration(color: C.muted.withOpacity(.3), borderRadius: BorderRadius.circular(2))),
  //         FractionallySizedBox(widthFactor: z.ratio.clamp(0, 1.0), child: Container(height: 3, decoration: BoxDecoration(gradient: LinearGradient(colors: [z.statusColor.withOpacity(.6), z.statusColor]), borderRadius: BorderRadius.circular(2), boxShadow: [BoxShadow(color: z.statusColor.withOpacity(.4), blurRadius: 3)]))),
  //       ]),
  //     ])),
  //     const SizedBox(width: 8),
  //     Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: BoxDecoration(color: z.statusColor.withOpacity(.1), borderRadius: BorderRadius.circular(5), border: Border.all(color: z.statusColor.withOpacity(.25))), child: Text('${(z.ratio * 100).toStringAsFixed(0)}%', style: TextStyle(color: z.statusColor, fontSize: 10, fontWeight: FontWeight.w800, fontFamily: 'monospace'))),
  //   ])).
  // ]));

  Widget _alertPreviewCard() {
    final unacked = alerts.where((a) => !a.acked).take(3).toList();

    return WaterGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: AlwaysStoppedAnimation(blinkAnimValue),
                builder: (_, __) => Icon(
                  Icons.notifications_active_rounded,
                  color: critUnacked > 0
                      ? C.red.withOpacity(.5 + blinkAnimValue * .5)
                      : C.amber,
                  size: 14,
                ),
              ),
              const SizedBox(width: 6),
              WaterLabel(text: 'ACTIVE ALERTS', size: 9.5),
              const SizedBox(width: 8),
              if (critUnacked > 0)
                WaterBadge(text: '$critUnacked', color: C.red),
              const SizedBox(width: 4),
              if (warnUnacked > 0)
                WaterBadge(text: '$warnUnacked', color: C.amber),
              const Spacer(),
              GestureDetector(
                onTap: onShowAlertTab,
                child: WaterLabel(
                  text: 'ALL ›',
                  color: C.cyan,
                  size: 9,
                  letterSpacing: .8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (unacked.isEmpty)
            Row(
              children: [
                Icon(Icons.check_circle_rounded, color: C.green, size: 14),
                const SizedBox(width: 6),
                WaterLabel(text: 'NO ACTIVE ALERTS', color: C.green, size: 9),
              ],
            )
          else
            ...unacked.map(_alertRow),
        ],
      ),
      borderColor: critUnacked > 0 ? C.red.withOpacity(.2) : C.gBdr,
    );
  }

  Widget _alertRow(WaterAlert a) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: a.level.color.withOpacity(.06),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: a.level.color.withOpacity(.2)),
    ),
    child: Row(
      children: [
        Icon(a.level.icon, color: a.level.color, size: 13),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                a.message,
                style: TextStyle(
                  color: C.white.withOpacity(.9),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  WaterLabel(text: a.source, color: a.level.color, size: 8),
                  const SizedBox(width: 6),
                  WaterDot(C.mutedHi.withOpacity(.4), 2),
                  const SizedBox(width: 6),
                  WaterLabel(text: a.time, color: C.mutedHi, size: 8),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: a.level.color.withOpacity(.12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: WaterLabel(
            text: a.level.label,
            color: a.level.color,
            size: 7.5,
          ),
        ),
      ],
    ),
  );

  Widget _tabTanks() => ListView.separated(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
    separatorBuilder: (_, __) => const SizedBox(height: 10),
    itemCount: tanks.length,
    itemBuilder: (_, i) => _tankDetailCard(tanks[i], i),
  );

  Widget _tankDetailCard(WaterTank tank, int index) {
    final selected = selectedTank == index;
    return GestureDetector(
      onTap: () => onTankSelect(selected ? null : index),
      child: Container(
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: tank.status.color.withOpacity(
              tank.status.isAlert
                  ? .35 * (tank.status.isAlert ? blinkAnimValue : 1.0)
                  : .18,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: tank.status.color.withOpacity(
                tank.status.isAlert ? .1 * blinkAnimValue : .04,
              ),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    height: 60,
                    child: CustomPaint(
                      painter: TankVizPainter(
                        tank.levelPct / 100,
                        tank.status.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              tank.id,
                              style: TextStyle(
                                color: tank.status.color,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: tank.status.color.withOpacity(.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: WaterLabel(
                                text: tank.status.label,
                                color: tank.status.color,
                                size: 7.5,
                              ),
                            ),
                            if (tank.autoRefill) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: C.cyan.withOpacity(.08),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: WaterLabel(
                                  text: 'AUTO',
                                  color: C.cyan,
                                  size: 7,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tank.name,
                          style: const TextStyle(
                            color: C.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        WaterLabel(
                          text: tank.location,
                          size: 9,
                          color: C.mutedHi,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${tank.levelPct.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: tank.status.color,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'monospace',
                        ),
                      ),
                      WaterLabel(
                        text:
                            '${tank.volumeML.toStringAsFixed(1)} / ${tank.capacityML.toStringAsFixed(0)} ML',
                        size: 8.5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: C.muted.withOpacity(.25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: tank.levelPct / 100,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            tank.status.color.withOpacity(.5),
                            tank.status.color,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: tank.status.color.withOpacity(.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Row(
                children: [
                  _flowChip(
                    Icons.arrow_upward_rounded,
                    'IN',
                    '${tank.inflow.toStringAsFixed(0)} L/s',
                    C.green,
                  ),
                  const SizedBox(width: 10),
                  _flowChip(
                    Icons.arrow_downward_rounded,
                    'OUT',
                    '${tank.outflow.toStringAsFixed(0)} L/s',
                    C.red,
                  ),
                  const SizedBox(width: 10),
                  _flowChip(
                    Icons.swap_vert_rounded,
                    'NET',
                    '${tank.netFlow >= 0 ? '+' : ''}${tank.netFlow.toStringAsFixed(0)} L/s',
                    tank.netFlow >= 0 ? C.cyan : C.amber,
                  ),
                  const Spacer(),
                  _flowChip(
                    Icons.science_outlined,
                    'QUAL',
                    tank.quality.label,
                    tank.quality.color,
                  ),
                ],
              ),
            ),
            if (selected) ...[
              Divider(color: C.cyan.withOpacity(.08), height: 1),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _paramChip(
                            'TEMP',
                            '${tank.tempC.toStringAsFixed(1)}°C',
                            C.sky,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: _paramChip(
                            'pH',
                            tank.ph.toStringAsFixed(2),
                            _phColor(tank.ph),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: _paramChip(
                            'TURB',
                            '${tank.turbidity.toStringAsFixed(2)}',
                            _turbidityColor(tank.turbidity),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: _paramChip(
                            'CL₂',
                            '${tank.chlorine.toStringAsFixed(2)}',
                            _chlorineColor(tank.chlorine),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: CustomPaint(
                        painter: MiniLinePainter(
                          tank.levelHistory,
                          tank.status.color,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    WaterLabel(
                      text: '24-HOUR LEVEL HISTORY',
                      color: C.mutedHi,
                      size: 8,
                      letterSpacing: .8,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _flowChip(IconData icon, String label, String value, Color c) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: c, size: 11),
      const SizedBox(width: 3),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WaterLabel(text: label, size: 7.5),
          Text(
            value,
            style: TextStyle(
              color: c,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    ],
  );

  Widget _paramChip(String label, String value, Color c) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: c.withOpacity(.07),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: c.withOpacity(.18)),
    ),
    child: Column(
      children: [
        WaterLabel(text: label, size: 7.5, color: C.mutedHi),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: c,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          ),
        ),
      ],
    ),
  );

  Color _phColor(double value) =>
      value >= 6.5 && value <= 8.5 ? C.teal : C.amber;
  Color _turbidityColor(double value) => value < 0.5
      ? C.teal
      : value < 1.0
      ? C.amber
      : C.red;
  Color _chlorineColor(double value) =>
      value >= 0.2 && value <= 1.0 ? C.teal : C.amber;

  Widget _tabNetwork() {
    final flowing = pipes.where((p) => p.status == PipeStatus.flowing).length;
    final burst = pipes.where((p) => p.status == PipeStatus.burst).length;
    final totalFlow = pipes
        .where((p) => p.status.isActive)
        .fold(0.0, (a, p) => a + p.flowRate);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Row(
          children: [
            _networkStat(
              Icons.water_drop_rounded,
              'FLOWING',
              '$flowing',
              C.cyan,
            ),
            const SizedBox(width: 8),
            _networkStat(
              Icons.error_rounded,
              'BURST',
              '$burst',
              burst > 0 ? C.red : C.teal,
            ),
            const SizedBox(width: 8),
            _networkStat(
              Icons.speed_rounded,
              'FLOW',
              '${totalFlow.toStringAsFixed(0)} L/s',
              C.teal,
            ),
            const SizedBox(width: 8),
            _networkStat(
              Icons.leak_add_rounded,
              'LEAKS',
              '$leakCount',
              leakCount > 0 ? C.amber : C.teal,
            ),
          ],
        ),
        const SizedBox(height: 12),
        WaterGlassCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.hub_rounded, color: C.cyan, size: 14),
                  const SizedBox(width: 6),
                  WaterLabel(text: 'PIPE NETWORK TOPOLOGY', size: 9.5),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 185,
                child: CustomPaint(
                  painter: TopoPainter(pipes, flowAnimValue),
                  size: Size.infinite,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: PipeStatus.values
                    .map(
                      (ps) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 18, height: 2.5, color: ps.color),
                          const SizedBox(width: 5),
                          WaterLabel(
                            text: ps.label,
                            color: ps.color,
                            size: 8,
                            letterSpacing: .5,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        WaterLabel(
          text: 'ALL PIPES (${pipes.length})',
          size: 9,
          color: C.mutedHi,
        ),
        const SizedBox(height: 8),
        ...pipes.map(_pipeCard).toList(),
      ],
    );
  }

  Widget _networkStat(IconData icon, String label, String value, Color c) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          decoration: BoxDecoration(
            color: C.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.withOpacity(.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: c, size: 16),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: c,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
              WaterLabel(
                text: label,
                size: 7.5,
                color: C.mutedHi,
                letterSpacing: .5,
              ),
            ],
          ),
        ),
      );

  Widget _pipeCard(WaterPipe p) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: C.bgCard,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: p.status.color.withOpacity(p.status.isAlert ? .3 : .15),
      ),
      boxShadow: [
        BoxShadow(
          color: p.status.color.withOpacity(p.status.isAlert ? .08 : .03),
          blurRadius: 8,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            WaterDot(p.status.color),
            const SizedBox(width: 6),
            Text(
              p.id,
              style: TextStyle(
                color: p.status.color,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                p.name,
                style: const TextStyle(
                  color: C.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: p.status.color.withOpacity(.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: WaterLabel(
                text: p.status.label,
                color: p.status.color,
                size: 7.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _pipeStat('FROM', p.fromNode, C.mutedHi)),
            Icon(Icons.arrow_forward_rounded, color: C.mutedHi, size: 12),
            Expanded(
              child: Center(child: _pipeStat('TO', p.toNode, C.mutedHi)),
            ),
            Expanded(
              child: _pipeStat(
                'FLOW',
                '${p.flowRate.toStringAsFixed(0)}/${p.maxFlow.toStringAsFixed(0)}',
                C.cyan,
              ),
            ),
            Expanded(
              child: _pipeStat(
                'BAR',
                '${p.pressureBar.toStringAsFixed(1)}',
                C.sky,
              ),
            ),
            Expanded(
              child: _pipeStat(
                '⌀',
                '${p.diameterMM.toStringAsFixed(0)}mm',
                C.violet.withOpacity(.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: C.muted.withOpacity(.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            FractionallySizedBox(
              widthFactor: p.utilPct / 100,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [p.status.color.withOpacity(.5), p.status.color],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        if (p.hasLeak) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: C.red.withOpacity(.08),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: C.red.withOpacity(.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.leak_add_rounded, color: C.red, size: 11),
                const SizedBox(width: 4),
                WaterLabel(
                  text: 'LEAK — ${p.leakPct.toStringAsFixed(1)}% LOSS',
                  color: C.red,
                  size: 8.5,
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );

  Widget _pipeStat(String label, String value, Color color) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      WaterLabel(text: label, size: 7.5),
      Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
        ),
      ),
    ],
  );

  Widget _tabPumps() {
    final runningSum = pumps
        .where((p) => p.status == PumpStatus.running)
        .length;
    final standbySum = pumps
        .where((p) => p.status == PumpStatus.standby)
        .length;
    final faultSum = pumps.where((p) => p.status == PumpStatus.fault).length;
    final kwSum = pumps.fold(0.0, (a, p) => a + p.powerKW).toStringAsFixed(0);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Row(
          children: [
            _pumpStatusCard(
              'RUNNING',
              '$runningSum',
              C.green,
              Icons.play_circle_rounded,
            ),
            const SizedBox(width: 8),
            _pumpStatusCard(
              'STANDBY',
              '$standbySum',
              C.amber,
              Icons.pause_circle_rounded,
            ),
            const SizedBox(width: 8),
            _pumpStatusCard(
              'FAULT',
              '$faultSum',
              faultSum > 0 ? C.red : C.mutedHi,
              Icons.error_rounded,
            ),
            const SizedBox(width: 8),
            _pumpStatusCard('kW', kwSum, C.violet, Icons.bolt_rounded),
          ],
        ),
        const SizedBox(height: 12),
        ...pumps
            .asMap()
            .entries
            .map((entry) => _pumpCard(entry.value, entry.key))
            .toList(),
      ],
    );
  }

  Widget _pumpStatusCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
      decoration: BoxDecoration(
        color: C.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
            ),
          ),
          WaterLabel(
            text: label,
            size: 7.5,
            letterSpacing: .5,
            color: C.mutedHi,
          ),
        ],
      ),
    ),
  );

  Widget _pumpCard(WaterPump pump, int index) {
    final selected = selectedPump == index;
    final isRunning = pump.status == PumpStatus.running;
    final isFault = pump.status == PumpStatus.fault;

    return GestureDetector(
      onTap: () => onPumpSelect(selected ? null : index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: pump.status.color.withOpacity(isFault ? .4 : .2),
          ),
          boxShadow: [
            BoxShadow(
              color: pump.status.color.withOpacity(isFault ? .1 : .04),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(13),
              child: Row(
                children: [
                  SizedBox(
                    width: 46,
                    height: 46,
                    child: CustomPaint(
                      painter: PumpDialPainter(
                        pump.speedPct / 100,
                        pump.status.color,
                        isRunning ? flowAnimValue : 0.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              pump.id,
                              style: TextStyle(
                                color: pump.status.color,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: pump.status.color.withOpacity(.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: WaterLabel(
                                text: pump.status.label,
                                color: pump.status.color,
                                size: 7.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          pump.name,
                          style: const TextStyle(
                            color: C.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        WaterLabel(
                          text: '${pump.zone}  ·  ${pump.runHours}h',
                          size: 8.5,
                          color: C.mutedHi,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${pump.flowRateLS.toStringAsFixed(0)} L/s',
                        style: TextStyle(
                          color: pump.status.color,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'monospace',
                        ),
                      ),
                      WaterLabel(
                        text:
                            '${pump.pressureBar.toStringAsFixed(1)} bar  ·  ${pump.powerKW.toStringAsFixed(0)} kW',
                        size: 8.5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isRunning)
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 0, 13, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WaterLabel(text: 'SPEED', size: 8),
                        WaterLabel(
                          text:
                              '${pump.speedPct.toStringAsFixed(0)}%  EFF ${pump.effPct.toStringAsFixed(0)}%',
                          color: pump.status.color,
                          size: 8.5,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Stack(
                      children: [
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: C.muted.withOpacity(.25),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: pump.speedPct / 100,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [C.green.withOpacity(.5), C.green],
                              ),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(
                                  color: C.green.withOpacity(.4),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (selected) ...[
              Divider(color: C.cyan.withOpacity(.08), height: 1),
              Padding(
                padding: const EdgeInsets.all(13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _paramTile(
                            'NEXT MAINT',
                            pump.nextMaint,
                            C.amber,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: _paramTile(
                            'RUN HOURS',
                            '${pump.runHours}h',
                            C.sky,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: _paramTile(
                            'EFFICIENCY',
                            '${pump.effPct.toStringAsFixed(0)}%',
                            pump.effPct >= 80
                                ? C.teal
                                : pump.effPct >= 65
                                ? C.amber
                                : C.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    WaterLabel(
                      text: 'FLOW HISTORY (24H)',
                      size: 8,
                      color: C.mutedHi,
                      letterSpacing: .8,
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 45,
                      child: CustomPaint(
                        painter: MiniBarPainter(
                          pump.flowHistory,
                          pump.status.color,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                    if (isFault) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: C.red.withOpacity(.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: C.red.withOpacity(.25)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_rounded, color: C.red, size: 14),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Pump fault detected. Scheduled maintenance overdue.',
                                style: TextStyle(
                                  color: C.red.withOpacity(.85),
                                  fontSize: 10.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _paramTile(String label, String value, Color c) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: c.withOpacity(.07),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: c.withOpacity(.15)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WaterLabel(text: label, size: 7.5),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: c,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          ),
        ),
      ],
    ),
  );

  Widget _tabQuality() {
    final exc = tanks.where((t) => t.quality == WaterQuality.excellent).length;
    final good = tanks.where((t) => t.quality == WaterQuality.good).length;
    final fair = tanks.where((t) => t.quality == WaterQuality.fair).length;
    final poor = tanks
        .where(
          (t) =>
              t.quality == WaterQuality.poor ||
              t.quality == WaterQuality.contaminated,
        )
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Row(
          children: [
            _qualityStat('EXCELLENT', '$exc', C.teal),
            const SizedBox(width: 8),
            _qualityStat('GOOD', '$good', C.green),
            const SizedBox(width: 8),
            _qualityStat('FAIR', '$fair', C.sky),
            const SizedBox(width: 8),
            _qualityStat('POOR', '$poor', poor > 0 ? C.red : C.mutedHi),
          ],
        ),
        const SizedBox(height: 12),
        WaterGlassCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.science_rounded, color: C.teal, size: 14),
                  const SizedBox(width: 6),
                  WaterLabel(text: 'WATER QUALITY BY TANK', size: 9.5),
                ],
              ),
              const SizedBox(height: 12),
              ...tanks
                  .map(
                    (tank) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: C.bgCard2,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: tank.quality.color.withOpacity(.18),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              WaterDot(tank.quality.color),
                              const SizedBox(width: 6),
                              Text(
                                tank.id,
                                style: TextStyle(
                                  color: tank.quality.color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  tank.name,
                                  style: const TextStyle(
                                    color: C.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: tank.quality.color.withOpacity(.12),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: WaterLabel(
                                  text: tank.quality.label,
                                  color: tank.quality.color,
                                  size: 8,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _qMetric(
                                  'TEMP',
                                  '${tank.tempC.toStringAsFixed(1)}°C',
                                  C.sky,
                                  Icons.thermostat_rounded,
                                ),
                              ),
                              Expanded(
                                child: _qMetric(
                                  'pH',
                                  tank.ph.toStringAsFixed(2),
                                  _phColor(tank.ph),
                                  Icons.science_outlined,
                                ),
                              ),
                              Expanded(
                                child: _qMetric(
                                  'TURB',
                                  '${tank.turbidity.toStringAsFixed(2)}',
                                  _turbidityColor(tank.turbidity),
                                  Icons.blur_on_rounded,
                                ),
                              ),
                              Expanded(
                                child: _qMetric(
                                  'CL₂',
                                  '${tank.chlorine.toStringAsFixed(2)}',
                                  _chlorineColor(tank.chlorine),
                                  Icons.sanitizer_rounded,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        WaterGlassCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.map_rounded, color: C.violet, size: 14),
                  const SizedBox(width: 6),
                  WaterLabel(text: 'ZONE WATER QUALITY', size: 9.5),
                ],
              ),
              const SizedBox(height: 12),
              ...zones
                  .map(
                    (z) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: C.bgCard2,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                          color: z.quality.color.withOpacity(.18),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(z.type.icon, color: z.type.color, size: 14),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              z.name,
                              style: const TextStyle(
                                color: C.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              WaterDot(z.quality.color),
                              const SizedBox(width: 5),
                              Text(
                                z.quality.label,
                                style: TextStyle(
                                  color: z.quality.color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${z.pressureBar.toStringAsFixed(1)} bar',
                            style: const TextStyle(
                              color: C.sky,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        WaterGlassCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: C.cyan, size: 14),
                  const SizedBox(width: 6),
                  WaterLabel(text: 'PARAMETER REFERENCE', size: 9.5),
                ],
              ),
              const SizedBox(height: 12),
              _qualityRefRow('pH', '6.5 – 8.5', 'Normal drinking water range'),
              _qualityRefRow('Turbidity', '< 0.5 NTU', 'WHO guideline'),
              _qualityRefRow(
                'Chlorine',
                '0.2 – 1.0 mg/L',
                'Residual disinfectant',
              ),
              _qualityRefRow(
                'Temperature',
                '< 25°C',
                'Microbial control threshold',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _qualityStat(String label, String value, Color c) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: C.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withOpacity(.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: c,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
            ),
          ),
          WaterLabel(
            text: label,
            size: 7.5,
            color: C.mutedHi,
            letterSpacing: .5,
          ),
        ],
      ),
    ),
  );

  Widget _qMetric(String label, String value, Color c, IconData icon) => Column(
    children: [
      Icon(icon, color: c.withOpacity(.7), size: 14),
      const SizedBox(height: 3),
      Text(
        value,
        style: TextStyle(
          color: c,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          fontFamily: 'monospace',
        ),
      ),
      WaterLabel(text: label, size: 7.5, color: C.mutedHi, letterSpacing: .3),
    ],
  );

  Widget _qualityRefRow(String p, String r, String d) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            p,
            style: const TextStyle(
              color: C.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: C.teal.withOpacity(.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: C.teal.withOpacity(.2)),
          ),
          child: Text(
            r,
            style: const TextStyle(
              color: C.teal,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            d,
            style: TextStyle(color: C.mutedHi, fontSize: 9.5),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

  Widget _tabAlerts() {
    final unacked = alerts.where((a) => !a.acked).toList();
    final acked = alerts.where((a) => a.acked).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Row(
          children: [
            _alertSummary(
              'CRITICAL',
              '$critUnacked',
              C.red,
              Icons.error_rounded,
            ),
            const SizedBox(width: 8),
            _alertSummary(
              'WARNING',
              '$warnUnacked',
              C.amber,
              Icons.warning_rounded,
            ),
            const SizedBox(width: 8),
            _alertSummary(
              'INFO',
              '${alerts.where((a) => a.level == AlertLevel.info && !a.acked).length}',
              C.sky,
              Icons.info_rounded,
            ),
            const SizedBox(width: 8),
            _alertSummary(
              'TOTAL',
              '$totalUnacked',
              C.violet,
              Icons.notifications_rounded,
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (unacked.isNotEmpty) ...[
          Row(
            children: [
              WaterLabel(
                text: 'ACTIVE  (${unacked.length})',
                size: 9.5,
                color: C.white,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  for (final a in alerts) a.acked = true;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: C.cyan.withOpacity(.1),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: C.cyan.withOpacity(.25)),
                  ),
                  child: WaterLabel(
                    text: 'ACK ALL',
                    color: C.cyan,
                    size: 9,
                    letterSpacing: .8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...unacked.map(_fullAlertCard).toList(),
          const SizedBox(height: 14),
        ],
        if (acked.isNotEmpty) ...[
          WaterLabel(
            text: 'ACKNOWLEDGED  (${acked.length})',
            size: 9.5,
            color: C.mutedHi,
          ),
          const SizedBox(height: 8),
          ...acked.map(_fullAlertCard).toList(),
        ],
      ],
    );
  }

  Widget _alertSummary(String label, String value, Color c, IconData icon) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
          decoration: BoxDecoration(
            color: C.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.withOpacity(.25)),
            boxShadow: [BoxShadow(color: c.withOpacity(.06), blurRadius: 8)],
          ),
          child: Column(
            children: [
              Icon(icon, color: c, size: 16),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: c,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
              WaterLabel(
                text: label,
                size: 7.5,
                color: C.mutedHi,
                letterSpacing: .5,
              ),
            ],
          ),
        ),
      );

  Widget _fullAlertCard(WaterAlert a) {
    final blink = (!a.acked && a.level == AlertLevel.critical)
        ? blinkAnimValue
        : 1.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: a.acked ? C.bgCard3 : C.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: a.acked ? C.gBdr : a.level.color.withOpacity(.3 * blink + .05),
          width: a.acked ? 1 : 1.2,
        ),
        boxShadow: a.acked
            ? []
            : [
                BoxShadow(
                  color: a.level.color.withOpacity(.07 * blink),
                  blurRadius: 10,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            a.acked = !a.acked;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: a.level.color.withOpacity(a.acked ? .06 : .12),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: a.level.color.withOpacity(a.acked ? .15 : .3),
                    ),
                  ),
                  child: Icon(
                    a.level.icon,
                    color: a.level.color.withOpacity(a.acked ? .5 : 1),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.message,
                        style: TextStyle(
                          color: a.acked ? C.mutedHi : C.white,
                          fontSize: 11,
                          fontWeight: a.acked
                              ? FontWeight.w400
                              : FontWeight.w600,
                          decoration: a.acked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: a.level.color.withOpacity(.1),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: WaterLabel(
                              text: a.level.label,
                              color: a.level.color.withOpacity(
                                a.acked ? .5 : 1,
                              ),
                              size: 7.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          WaterLabel(
                            text: a.source,
                            color: C.cyan.withOpacity(a.acked ? .4 : .7),
                            size: 8.5,
                          ),
                          const SizedBox(width: 6),
                          WaterDot(C.mutedHi.withOpacity(.4), 2),
                          const SizedBox(width: 6),
                          WaterLabel(text: a.time, color: C.mutedHi, size: 8),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: a.acked
                        ? C.teal.withOpacity(.1)
                        : C.muted.withOpacity(.2),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: a.acked ? C.teal.withOpacity(.3) : C.gBdr,
                    ),
                  ),
                  child: Icon(
                    a.acked
                        ? Icons.check_rounded
                        : Icons.check_circle_outline_rounded,
                    color: a.acked ? C.teal : C.mutedHi,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
