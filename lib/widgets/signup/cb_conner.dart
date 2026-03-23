import 'package:flutter/material.dart';
import 'package:urban_os/widgets/signup/cpainter.dart';

class CornerBracket extends StatefulWidget {
  final bool fx, fy;
  const CornerBracket({super.key, required this.fx, required this.fy});
  @override
  State<CornerBracket> createState() => _CBState();
}

class _CBState extends State<CornerBracket>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _p;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _p = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _p,
    builder: (_, __) => Transform.scale(
      scaleX: widget.fx ? -1 : 1,
      scaleY: widget.fy ? -1 : 1,
      child: CustomPaint(painter: CPainter(_p.value), size: const Size(60, 60)),
    ),
  );
}
