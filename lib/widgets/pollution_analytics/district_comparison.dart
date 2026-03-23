import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/pollution_analysis_data_model.dart';
import 'package:urban_os/widgets/environment_dashboard/panel.dart';

typedef C = AppColors;

/// District comparison panel widget
class DistrictComparisonPanel extends StatefulWidget {
  final List<DistrictPollutionData> districts;
  final PollutantType selectedPollutant;
  final AnimationController glowCtrl;
  final AnimationController barAnimCtrl;

  const DistrictComparisonPanel({
    super.key,
    required this.districts,
    required this.selectedPollutant,
    required this.glowCtrl,
    required this.barAnimCtrl,
  });

  @override
  State<DistrictComparisonPanel> createState() =>
      _DistrictComparisonPanelState();
}

class _DistrictComparisonPanelState extends State<DistrictComparisonPanel> {
  String? _selectedDistrictId;

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'DISTRICT POLLUTION LEVELS',
      icon: Icons.bar_chart_rounded,
      color: C.teal,
      badge: 'COMPARATIVE',
      badgeColor: C.teal,
      child: Column(
        children: widget.districts.map((d) {
          final districtVal = getDistrictPollutantValue(
            d,
            widget.selectedPollutant,
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AnimatedBuilder(
              animation: Listenable.merge([
                widget.glowCtrl,
                widget.barAnimCtrl,
              ]),
              builder: (_, __) {
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedDistrictId = _selectedDistrictId == d.id
                        ? null
                        : d.id;
                  }),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          Icon(
                            Icons.location_city_rounded,
                            color: d.color,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              d.name,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: d.color,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: getRiskColor(
                                d.healthRiskLevel,
                              ).withOpacity(0.15),
                              border: Border.all(
                                color: getRiskColor(
                                  d.healthRiskLevel,
                                ).withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              _getRiskLabel(d.healthRiskLevel),
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 7,
                                color: getRiskColor(d.healthRiskLevel),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          minHeight: 14,
                          value:
                              (districtVal /
                                      (widget.selectedPollutant.safeLimit * 2))
                                  .clamp(0, 1),
                          backgroundColor: C.bgCard2,
                          valueColor: AlwaysStoppedAnimation(
                            districtVal > widget.selectedPollutant.safeLimit
                                ? widget.selectedPollutant.color
                                : C.green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${districtVal.toStringAsFixed(1)} / ${widget.selectedPollutant.safeLimit.toStringAsFixed(0)} ${widget.selectedPollutant.unit}',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          color: C.mutedLt,
                        ),
                      ),
                      if (_selectedDistrictId == d.id) ...[
                        const SizedBox(height: 8),
                        _buildSelectedDistrictDetail(d),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelectedDistrictDetail(DistrictPollutionData d) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: d.color.withOpacity(0.08),
        border: Border.all(color: d.color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Primary Source: ${d.primarySource}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              color: d.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.warning_rounded, color: C.amber, size: 12),
              const SizedBox(width: 4),
              Text(
                'Health Risk: Level ${d.healthRiskLevel}/5',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: C.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRiskLabel(int level) {
    const labels = ['', 'LOW', 'MODERATE', 'HIGH', 'VERY HIGH', 'CRITICAL'];
    return labels[level.clamp(0, 5)];
  }
}
