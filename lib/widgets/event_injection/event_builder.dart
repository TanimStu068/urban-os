import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/event_injection_data_model.dart';
import 'package:urban_os/widgets/event_injection/event_type_button.dart';
import 'package:urban_os/widgets/event_injection/impact_button.dart';
import 'package:urban_os/widgets/event_injection/severity_button.dart';

typedef C = AppColors;

/// Event Builder Widget
class EventBuilder extends StatelessWidget {
  final List<EventTemplate> templates;
  final EventType? selectedEventType;
  final ValueChanged<EventType> onEventTypeSelected;

  final String locationInput;
  final ValueChanged<String> onLocationChanged;

  final EventSeverity? selectedSeverity;
  final ValueChanged<EventSeverity> onSeverityChanged;

  final ImpactArea? selectedImpact;
  final ValueChanged<ImpactArea> onImpactChanged;

  final int durationMinutes;
  final ValueChanged<int> onDurationChanged;

  final VoidCallback onCancel;
  final VoidCallback onInjectEvent;

  const EventBuilder({
    super.key,
    required this.templates,
    required this.selectedEventType,
    required this.onEventTypeSelected,
    required this.locationInput,
    required this.onLocationChanged,
    required this.selectedSeverity,
    required this.onSeverityChanged,
    required this.selectedImpact,
    required this.onImpactChanged,
    required this.durationMinutes,
    required this.onDurationChanged,
    required this.onCancel,
    required this.onInjectEvent,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Type Selection
          const Text(
            'SELECT EVENT TYPE',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: C.cyan,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: templates.length,
            itemBuilder: (_, i) => EventTypeButton(
              template: templates[i],
              isSelected: selectedEventType == templates[i].type,
              onTap: () => onEventTypeSelected(templates[i].type),
            ),
          ),
          const SizedBox(height: 16),

          // Location Input
          const Text(
            'LOCATION',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: C.cyan,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: C.bgCard.withOpacity(0.5),
              border: Border.all(color: C.cyan.withOpacity(0.2)),
            ),
            child: TextField(
              onChanged: onLocationChanged,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8.5,
                color: C.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter location...',
                hintStyle: TextStyle(color: C.muted),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Severity Selection
          const Text(
            'SEVERITY',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: C.cyan,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: EventSeverity.values
                  .map(
                    (sev) => SeverityButton(
                      severity: sev,
                      isSelected: selectedSeverity == sev,
                      onTap: () => onSeverityChanged(sev),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Impact Area
          const Text(
            'IMPACT AREA',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: C.cyan,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: ImpactArea.values
                .map(
                  (impact) => Expanded(
                    child: ImpactButton(
                      impact: impact,
                      isSelected: selectedImpact == impact,
                      onTap: () => onImpactChanged(impact),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),

          // Duration
          const Text(
            'DURATION',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: C.cyan,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: durationMinutes.toDouble(),
                  min: 5,
                  max: 120,
                  divisions: 23,
                  label: '$durationMinutes min',
                  onChanged: (val) => onDurationChanged(val.toInt()),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: C.cyan.withOpacity(0.15),
                ),
                child: Text(
                  '$durationMinutes m',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    color: C.cyan,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: C.mutedLt.withOpacity(0.2),
                      border: Border.all(color: C.mutedLt.withOpacity(0.4)),
                    ),
                    child: const Text(
                      'CANCEL',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: C.mutedLt,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: onInjectEvent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: C.cyan.withOpacity(0.2),
                      border: Border.all(color: C.cyan.withOpacity(0.5)),
                    ),
                    child: const Text(
                      'INJECT EVENT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: C.cyan,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
