import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/automation_rule_builder_data_model.dart';
import 'package:urban_os/models/automation/rule_condition.dart';
import 'package:urban_os/widgets/rule_builder/tiny_toggle.dart';

typedef C = AppColors;

class ConditionEditor extends StatelessWidget {
  final DraftCondition condition;
  final int index;
  final List<String> sensorOptions;
  final double glowT;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  const ConditionEditor({
    super.key,
    required this.condition,
    required this.index,
    required this.sensorOptions,
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
      border: Border.all(color: C.amber.withOpacity(0.15 + glowT * 0.05)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: C.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'CONDITION ${index + 1}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: C.amber,
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

        // Sensor
        const Text(
          'SENSOR ID',
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
            value: sensorOptions.contains(condition.sensorId)
                ? condition.sensorId
                : sensorOptions.first,
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
              color: C.amber,
            ),
            items: sensorOptions
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                condition.sensorId = v;
                onChanged();
              }
            },
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            // Operator
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OPERATOR',
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
                    child: DropdownButton<ComparisonOperator>(
                      value: condition.operatorType,
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
                      items: ComparisonOperator.values
                          .map(
                            (op) => DropdownMenuItem(
                              value: op,
                              child: Text('${op.symbol}  ${op.displayName}'),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          condition.operatorType = v;
                          onChanged();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Threshold
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THRESHOLD',
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
                        text: condition.threshold == 0
                            ? ''
                            : condition.threshold.toString(),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: C.amber,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: const InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(color: C.muted, fontSize: 9),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      onChanged: (v) {
                        condition.threshold = double.tryParse(v) ?? 0;
                        onChanged();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Required toggle
        const SizedBox(height: 8),
        Row(
          children: [
            const Text(
              'REQUIRED',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: C.muted,
              ),
            ),
            const Spacer(),
            TinyToggle(
              value: condition.isRequired,
              onToggle: () {
                condition.isRequired = !condition.isRequired;
                onChanged();
              },
            ),
          ],
        ),
      ],
    ),
  );
}
