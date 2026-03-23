import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/automation_rule_builder_data_model.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/widgets/rule_builder/field_level.dart';
import 'package:urban_os/widgets/rule_builder/mono_text_field.dart';
import 'package:urban_os/widgets/rule_builder/step_header.dart';

typedef C = AppColors;

class IdentityStepPanel extends StatefulWidget {
  final AnimationController glowCtrl;
  final String? initialName;
  final String? initialDescription;
  final String? initialDistrict;
  final RuleCategory? initialCategory;
  final RulePriority? initialPriority;
  final String? initialConditionLogic;

  const IdentityStepPanel({
    super.key,
    required this.glowCtrl,
    this.initialName,
    this.initialDescription,
    this.initialDistrict,
    this.initialCategory,
    this.initialPriority,
    this.initialConditionLogic,
  });

  @override
  State<IdentityStepPanel> createState() => _IdentityStepPanelState();
}

class _IdentityStepPanelState extends State<IdentityStepPanel> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late String _name;
  late String _description;
  late RuleCategory _category;
  late RulePriority _priority;
  late String _conditionLogic;

  @override
  void initState() {
    super.initState();
    _name = widget.initialName ?? '';
    _description = widget.initialDescription ?? '';
    _category = widget.initialCategory ?? RuleCategory.public;
    _priority = widget.initialPriority ?? RulePriority.medium;
    _conditionLogic = widget.initialConditionLogic ?? 'AND';

    _nameCtrl = TextEditingController(text: _name);
    _descCtrl = TextEditingController(text: _description);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepHeader(
          step: BuilderStep.identity,
          subtitle: 'Name your rule, select category and set priority.',
        ),
        const SizedBox(height: 24),

        // Rule name
        const FieldLabel('RULE NAME *'),
        const SizedBox(height: 8),
        MonoTextField(
          controller: _nameCtrl,
          hint: 'e.g., "Traffic Peak Hours Control"',
          onChanged: (v) => setState(() => _name = v),
        ),
        const SizedBox(height: 16),

        // Description
        const FieldLabel('DESCRIPTION'),
        const SizedBox(height: 8),
        MonoTextField(
          controller: _descCtrl,
          hint: 'Explain what this rule does...',
          multiline: true,
          onChanged: (v) => setState(() => _description = v),
        ),
        const SizedBox(height: 16),

        // District
        const FieldLabel('DISTRICT / ZONE'),
        const SizedBox(height: 8),

        // Category
        const FieldLabel('CATEGORY'),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          children: RuleCategory.values.map((cat) {
            final isSel = _category == cat;
            return GestureDetector(
              onTap: () => setState(() => _category = cat),
              child: AnimatedBuilder(
                animation: widget.glowCtrl,
                builder: (_, __) => AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSel
                        ? cat.color.withOpacity(0.14)
                        : C.bgCard2.withOpacity(0.5),
                    border: Border.all(
                      color: isSel
                          ? cat.color.withOpacity(
                              0.5 + widget.glowCtrl.value * 0.1,
                            )
                          : C.gBdr,
                      width: isSel ? 1.3 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        cat.icon,
                        color: isSel ? cat.color : C.muted,
                        size: 13,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        cat.label,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8.5,
                          color: isSel ? cat.color : C.mutedLt,
                          fontWeight: isSel
                              ? FontWeight.w700
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Priority
        const FieldLabel('PRIORITY'),
        const SizedBox(height: 8),
        Column(
          children: RulePriority.values.map((p) {
            final isSel = _priority == p;
            return GestureDetector(
              onTap: () => setState(() => _priority = p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSel
                      ? p.color.withOpacity(0.1)
                      : C.bgCard2.withOpacity(0.4),
                  border: Border.all(
                    color: isSel ? p.color.withOpacity(0.5) : C.gBdr,
                    width: isSel ? 1.3 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(p.icon, color: isSel ? p.color : C.muted, size: 14),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.label,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              color: isSel ? p.color : C.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p.description,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7.5,
                              color: C.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isSel
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSel ? p.color : C.muted,
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Condition logic
        const FieldLabel('CONDITION LOGIC'),
        const SizedBox(height: 8),
        Row(
          children: ['AND', 'OR'].map((logic) {
            final isSel = _conditionLogic == logic;
            final col = logic == 'AND' ? C.amber : C.violet;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _conditionLogic = logic),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: EdgeInsets.only(right: logic == 'AND' ? 6 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSel
                        ? col.withOpacity(0.12)
                        : C.bgCard2.withOpacity(0.4),
                    border: Border.all(
                      color: isSel ? col.withOpacity(0.4) : C.gBdr,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        logic,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: isSel ? col : C.mutedLt,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        logic == 'AND'
                            ? 'ALL conditions must be true'
                            : 'ANY condition can be true',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7.5,
                          color: isSel ? col.withOpacity(0.8) : C.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
