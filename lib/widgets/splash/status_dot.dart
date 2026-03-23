import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class StatusDot extends StatefulWidget {
  final String label;
  final Color color;
  final int delay;
  const StatusDot({
    super.key,
    required this.label,
    required this.color,
    required this.delay,
  });
  @override
  State<StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<StatusDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withOpacity(0.3 + _ctrl.value * 0.7),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.6 * _ctrl.value),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          widget.label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            letterSpacing: 1.5,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}
