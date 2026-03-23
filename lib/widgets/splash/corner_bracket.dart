import 'package:flutter/material.dart';
import 'package:urban_os/widgets/splash/corner_painter.dart';

class CornerBracket extends StatefulWidget {
  final bool flip, flipY;
  final int delay;
  const CornerBracket({
    super.key,
    required this.flip,
    required this.flipY,
    required this.delay,
  });
  @override
  State<CornerBracket> createState() => _CornerBracketState();
}

class _CornerBracketState extends State<CornerBracket>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (_, __) => Transform.scale(
        scaleX: widget.flip ? -1 : 1,
        scaleY: widget.flipY ? -1 : 1,
        child: CustomPaint(
          painter: CornerPainter(_progress.value),
          size: const Size(80, 80),
        ),
      ),
    );
  }
}
