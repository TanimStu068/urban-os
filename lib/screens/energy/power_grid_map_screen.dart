import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/power_grid_data_model.dart';
import 'package:urban_os/widgets/power_grid/alert_panel.dart';
import 'package:urban_os/widgets/power_grid/bg_painter.dart';
import 'package:urban_os/widgets/power_grid/circle_btn.dart';
import 'package:urban_os/widgets/power_grid/filter_fill.dart';
import 'package:urban_os/widgets/power_grid/grid_map_area.dart';
import 'package:urban_os/widgets/power_grid/kpi_cell.dart';
import 'package:urban_os/widgets/power_grid/node_panel.dart';
import 'package:urban_os/widgets/power_grid/toggle_btn.dart';
import 'package:urban_os/widgets/power_grid/v_div.dart';

// local C colors for this screen only
typedef C = AppColors;

class PowerGridMapScreen extends StatefulWidget {
  const PowerGridMapScreen({super.key});

  @override
  State<PowerGridMapScreen> createState() => _PowerGridMapState();
}

class _PowerGridMapState extends State<PowerGridMapScreen>
    with TickerProviderStateMixin {
  late List<GridNode> _nodes;
  late List<GridLine> _lines;
  late List<GridAlert> _gridAlerts;

  GridNode? _selectedNode;
  String _filterType = 'ALL';
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  bool _showLabels = true;
  bool _showFlow = true;
  bool _showHeatmap = false;
  bool _liveMode = true;
  bool _alertPanelOpen = false;

  late AnimationController _bgCtrl;
  late AnimationController _flowCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _liveCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;
  final _rnd = Random();

  int get _faultCount =>
      _lines.where((l) => l.status == LineStatus.fault).length;
  int get _overloadCount =>
      _nodes.where((n) => n.status == ZoneStatus.critical).length;
  int get _unackAlerts => _gridAlerts.where((a) => !a.acked).length;
  double get _totalLoad => _nodes
      .where((n) => n.type == NodeType.zone)
      .fold(0.0, (s, n) => s + n.power);

  @override
  void initState() {
    super.initState();
    _nodes = buildNodes();
    _lines = buildLines();
    _gridAlerts = buildGridAlerts();
    _initAnims();
    _entranceCtrl.forward();
  }

  void _initAnims() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _flowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _liveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

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
    setState(() {
      for (final n in _nodes) {
        if (n.status == ZoneStatus.offline) continue;
        final delta = (_rnd.nextDouble() - 0.5) * 3;
        n.loadPct = (n.loadPct + delta).clamp(0, 100);
        if (n.loadPct >= 95) {
          n.status = ZoneStatus.critical;
        } else if (n.loadPct >= 85) {
          n.status = ZoneStatus.warning;
        } else if (n.loadPct <= 55) {
          n.status = ZoneStatus.saving;
        } else {
          n.status = ZoneStatus.normal;
        }
      }
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _flowCtrl.dispose();
    _glowCtrl.dispose();
    _blinkCtrl.dispose();
    _scanCtrl.dispose();
    _pulseCtrl.dispose();
    _entranceCtrl.dispose();
    _liveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: BgPainter(t: _bgCtrl.value, glow: _glowCtrl.value),
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
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      C.amber.withOpacity(0.05),
                      C.amber.withOpacity(0.1),
                      C.amber.withOpacity(0.05),
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
                    _buildHeader(),
                    _buildKpiStrip(),
                    _buildToolbar(),
                    Expanded(
                      child: GridMapArea(
                        size: size,
                        scale: _scale,
                        offset: _offset,
                        showLabels: _showLabels,
                        showFlow: _showFlow,
                        showHeatmap: _showHeatmap,
                        flowAnimation: _flowCtrl,
                        glowAnimation: _glowCtrl,
                        blinkAnimation: _blinkCtrl,
                        selectedNode: _selectedNode,
                        filterType: _filterType,
                        nodes: _nodes,
                        lines: _lines,
                        onMapTap: (position, mapSize) =>
                            _handleMapTap(position, mapSize),
                        onTransformUpdate: (newScale, newOffset) {
                          setState(() {
                            _scale = newScale;
                            _offset = newOffset;
                          });
                        },
                      ),
                    ),
                    if (_selectedNode != null)
                      NodePanel(
                        node: PowerNode(
                          id: _selectedNode!.id,
                          name: _selectedNode!.name,
                          type: _selectedNode!.type,
                          loadPct: _selectedNode!.loadPct,
                          voltage: _selectedNode!.voltage,
                          current: _selectedNode!.current,
                          power: _selectedNode!.power,
                          loadHistory: _selectedNode!.loadHistory,
                          status: _selectedNode!.status.label,
                        ),
                        alerts: _gridAlerts,
                        glowAnimation: _glowCtrl,
                        blinkAnimation: _blinkCtrl,
                        onClose: () => setState(() => _selectedNode = null),
                      ),
                    AlertPanel(
                      alerts: _gridAlerts,
                      unackAlerts: _unackAlerts,
                      isOpen: _alertPanelOpen,
                      blinkAnimation: _blinkCtrl,
                      onClose: () => setState(() => _alertPanelOpen = false),
                      onAckAll: () => setState(() {
                        for (final a in _gridAlerts) a.acked = true;
                      }),
                      onAck: (alert) => setState(() => alert.acked = true),
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

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.gBdr)),
          boxShadow: [
            BoxShadow(
              color: C.amber.withOpacity(0.04 + _glowCtrl.value * 0.02),
              blurRadius: 24,
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: CircleBtn(Icons.arrow_back_ios_rounded, sz: 14),
            ),
            const SizedBox(width: 12),
            AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, __) => Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.amber.withOpacity(0.1),
                  border: Border.all(
                    color: C.amber.withOpacity(0.3 + _glowCtrl.value * 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: C.amber.withOpacity(0.15 + _glowCtrl.value * 0.1),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.grid_4x4_rounded,
                  color: C.amber,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [C.amber, C.yellow],
                    ).createShader(bounds),
                    child: const Text(
                      'POWER GRID MAP',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '${_nodes.length} NODES · ${_lines.length} LINES · ${(_totalLoad / 1000).toStringAsFixed(1)} MW LOAD',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      letterSpacing: 1.8,
                      color: C.mutedLt,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _liveMode = !_liveMode),
              child: AnimatedBuilder(
                animation: _blinkCtrl,
                builder: (_, __) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: _liveMode
                        ? C.green.withOpacity(0.08 + _blinkCtrl.value * 0.04)
                        : C.bgCard2,
                    border: Border.all(
                      color: _liveMode
                          ? C.green.withOpacity(0.4 + _blinkCtrl.value * 0.15)
                          : C.muted.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _liveMode
                              ? C.green.withOpacity(
                                  0.6 + _blinkCtrl.value * 0.4,
                                )
                              : C.muted,
                          boxShadow: _liveMode
                              ? [
                                  BoxShadow(
                                    color: C.green.withOpacity(0.5),
                                    blurRadius: 6,
                                  ),
                                ]
                              : [],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _liveMode ? 'LIVE' : 'PAUSED',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: _liveMode ? C.green : C.mutedLt,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() => _alertPanelOpen = !_alertPanelOpen),
              child: AnimatedBuilder(
                animation: _blinkCtrl,
                builder: (_, __) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _unackAlerts > 0
                            ? C.red.withOpacity(0.1 + _blinkCtrl.value * 0.04)
                            : C.gBg,
                        border: Border.all(
                          color: _unackAlerts > 0
                              ? C.red.withOpacity(
                                  0.35 + _blinkCtrl.value * 0.15,
                                )
                              : C.gBdr,
                        ),
                      ),
                      child: Icon(
                        Icons.notifications_rounded,
                        color: _unackAlerts > 0 ? C.red : C.mutedLt,
                        size: 16,
                      ),
                    ),
                    if (_unackAlerts > 0)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: C.red,
                          ),
                          child: Center(
                            child: Text(
                              '$_unackAlerts',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 7,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiStrip() => AnimatedBuilder(
    animation: Listenable.merge([_glowCtrl, _blinkCtrl]),
    builder: (_, __) => Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: C.bgCard.withOpacity(0.9),
        border: Border.all(
          color: C.amber.withOpacity(0.18 + _glowCtrl.value * 0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: C.amber.withOpacity(0.05 + _glowCtrl.value * 0.02),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        children: [
          KpiCell(
            'TOTAL LOAD',
            '${(_totalLoad / 1000).toStringAsFixed(1)}',
            'MW',
            C.amber,
            _glowCtrl.value,
          ),
          const VDiv(),
          KpiCell(
            'ACTIVE LINES',
            '${_lines.where((l) => l.status == LineStatus.live).length}',
            '/${_lines.length}',
            C.green,
            _glowCtrl.value,
          ),
          const VDiv(),
          KpiCell(
            'FAULT LINES',
            '$_faultCount',
            'FAULT',
            _faultCount > 0 ? C.red : C.mutedLt,
            _glowCtrl.value,
            blink: _faultCount > 0,
            blinkT: _blinkCtrl.value,
          ),
          const VDiv(),
          KpiCell(
            'OVERLOADED',
            '$_overloadCount',
            'NODES',
            _overloadCount > 0 ? C.orange : C.mutedLt,
            _glowCtrl.value,
            blink: _overloadCount > 0,
            blinkT: _blinkCtrl.value,
          ),
          const VDiv(),
          KpiCell(
            'GRID HEALTH',
            _overloadCount > 1
                ? 'POOR'
                : _faultCount > 0
                ? 'FAIR'
                : 'GOOD',
            '',
            _overloadCount > 1
                ? C.red
                : _faultCount > 0
                ? C.amber
                : C.green,
            _glowCtrl.value,
          ),
          const VDiv(),
          KpiCell(
            'LOSSES',
            '${_lines.fold(0.0, (s, l) => s + l.lossKW).toStringAsFixed(0)}',
            'kW',
            C.violet,
            _glowCtrl.value,
          ),
        ],
      ),
    ),
  );

  Widget _buildToolbar() => Container(
    margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterPill('ALL', _filterType == 'ALL', () {
            setState(() => _filterType = 'ALL');
          }),
          const SizedBox(width: 4),
          FilterPill('FAULT', _filterType == 'FAULT', () {
            setState(() => _filterType = 'FAULT');
          }, color: C.red),
          const SizedBox(width: 4),
          FilterPill('OVERLOAD', _filterType == 'OVERLOAD', () {
            setState(() => _filterType = 'OVERLOAD');
          }, color: C.orange),
          const SizedBox(width: 4),
          FilterPill('OFFLINE', _filterType == 'OFFLINE', () {
            setState(() => _filterType = 'OFFLINE');
          }, color: C.mutedLt),
          const SizedBox(width: 8),
          ToggleBtn(Icons.label_outline_rounded, 'LABELS', _showLabels, () {
            setState(() => _showLabels = !_showLabels);
          }),
          const SizedBox(width: 4),
          ToggleBtn(Icons.air_rounded, 'FLOW', _showFlow, () {
            setState(() => _showFlow = !_showFlow);
          }),
          const SizedBox(width: 4),
          ToggleBtn(Icons.thermostat_rounded, 'HEAT', _showHeatmap, () {
            setState(() => _showHeatmap = !_showHeatmap);
          }),
          const SizedBox(width: 4),
          CircleBtn(
            Icons.add_rounded,
            sz: 15,
            onTap: () {
              setState(() => _scale = (_scale + 0.2).clamp(0.5, 3.0));
            },
          ),
          const SizedBox(width: 3),
          CircleBtn(
            Icons.remove_rounded,
            sz: 15,
            onTap: () {
              setState(() => _scale = (_scale - 0.2).clamp(0.5, 3.0));
            },
          ),
          const SizedBox(width: 3),
          CircleBtn(
            Icons.center_focus_strong_rounded,
            sz: 13,
            onTap: () {
              setState(() {
                _scale = 1.0;
                _offset = Offset.zero;
              });
            },
          ),
        ],
      ),
    ),
  );

  void _handleMapTap(Offset localPos, Size parentSize) {
    final canvasSize = Size(
      parentSize.width - 28,
      parentSize.height - 8 - 80 - 38 - 56 - 52,
    );
    for (final node in _nodes.reversed) {
      final nx = node.position.dx * canvasSize.width * _scale + _offset.dx;
      final ny = node.position.dy * canvasSize.height * _scale + _offset.dy;
      final r = node.type.radius * _scale + 8;
      if ((localPos - Offset(nx, ny)).distance < r) {
        setState(() {
          _selectedNode = _selectedNode?.id == node.id ? null : node;
        });
        return;
      }
    }
    setState(() => _selectedNode = null);
  }
}
