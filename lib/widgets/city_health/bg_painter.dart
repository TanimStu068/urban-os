import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/city_health/node.dart';

typedef C = AppColors;

class BgPainter extends CustomPainter {
  final Animation<double> anim;
  final _nodes = <Node>[];
  final _rng = Random(9);
  bool _init = false;
  BgPainter({required this.anim}) : super(repaint: anim);

  void _build(Size s) {
    _nodes.clear();
    final n = (s.width * s.height / 20000).floor().clamp(10, 40);
    for (var i = 0; i < n; i++) {
      _nodes.add(
        Node(
          _rng.nextDouble() * s.width,
          _rng.nextDouble() * s.height,
          (_rng.nextDouble() - .5) * .25,
          (_rng.nextDouble() - .5) * .25,
          _rng.nextDouble() * 1.2 + .3,
          _rng.nextDouble() * pi * 2,
        ),
      );
    }
    _init = true;
  }

  @override
  void paint(Canvas c, Size s) {
    if (!_init) _build(s);
    c.drawRect(
      Offset.zero & s,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(.1, -.4),
          colors: [const Color(0xFF030C14), C.bg],
          radius: 1.3,
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );
    for (final n in _nodes) {
      n.x += n.vx;
      n.y += n.vy;
      n.phase += .008;
      if (n.x < 0 || n.x > s.width) n.vx *= -1;
      if (n.y < 0 || n.y > s.height) n.vy *= -1;
      for (final m in _nodes) {
        final dx = n.x - m.x, dy = n.y - m.y, d = sqrt(dx * dx + dy * dy);
        if (d < 100 && d > 0) {
          c.drawLine(
            Offset(n.x, n.y),
            Offset(m.x, m.y),
            Paint()
              ..color = C.teal.withOpacity((1 - d / 100) * .05)
              ..strokeWidth = .4,
          );
        }
      }
      final p = (sin(n.phase) + 1) / 2;
      c.drawCircle(
        Offset(n.x, n.y),
        n.r + p * .3,
        Paint()..color = C.teal.withOpacity(.12 + p * .14),
      );
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
