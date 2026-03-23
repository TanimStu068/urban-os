import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/district_map_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/providers/district/district_provider.dart';
import 'package:urban_os/widgets/district_map/city_map_painter.dart';
import 'package:urban_os/widgets/district_map/district_bottom_panel.dart';
import 'dart:math';

typedef C = AppColors;

class DistrictMapView extends StatefulWidget {
  final DistrictProvider districtProvider;
  final MapMode mode;
  final Animation<double> glowAnimation;
  final Animation<double> pulseAnimation;
  final Animation<double> blinkAnimation;

  const DistrictMapView({
    super.key,
    required this.districtProvider,
    required this.mode,
    required this.glowAnimation,
    required this.pulseAnimation,
    required this.blinkAnimation,
  });

  @override
  State<DistrictMapView> createState() => _DistrictMapViewState();
}

class _DistrictMapViewState extends State<DistrictMapView> {
  List<MapTile> _tiles = [];
  double _scale = 1.0;
  Offset _pan = Offset.zero;
  Offset _startPan = Offset.zero;
  double _startScale = 1.0;
  Offset _focalStart = Offset.zero;
  DistrictModel? _selected;
  bool _showPanel = false;

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

  MapTile? hitTest(Offset localPos, List<MapTile> tiles, Size canvasSize) {
    final cx = canvasSize.width / 2;
    final cy = canvasSize.height / 2;

    // Convert tap position to map coordinates considering pan & scale
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
    final dp = widget.districtProvider;

    // Loading
    if (dp.isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: widget.pulseAnimation,
              builder: (_, __) => Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: C.green.withOpacity(
                      0.4 + widget.pulseAnimation.value * 0.3,
                    ),
                    width: 1.5,
                  ),
                ),
                child: const Icon(Icons.map_rounded, color: C.green, size: 18),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'LOADING MAP…',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: C.mutedLt,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    // No data
    if (dp.districts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, color: C.mutedLt, size: 44),
            const SizedBox(height: 10),
            const Text(
              'NO DISTRICT DATA',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: C.mutedLt,
              ),
            ),
          ],
        ),
      );
    }

    // Map view
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
        _tiles = layoutTiles(dp.districts, canvasSize);

        return GestureDetector(
          onTapDown: (details) {
            final hit = hitTest(details.localPosition, _tiles, canvasSize);
            setState(() {
              if (hit != null) {
                _selected = hit.district;
                _showPanel = true;
              } else {
                _selected = null;
                _showPanel = false;
              }
            });
          },
          onScaleStart: (details) {
            _startScale = _scale;
            _startPan = _pan;
            _focalStart = details.localFocalPoint;
          },
          onScaleUpdate: (details) {
            setState(() {
              _scale = (_startScale * details.scale).clamp(0.5, 4.0);
              final delta = details.localFocalPoint - _focalStart;
              _pan = _startPan + delta;
            });
          },
          child: Stack(
            children: [
              ClipRect(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    widget.glowAnimation,
                    widget.pulseAnimation,
                    widget.blinkAnimation,
                  ]),
                  builder: (_, __) => CustomPaint(
                    size: canvasSize,
                    painter: CityMapPainter(
                      tiles: _tiles,
                      mode: widget.mode,
                      selected: _selected,
                      scale: _scale,
                      pan: _pan,
                      glowT: widget.glowAnimation.value,
                      pulseT: widget.pulseAnimation.value,
                      blinkT: widget.blinkAnimation.value,
                      tileColorFn: tileColor,
                      tileFracFn: tileFrac,
                    ),
                  ),
                ),
              ),
              if (_showPanel && _selected != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: DistrictBottomPanel(
                    district: _selected!,
                    glowAnimation: widget.glowAnimation,
                    pulseAnimation: widget.pulseAnimation,
                    mode: widget.mode, // must be MapMode, not String
                    onClose: () => setState(() {
                      _selected = null;
                      _showPanel = false;
                    }),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
