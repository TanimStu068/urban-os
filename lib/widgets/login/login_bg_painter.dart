import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/login/node.dart';

class LoginBgPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Node> _nodes = [];
  final _rng = Random(99);
  bool _init = false;

  LoginBgPainter({required this.animation}) : super(repaint: animation);

  void _initNodes(Size size) {
    _nodes.clear();
    final count = (size.width * size.height / 22000).floor().clamp(15, 60);
    for (int i = 0; i < count; i++) {
      _nodes.add(
        Node(
          _rng.nextDouble() * size.width,
          _rng.nextDouble() * size.height,
          (_rng.nextDouble() - 0.5) * 0.4,
          (_rng.nextDouble() - 0.5) * 0.4,
          _rng.nextDouble() * 1.5 + 0.5,
          _rng.nextDouble() * pi * 2,
        ),
      );
    }
    _init = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!_init) _initNodes(size);

    // bg
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.3),
        colors: [const Color(0xFF060F1A), AppColors.bgDeep],
        radius: 1.2,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Offset.zero & size, bgPaint);

    for (final n in _nodes) {
      n.x += n.vx;
      n.y += n.vy;
      n.pulse += 0.015;
      if (n.x < 0 || n.x > size.width) n.vx *= -1;
      if (n.y < 0 || n.y > size.height) n.vy *= -1;

      for (final m in _nodes) {
        final dx = n.x - m.x, dy = n.y - m.y;
        final d = sqrt(dx * dx + dy * dy);
        if (d < 160 && d > 0) {
          canvas.drawLine(
            Offset(n.x, n.y),
            Offset(m.x, m.y),
            Paint()
              ..color = AppColors.cyan.withOpacity((1 - d / 160) * 0.08)
              ..strokeWidth = 0.5,
          );
        }
      }

      final p = (sin(n.pulse) + 1) / 2;
      canvas.drawCircle(
        Offset(n.x, n.y),
        n.r + p * 0.5,
        Paint()..color = AppColors.cyan.withOpacity(0.2 + p * 0.25),
      );
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
