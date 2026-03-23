import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/power_grid_data_model.dart';
import 'package:urban_os/widgets/power_grid/grid_map_painter.dart';

typedef C = AppColors;

class GridMapArea extends StatelessWidget {
  final Size size;
  final double scale;
  final Offset offset;
  final bool showLabels;
  final bool showFlow;
  final bool showHeatmap;
  final Animation<double> flowAnimation;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;
  final dynamic selectedNode;
  final String filterType;
  final List<GridNode> nodes;
  final List<GridLine> lines;
  final Function(Offset localPosition, Size size) onMapTap;
  final Function(double newScale, Offset newOffset) onTransformUpdate;

  const GridMapArea({
    super.key,
    required this.size,
    required this.scale,
    required this.offset,
    required this.showLabels,
    required this.showFlow,
    required this.showHeatmap,
    required this.flowAnimation,
    required this.glowAnimation,
    required this.blinkAnimation,
    required this.selectedNode,
    required this.filterType,
    required this.nodes,
    required this.lines,
    required this.onMapTap,
    required this.onTransformUpdate,
  });

  List<GridNode> _filterNodes() {
    if (filterType == 'ALL') return nodes;
    return nodes.where((n) {
      switch (filterType) {
        case 'FAULT':
          return n.status == ZoneStatus.offline ||
              n.status == ZoneStatus.critical;
        case 'OVERLOAD':
          return n.status == ZoneStatus.critical ||
              n.status == ZoneStatus.warning;
        case 'OFFLINE':
          return n.status == ZoneStatus.offline;
        default:
          return true;
      }
    }).toList();
  }

  List<GridLine> _filterLines(List<GridNode> visibleNodes) {
    final ids = visibleNodes.map((n) => n.id).toSet();
    if (filterType == 'ALL') return lines;
    return lines.where((l) {
      if (!ids.contains(l.fromId) && !ids.contains(l.toId)) return false;
      switch (filterType) {
        case 'FAULT':
          return l.status == LineStatus.fault ||
              l.status == LineStatus.overloaded;
        case 'OVERLOAD':
          return l.status == LineStatus.overloaded;
        case 'OFFLINE':
          return l.status == LineStatus.offline || l.status == LineStatus.fault;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: C.bgCard3.withOpacity(0.9),
        border: Border.all(color: C.gBdr),
      ),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onScaleStart: (_) {},
        onScaleUpdate: (d) {
          final newScale = (scale * d.scale).clamp(0.5, 3.0);
          final newOffset = offset + d.focalPointDelta;
          onTransformUpdate(newScale, newOffset);
        },
        onTapUp: (d) => onMapTap(d.localPosition, size),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            flowAnimation,
            glowAnimation,
            blinkAnimation,
          ]),
          builder: (_, __) {
            final filteredNodes = _filterNodes();
            final filteredLines = _filterLines(filteredNodes);
            return CustomPaint(
              painter: GridMapPainter(
                nodes: filteredNodes,
                lines: filteredLines,
                allNodes: nodes,
                scale: scale,
                offset: offset,
                showLabels: showLabels,
                showFlow: showFlow,
                showHeatmap: showHeatmap,
                flowT: flowAnimation.value,
                glowT: glowAnimation.value,
                blinkT: blinkAnimation.value,
                selectedId: selectedNode?.id,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}
