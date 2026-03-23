import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/district_map_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/providers/district/district_provider.dart';
import 'package:urban_os/widgets/district_map/district_map_header.dart';
import 'package:urban_os/widgets/district_map/district_map_model_bar.dart';
import 'package:urban_os/widgets/district_map/district_map_view.dart';
import 'package:urban_os/widgets/district_map/map_bg_painter.dart';

typedef C = AppColors;

class DistrictMapScreen extends StatefulWidget {
  const DistrictMapScreen({super.key});

  @override
  State<DistrictMapScreen> createState() => _DistrictMapScreenState();
}

class _DistrictMapScreenState extends State<DistrictMapScreen>
    with TickerProviderStateMixin {
  MapMode _mode = MapMode.health;
  double _scale = 1.0;
  Offset _pan = Offset.zero;

  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
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
      duration: const Duration(seconds: 2),
    )..repeat();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.04), end: Offset.zero));

    _entranceCtrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DistrictProvider>().loadDistricts();
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _pulseCtrl.dispose();
    _blinkCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  // ── Layout tiles from district list (grid-based, using area or equal cells) ──
  List<MapTile> layoutTiles(List<DistrictModel> districts, Size canvas) {
    if (districts.isEmpty) return [];
    final n = districts.length;
    final cols = max(2, sqrt(n).ceil());
    final rows = (n / cols).ceil();
    final cellW = canvas.width / cols;
    final cellH = canvas.height / rows;
    const pad = 4.0;

    return List.generate(n, (i) {
      final col = i % cols;
      final row = i ~/ cols;
      final rect = Rect.fromLTWH(
        col * cellW + pad,
        row * cellH + pad,
        cellW - pad * 2,
        cellH - pad * 2,
      );
      return MapTile(districts[i], rect);
    });
  }

  // ── Hit test: which tile is under tap ──
  MapTile? hitTest(Offset localPos, List<MapTile> tiles, Size canvasSize) {
    // Inverse transform: localPos → map coords
    final cx = canvasSize.width / 2;
    final cy = canvasSize.height / 2;
    final mapX = (localPos.dx - cx - _pan.dx) / _scale + cx;
    final mapY = (localPos.dy - cy - _pan.dy) / _scale + cy;
    final mapPos = Offset(mapX, mapY);

    for (final t in tiles) {
      if (t.rect.contains(mapPos)) return t;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (_, __) => CustomPaint(
          painter: MapBgPainter(_bgCtrl.value),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Consumer<DistrictProvider>(
                  builder: (_, dp, __) => Column(
                    children: [
                      DistrictMapHeader(
                        districtProvider: dp,
                        glowAnimation: _glowCtrl,
                        scale: _scale,
                        pan: _pan,
                        onResetZoom: () => setState(() {
                          _scale = 1.0;
                          _pan = Offset.zero;
                        }),
                      ),
                      DistrictMapModeBar(
                        currentMode: _mode,
                        onModeSelected: (mode) => setState(() => _mode = mode),
                      ),
                      Expanded(
                        child: DistrictMapView(
                          districtProvider: dp,
                          mode: _mode,
                          glowAnimation: _glowCtrl,
                          pulseAnimation: _pulseCtrl,
                          blinkAnimation: _blinkCtrl,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
