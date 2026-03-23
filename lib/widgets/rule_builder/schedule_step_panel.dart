import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/automation_rule_builder_data_model.dart';
import 'package:urban_os/widgets/rule_builder/panel.dart';
import 'package:urban_os/widgets/rule_builder/step_header.dart';
import 'package:urban_os/widgets/rule_builder/time_btn.dart';
import 'package:urban_os/widgets/rule_builder/tiny_toggle.dart';

typedef C = AppColors;

class ScheduleStepPanel extends StatefulWidget {
  final bool initialScheduleEnabled;
  final TimeOfDay initialStart;
  final TimeOfDay initialEnd;
  final List<int> initialDays;
  final int initialCooldown;
  final bool initialOneShot;

  const ScheduleStepPanel({
    super.key,
    this.initialScheduleEnabled = false,
    this.initialStart = const TimeOfDay(hour: 0, minute: 0),
    this.initialEnd = const TimeOfDay(hour: 23, minute: 59),
    this.initialDays = const [],
    this.initialCooldown = 60,
    this.initialOneShot = false,
  });

  @override
  State<ScheduleStepPanel> createState() => _ScheduleStepPanelState();
}

class _ScheduleStepPanelState extends State<ScheduleStepPanel> {
  late bool _scheduleEnabled;
  late TimeOfDay _scheduleStart;
  late TimeOfDay _scheduleEnd;
  late List<int> _scheduleDays;
  late int _cooldownSeconds;
  late bool _oneShot;

  @override
  void initState() {
    super.initState();
    _scheduleEnabled = widget.initialScheduleEnabled;
    _scheduleStart = widget.initialStart;
    _scheduleEnd = widget.initialEnd;
    _scheduleDays = List<int>.from(widget.initialDays);
    _cooldownSeconds = widget.initialCooldown;
    _oneShot = widget.initialOneShot;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepHeader(
          step: BuilderStep.schedule,
          subtitle: 'Optionally restrict when and how often this rule fires.',
        ),
        const SizedBox(height: 20),

        // Schedule window panel
        Panel(
          title: 'SCHEDULE WINDOW',
          icon: Icons.schedule_rounded,
          color: C.sky,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'ENABLE TIME WINDOW',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            color: C.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Restrict active hours for this rule',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            color: C.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TinyToggle(
                    value: _scheduleEnabled,
                    onToggle: () =>
                        setState(() => _scheduleEnabled = !_scheduleEnabled),
                  ),
                ],
              ),
              if (_scheduleEnabled) ...[
                const SizedBox(height: 14),
                const Divider(color: Color(0x1A00D4FF)),
                const SizedBox(height: 14),
                const Text(
                  'ACTIVE HOURS',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    color: C.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TimeBtn(
                        label: 'FROM',
                        time: _scheduleStart,
                        onTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: _scheduleStart,
                          );
                          if (t != null) setState(() => _scheduleStart = t);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '→',
                      style: TextStyle(color: C.mutedLt, fontSize: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TimeBtn(
                        label: 'TO',
                        time: _scheduleEnd,
                        onTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: _scheduleEnd,
                          );
                          if (t != null) setState(() => _scheduleEnd = t);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'ACTIVE DAYS',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    color: C.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(7, (i) {
                    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    final selected = _scheduleDays.contains(i);
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          if (selected) {
                            _scheduleDays.remove(i);
                          } else {
                            _scheduleDays.add(i);
                          }
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.only(right: 4),
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? C.violet.withOpacity(0.2)
                                : C.bgCard2,
                            border: Border.all(
                              color: selected
                                  ? C.violet.withOpacity(0.5)
                                  : C.gBdr,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              days[i],
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9,
                                color: selected ? C.violet : C.muted,
                                fontWeight: selected
                                    ? FontWeight.w800
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Rate limiting panel
        Panel(
          title: 'RATE LIMITING',
          icon: Icons.speed_rounded,
          color: C.amber,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'COOLDOWN PERIOD',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      color: C.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_cooldownSeconds}s',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      color: C.amber,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Minimum time between rule executions',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: C.muted,
                ),
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: C.amber,
                  inactiveTrackColor: C.muted,
                  thumbColor: C.amber,
                  overlayColor: C.amber.withOpacity(0.1),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 5,
                  ),
                  trackHeight: 3,
                ),
                child: Slider(
                  value: _cooldownSeconds.toDouble(),
                  min: 1,
                  max: 300,
                  divisions: 59,
                  onChanged: (v) =>
                      setState(() => _cooldownSeconds = v.toInt()),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'ONE-SHOT',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            color: C.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Fires once then auto-disables',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            color: C.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TinyToggle(
                    value: _oneShot,
                    onToggle: () => setState(() => _oneShot = !_oneShot),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
