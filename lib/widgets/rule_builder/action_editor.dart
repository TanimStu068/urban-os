import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/automation_rule_builder_data_model.dart';
import 'package:urban_os/models/automation/rule_action.dart';
import 'package:urban_os/widgets/rule_builder/tiny_toggle.dart';

typedef C = AppColors;

class ActionEditor extends StatelessWidget {
  final DraftAction action;
  final int index;
  final List<String> actuatorOptions;
  final double glowT;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  const ActionEditor({
    super.key,
    required this.action,
    required this.index,
    required this.actuatorOptions,
    required this.glowT,
    required this.onChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext ctx) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: C.bgCard2.withOpacity(0.6),
      border: Border.all(color: C.green.withOpacity(0.15 + glowT * 0.05)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: C.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'ACTION ${index + 1}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: C.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Spacer(),
            if (onRemove != null)
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.remove_circle_outline_rounded,
                  color: C.red.withOpacity(0.6),
                  size: 18,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        // Action type
        const Text(
          'ACTION TYPE',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: C.muted,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: C.bgCard.withOpacity(0.5),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: C.gBdr),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButton<ActionType>(
            value: action.type,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: C.bgCard2,
            icon: const Icon(
              Icons.expand_more_rounded,
              color: C.mutedLt,
              size: 16,
            ),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              color: C.white,
            ),
            items: ActionType.values
                .map(
                  (t) => DropdownMenuItem(value: t, child: Text(t.displayName)),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) {
                action.type = v;
                onChanged();
              }
            },
          ),
        ),
        const SizedBox(height: 10),

        // Actuator (shown for actuator types)
        if (action.type == ActionType.setActuatorState ||
            action.type == ActionType.setActuatorValue) ...[
          const Text(
            'ACTUATOR ID',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              color: C.muted,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: C.bgCard.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: C.gBdr),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String>(
              value: actuatorOptions.contains(action.actuatorId)
                  ? action.actuatorId
                  : actuatorOptions.first,
              isExpanded: true,
              underline: const SizedBox(),
              dropdownColor: C.bgCard2,
              icon: const Icon(
                Icons.expand_more_rounded,
                color: C.mutedLt,
                size: 16,
              ),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                color: C.green,
              ),
              items: actuatorOptions
                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  action.actuatorId = v;
                  onChanged();
                }
              },
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Value (for setActuatorValue)
        if (action.type == ActionType.setActuatorValue) ...[
          Row(
            children: [
              const Text(
                'TARGET VALUE (%)',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: C.muted,
                ),
              ),
              const Spacer(),
              Text(
                '${(action.targetValue ?? 50).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  color: C.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: C.green,
              inactiveTrackColor: C.muted,
              thumbColor: C.green,
              overlayColor: C.green.withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              trackHeight: 3,
            ),
            child: Slider(
              value: (action.targetValue ?? 50).clamp(0, 100),
              min: 0,
              max: 100,
              divisions: 20,
              onChanged: (v) {
                action.targetValue = v;
                onChanged();
              },
            ),
          ),
        ],

        // Notification message
        if (action.type == ActionType.sendNotification) ...[
          const Text(
            'NOTIFICATION MESSAGE',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              color: C.muted,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: C.bgCard.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: C.gBdr),
            ),
            child: TextField(
              controller: TextEditingController(
                text: action.notificationMessage ?? '',
              ),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                color: C.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Alert message...',
                hintStyle: TextStyle(color: C.muted, fontSize: 9),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
              ),
              onChanged: (v) {
                action.notificationMessage = v;
                onChanged();
              },
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Enabled toggle
        Row(
          children: [
            const Text(
              'ENABLED',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: C.muted,
              ),
            ),
            const Spacer(),
            TinyToggle(
              value: action.isEnabled,
              onToggle: () {
                action.isEnabled = !action.isEnabled;
                onChanged();
              },
            ),
          ],
        ),
      ],
    ),
  );
}
