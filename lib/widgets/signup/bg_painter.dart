import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/signup/node.dart';

class BgPainter extends CustomPainter {
  final Animation<double> animation;
  final _nodes = <Node>[];
  final _rng = Random(77);
  bool _init = false;
  BgPainter({required this.animation}) : super(repaint: animation);

  void _initNodes(Size s) {
    _nodes.clear();
    for (
      int i = 0;
      i < (s.width * s.height / 20000).floor().clamp(15, 55);
      i++
    ) {
      _nodes.add(
        Node(
          _rng.nextDouble() * s.width,
          _rng.nextDouble() * s.height,
          (_rng.nextDouble() - .5) * .4,
          (_rng.nextDouble() - .5) * .4,
          _rng.nextDouble() * 1.5 + .5,
          _rng.nextDouble() * pi * 2,
        ),
      );
    }
    _init = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!_init) _initNodes(size);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0.2, -0.4),
          colors: [const Color(0xFF060F1A), AppColors.bgDeep],
          radius: 1.3,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    for (final n in _nodes) {
      n.x += n.vx;
      n.y += n.vy;
      n.pulse += .015;
      if (n.x < 0 || n.x > size.width) n.vx *= -1;
      if (n.y < 0 || n.y > size.height) n.vy *= -1;
      for (final m in _nodes) {
        final dx = n.x - m.x, dy = n.y - m.y, d = sqrt(dx * dx + dy * dy);
        if (d < 150 && d > 0) {
          canvas.drawLine(
            Offset(n.x, n.y),
            Offset(m.x, m.y),
            Paint()
              ..color = AppColors.cyan.withOpacity((1 - d / 150) * .08)
              ..strokeWidth = .5,
          );
        }
      }
      final p = (sin(n.pulse) + 1) / 2;
      canvas.drawCircle(
        Offset(n.x, n.y),
        n.r + p * .5,
        Paint()..color = AppColors.cyan.withOpacity(.2 + p * .22),
      );
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
