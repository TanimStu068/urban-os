import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class Dot extends StatefulWidget {
  final Color color;
  final String label;
  final int delay;
  const Dot({
    super.key,
    required this.color,
    required this.label,
    required this.delay,
  });
  @override
  State<Dot> createState() => _DotState();
}

class _DotState extends State<Dot> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _c.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, __) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(.3 + _c.value * .7),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(.55 * _c.value),
                blurRadius: 5,
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            widget.label,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              letterSpacing: 1.5,
              color: AppColors.muted,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
