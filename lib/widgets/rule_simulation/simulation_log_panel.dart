import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/rule_simulation/sim_panel.dart';

typedef C = AppColors;

class SimulationLogPanel extends StatelessWidget {
  final List log;
  final ScrollController logScrollCtrl;

  const SimulationLogPanel({
    super.key,
    required this.log,
    required this.logScrollCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SimPanel(
      title: 'SIMULATION LOG',
      icon: Icons.terminal_rounded,
      color: C.mutedLt,
      badge: '${log.length} ENTRIES',
      badgeColor: C.muted,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF020C18),
          border: Border.all(color: C.gBdr),
        ),
        child: log.isEmpty
            ? const Center(
                child: Text(
                  'No log entries yet. Run the simulation.',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    color: C.muted,
                  ),
                ),
              )
            : ListView.builder(
                controller: logScrollCtrl,
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                itemCount: log.length,
                itemBuilder: (_, i) {
                  final e = log[log.length - 1 - i];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${e.time}  ',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              color: C.muted,
                            ),
                          ),
                          TextSpan(
                            text: '${e.level.prefix}  ',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              color: e.level.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: e.message,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              color: e.level.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
