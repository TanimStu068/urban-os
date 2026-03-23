import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';
import 'package:urban_os/widgets/energy_dashboard/grid_flow_painter.dart';
import 'package:urban_os/widgets/energy_dashboard/zone_table.dart';

typedef C = AppColors;

class GridTab extends StatefulWidget {
  final List<PowerZone> zones;
  final List<EnergySourceModel> sources;
  final Animation<double> flowAnimation;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;

  const GridTab({
    super.key,
    required this.zones,
    required this.sources,
    required this.flowAnimation,
    required this.glowAnimation,
    required this.blinkAnimation,
  });

  @override
  State<GridTab> createState() => _GridTabState();
}

class _GridTabState extends State<GridTab> {
  bool _showFlow = true;

  void _toggleFlow() {
    setState(() {
      _showFlow = !_showFlow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Power flow map panel
          Panel(
            title: 'POWER FLOW MAP',
            icon: Icons.account_tree_rounded,
            color: C.amber,
            badge: _showFlow ? 'FLOW ON' : 'FLOW OFF',
            badgeColor: _showFlow ? C.green : C.muted,
            child: Column(
              children: [
                // Toggle button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _toggleFlow,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: _showFlow
                              ? C.amber.withOpacity(0.1)
                              : C.bgCard2,
                          border: Border.all(
                            color: _showFlow
                                ? C.amber.withOpacity(0.35)
                                : C.gBdr,
                          ),
                        ),
                        child: Text(
                          _showFlow ? 'HIDE FLOW' : 'SHOW FLOW',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7.5,
                            color: _showFlow ? C.amber : C.mutedLt,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Grid visualization
                SizedBox(
                  height: 280,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      widget.flowAnimation,
                      widget.glowAnimation,
                      widget.blinkAnimation,
                    ]),
                    builder: (_, __) => CustomPaint(
                      painter: GridFlowPainter(
                        zones: widget.zones,
                        sources: widget.sources,
                        showFlow: _showFlow,
                        flowT: widget.flowAnimation.value,
                        glowT: widget.glowAnimation.value,
                        blinkT: widget.blinkAnimation.value,
                      ),
                      size: const Size(double.infinity, 280),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Detailed zone table
          ZoneTable(
            zones: widget.zones,
            glowAnimation: widget.glowAnimation,
            blinkAnimation: widget.blinkAnimation,
          ),
        ],
      ),
    );
  }
}
