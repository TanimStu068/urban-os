import 'package:flutter/material.dart';
import 'package:urban_os/widgets/login/corner_painter.dart';

class CornerBracket extends StatefulWidget {
  final bool flipX, flipY;
  const CornerBracket({super.key, required this.flipX, required this.flipY});
  @override
  State<CornerBracket> createState() => _CornerBracketState();
}

class _CornerBracketState extends State<CornerBracket>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _prog;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _prog = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _prog,
    builder: (_, __) => Transform.scale(
      scaleX: widget.flipX ? -1 : 1,
      scaleY: widget.flipY ? -1 : 1,
      child: CustomPaint(
        painter: CornerPainter(_prog.value),
        size: const Size(60, 60),
      ),
    ),
  );
}
