import 'package:flutter/material.dart';

class LiveValue extends StatefulWidget {
  final double value;
  final String unit;
  final Color color;
  final double fontSize;

  const LiveValue({
    super.key,
    required this.value,
    required this.unit,
    required this.color,
    this.fontSize = 20,
  });

  @override
  State<LiveValue> createState() => _LiveValueState();
}

class _LiveValueState extends State<LiveValue>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late double _prev;
  late Animation<double> _tween;

  @override
  void initState() {
    super.initState();
    _prev = widget.value;
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _tween = Tween<double>(
      begin: _prev,
      end: _prev,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(LiveValue old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _prev = old.value;
      _tween = Tween<double>(
        begin: _prev,
        end: widget.value,
      ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
      _anim.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _tween,
      builder: (_, __) {
        final v = _tween.value;
        final display = v >= 1000
            ? '${(v / 1000).toStringAsFixed(1)}k'
            : v < 10
            ? v.toStringAsFixed(2)
            : v.toStringAsFixed(1);
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              display,
              style: TextStyle(
                color: widget.color,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 3),
            Text(
              widget.unit,
              style: TextStyle(
                color: widget.color.withOpacity(0.65),
                fontSize: widget.fontSize * 0.46,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}
