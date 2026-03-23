import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/automation_rule_builder_data_model.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/widgets/rule_builder/action_step_panel.dart';
import 'package:urban_os/widgets/rule_builder/condition_step_panel.dart';
import 'package:urban_os/widgets/rule_builder/identity_step_panel.dart';
import 'package:urban_os/widgets/rule_builder/review_step_panel.dart';
import 'package:urban_os/widgets/rule_builder/rule_builder_bottom_nav.dart';
import 'package:urban_os/widgets/rule_builder/rule_builder_error.dart';
import 'package:urban_os/widgets/rule_builder/rule_builder_header.dart';
import 'package:urban_os/widgets/rule_builder/rule_builder_step_bar.dart';
import 'package:urban_os/widgets/rule_builder/schedule_step_panel.dart';

typedef C = AppColors;

//  RULE BUILDER SCREEN
class RuleBuilderScreen extends StatefulWidget {
  final AutomationRule? existingRule;
  const RuleBuilderScreen({super.key, this.existingRule});

  @override
  State<RuleBuilderScreen> createState() => _RuleBuilderScreenState();
}

class _RuleBuilderScreenState extends State<RuleBuilderScreen>
    with TickerProviderStateMixin {
  late BuilderStep _step;

  // Identity
  String _name = '';
  String _description = '';
  RuleCategory _category = RuleCategory.traffic;
  RulePriority _priority = RulePriority.medium;
  String _district = 'All Districts';

  // Conditions
  List<DraftCondition> _conditions = [];
  String _conditionLogic = 'AND';

  // Actions
  List<DraftAction> _actions = [];

  // Schedule
  bool _scheduleEnabled = false;
  TimeOfDay _scheduleStart = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _scheduleEnd = const TimeOfDay(hour: 22, minute: 0);
  //  Set<int> _scheduleDays = {};
  List<int> _scheduleDays = [];
  int _cooldownSeconds = 5;
  bool _oneShot = false;

  // Animation
  late AnimationController _fadeCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _slideCtrl;
  late ScrollController _scrollCtrl;

  bool _stepHasErrors = false;
  String? _errorMessage;

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _step = BuilderStep.identity;

    if (widget.existingRule != null) {
      final r = widget.existingRule!;
      _name = r.name;
      _description = r.description ?? '';
      _category = r.category ?? RuleCategory.traffic;
      _priority = r.priority;
      _district = r.district;
      _conditionLogic = r.conditionLogic;
      _conditions = r.conditions
          .map(
            (c) => DraftCondition(
              id: UniqueKey().toString(),
              sensorId: c.sensorId,
              operatorType: c.operatorType,
              threshold: c.threshold,
              maxThreshold: c.maxThreshold,
              description: c.description ?? '',
              isRequired: c.isRequired,
            ),
          )
          .toList();
      _actions = r.actions
          .map(
            (a) => DraftAction(
              id: a.id,
              type: a.type,
              actuatorId: a.actuatorId,
              targetValue: a.targetValue,
              notificationMessage: a.notificationMessage,
              notificationSeverity: a.notificationSeverity,
              eventDescription: a.eventDescription,
              isEnabled: a.isEnabled,
            ),
          )
          .toList();
      if (r.cooldownPeriod != null) {
        _cooldownSeconds = r.cooldownPeriod!.inSeconds;
      }
    } else {
      _conditions = [DraftCondition(id: _uid())];
      _actions = [DraftAction(id: _uid())];
    }

    _nameCtrl.text = _name;
    _descCtrl.text = _description;
    _districtCtrl.text = _district;

    _scrollCtrl = ScrollController();
    _fadeCtrl = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    )..forward();
    _slideCtrl = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    )..forward();
    _glowCtrl = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  String _uid() =>
      DateTime.now().microsecondsSinceEpoch.toString() +
      Random().nextInt(9999).toString();

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    _glowCtrl.dispose();
    _scrollCtrl.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _districtCtrl.dispose();
    super.dispose();
  }

  bool _isStepComplete(BuilderStep step) {
    switch (step) {
      case BuilderStep.identity:
        return _name.trim().isNotEmpty;
      case BuilderStep.conditions:
        return _conditions.isNotEmpty &&
            _conditions.every((c) => c.sensorId.isNotEmpty);
      case BuilderStep.actions:
        return _actions.isNotEmpty &&
            _actions.every(
              (a) => a.actuatorId != null && a.actuatorId!.isNotEmpty,
            );
      case BuilderStep.schedule:
        return true;
      case BuilderStep.review:
        return _isStepComplete(BuilderStep.identity) &&
            _isStepComplete(BuilderStep.conditions) &&
            _isStepComplete(BuilderStep.actions);
    }
  }

  void _goToStep(BuilderStep step) {
    if (!_isStepComplete(_step)) {
      setState(() {
        _stepHasErrors = true;
        _errorMessage = _getStepError(_step);
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _stepHasErrors = false;
            _errorMessage = null;
          });
        }
      });
      return;
    }
    _fadeCtrl.reset();
    setState(() {
      _step = step;
      _scrollCtrl.jumpTo(0);
    });
    _fadeCtrl.forward();
  }

  String _getStepError(BuilderStep step) {
    switch (step) {
      case BuilderStep.identity:
        return 'Rule name is required.';
      case BuilderStep.conditions:
        return 'All conditions must have a sensor selected.';
      case BuilderStep.actions:
        return 'All actions must have an actuator selected.';
      default:
        return 'Please complete this step.';
    }
  }

  void _saveRule() {
    if (!_isStepComplete(BuilderStep.review)) return;
    final isNew = widget.existingRule == null;
    final ruleId = isNew
        ? 'AR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'
        : widget.existingRule!.id;

    final rule = AutomationRule(
      id: ruleId,
      name: _name.trim(),
      description: _description.trim().isNotEmpty ? _description.trim() : null,
      category: _category,
      priority: _priority,
      isEnabled: true,
      conditionLogic: _conditionLogic,
      conditions: _conditions.map((c) => c.toModel()).toList(),
      actions: _actions.map((a) => a.toModel()).toList(),
      district: _district,
      isSystem: widget.existingRule?.isSystem ?? false,
      createdBy: widget.existingRule?.createdBy ?? 'Admin',
      triggerCount: widget.existingRule?.triggerCount ?? 0,
      triggerHistory:
          widget.existingRule?.triggerHistory ?? [0, 0, 0, 0, 0, 0, 0],
      createdDate: widget.existingRule?.createdDate ?? DateTime.now(),
      modifiedDate: DateTime.now(),
      cooldownPeriod: _cooldownSeconds > 0
          ? Duration(seconds: _cooldownSeconds)
          : null,
    );

    Navigator.pop(context, rule);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [C.bgCard3, C.bg, C.bgCard2.withOpacity(0.5)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                RuleBuilderHeader(
                  existingRule: widget.existingRule,
                  name: _name,
                  category: _category,
                  onBack: () => Navigator.pop(context),
                ),
                // _buildHeader(),
                RuleBuilderStepBar(
                  currentStep: _step,
                  glowCtrl: _glowCtrl,
                  isStepComplete: _isStepComplete,
                  onStepTap: (step) => _goToStep(step),
                ),
                // RuleBuilderStepBar(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollCtrl,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 20),
                    child: FadeTransition(
                      opacity: Tween<double>(
                        begin: 0,
                        end: 1,
                      ).animate(_fadeCtrl),
                      child: _stepHasErrors
                          ? RuleBuilderError()
                          : _buildStepContent(),
                    ),
                  ),
                ),
                RuleBuilderBottomNav(
                  currentStep: _step,
                  glowCtrl: _glowCtrl,
                  isReviewStep: _step == BuilderStep.review,
                  isExistingRule: widget.existingRule != null,
                  onBack: () {
                    final idx = BuilderStep.values.indexOf(_step);
                    _goToStep(BuilderStep.values[idx - 1]);
                  },
                  onNext: () {
                    final idx = BuilderStep.values.indexOf(_step);
                    _goToStep(BuilderStep.values[idx + 1]);
                  },
                  onSave: _saveRule,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case BuilderStep.identity:
        return IdentityStepPanel(
          glowCtrl: _glowCtrl,
          initialName: _name,
          initialDescription: _description,
          initialCategory: _category,
          initialPriority: _priority,
        );
      case BuilderStep.conditions:
        return ConditionsStepPanel(
          glowCtrl: _glowCtrl,
          initialLogic: _conditionLogic,
          initialConditions: _conditions,
          key: ValueKey('conditions-step'),
        );
      case BuilderStep.actions:
        return ActionsStepPanel(glowCtrl: _glowCtrl, initialActions: _actions);
      case BuilderStep.schedule:
        return ScheduleStepPanel(
          initialScheduleEnabled: _scheduleEnabled,
          initialStart: _scheduleStart,
          initialEnd: _scheduleEnd,
          initialDays: _scheduleDays,
          initialCooldown: _cooldownSeconds,
          initialOneShot: _oneShot,
          key: ValueKey('schedule-step'),
        );
      case BuilderStep.review:
        return ReviewStepPanel(
          glowCtrl: _glowCtrl,
          name: _name,
          district: _district,
          description: _description,
          category: _category,
          priority: _priority,
          cooldownSeconds: _cooldownSeconds.toDouble(),
          scheduleEnabled: _scheduleEnabled,
          oneShot: _oneShot,
          conditionLogic: _conditionLogic,
          conditions: _conditions.map((c) => c.toModel()).toList(),
          actions: _actions.map((a) => a.toModel()).toList(),
        );
    }
  }
}
