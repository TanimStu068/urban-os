import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/power_grid_data_model.dart';
import 'package:urban_os/widgets/power_grid/sec_label.dart';
import 'package:urban_os/widgets/power_grid/spark_painter.dart';
import 'package:urban_os/widgets/power_grid/matric_box.dart';

typedef C = AppColors;

class PowerNode {
  final String id;
  final String name;
  final NodeType type;
  final double loadPct;
  final double voltage;
  final double current;
  final double power;
  final List<double> loadHistory;
  final String status;

  PowerNode({
    required this.id,
    required this.name,
    required this.type,
    required this.loadPct,
    required this.voltage,
    required this.current,
    required this.power,
    required this.loadHistory,
    required this.status,
  });
}

class NodePanel extends StatelessWidget {
  final PowerNode node;
  final List<GridAlert> alerts;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;
  final VoidCallback onClose;

  const NodePanel({
    super.key,
    required this.node,
    required this.alerts,
    required this.glowAnimation,
    required this.blinkAnimation,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final nodeAlerts = alerts.where((a) => a.nodeId == node.id).toList();
    final col = node.type.color;

    return AnimatedBuilder(
      animation: Listenable.merge([glowAnimation, blinkAnimation]),
      builder: (_, __) => Container(
        margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.bgCard.withOpacity(0.97),
          border: Border.all(
            color: col.withOpacity(0.3 + glowAnimation.value * 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: col.withOpacity(0.07 + glowAnimation.value * 0.03),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: col.withOpacity(0.14),
                    border: Border.all(color: col.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: col.withOpacity(0.2 + glowAnimation.value * 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(node.type.icon, color: col, size: 17),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        node.name.replaceAll('\n', ' '),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: col,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        '${node.type.label}  ·  ${node.id}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7.5,
                          color: C.mutedLt,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge placeholder
                Text(node.status, style: TextStyle(color: col)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close_rounded,
                    color: C.mutedLt,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Color(0x1AFFAA00), height: 1),
            const SizedBox(height: 10),

            // Metrics row
            Row(
              children: [
                MetricBox('LOAD', '${node.loadPct.toStringAsFixed(0)}%', col),
                MetricBox(
                  'VOLTAGE',
                  node.voltage > 0
                      ? '${node.voltage.toStringAsFixed(0)} kV'
                      : '—',
                  C.cyan,
                ),
                MetricBox(
                  'CURRENT',
                  node.current > 0
                      ? '${node.current.toStringAsFixed(0)} A'
                      : '—',
                  C.violet,
                ),
                MetricBox(
                  'POWER',
                  node.power > 0
                      ? '${(node.power / 1000).toStringAsFixed(1)} MW'
                      : '—',
                  C.amber,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Load bar
            Stack(
              children: [
                Container(
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: C.bgCard2,
                    border: Border.all(color: C.gBdr),
                  ),
                ),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 500),
                  widthFactor: (node.loadPct / 100).clamp(0, 1),
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        colors: node.loadPct > 90
                            ? [C.orange, C.red]
                            : node.loadPct > 75
                            ? [C.amber, C.orange]
                            : [C.green, C.teal],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: col.withOpacity(
                            0.3 + glowAnimation.value * 0.1,
                          ),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      '${node.loadPct.toStringAsFixed(1)}%  UTILISATION',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Mini sparkline
            SecLabel('LOAD TREND (24H)'),
            const SizedBox(height: 4),
            SizedBox(
              height: 32,
              child: CustomPaint(
                painter: SparkPainter(
                  data: node.loadHistory,
                  color: col,
                  glowT: glowAnimation.value,
                ),
                size: const Size(double.infinity, 32),
              ),
            ),

            // Node alerts
            if (nodeAlerts.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...nodeAlerts.map(
                (a) => Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: a.color.withOpacity(a.acked ? 0.03 : 0.07),
                    border: Border.all(
                      color: a.color.withOpacity(a.acked ? 0.1 : 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        !a.acked
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline_rounded,
                        color: a.color.withOpacity(a.acked ? 0.4 : 1),
                        size: 12,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          a.message,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            color: a.acked ? C.muted : C.white,
                          ),
                        ),
                      ),
                      Text(
                        a.time,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          color: C.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
