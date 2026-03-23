import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/splash/node.dart';

class NetworkPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Node> _nodes = [];
  final Random _rng = Random(42);
  bool _initialized = false;

  NetworkPainter({required this.animation}) : super(repaint: animation);

  void _init(Size size) {
    _nodes.clear();
    final count = (size.width * size.height / 18000).floor().clamp(20, 80);
    for (int i = 0; i < count; i++) {
      _nodes.add(
        Node(
          _rng.nextDouble() * size.width,
          _rng.nextDouble() * size.height,
          (_rng.nextDouble() - 0.5) * 0.5,
          (_rng.nextDouble() - 0.5) * 0.5,
          _rng.nextDouble() * 2 + 0.5,
          _rng.nextDouble() * pi * 2,
        ),
      );
    }
    _initialized = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!_initialized) _init(size);

    // Background gradient
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFF050C14), AppColors.bgDeep],
        radius: 0.8,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Offset.zero & size, bgPaint);

    final t = animation.value;

    for (final n in _nodes) {
      n.x += n.vx;
      n.y += n.vy;
      n.pulse += 0.02;
      if (n.x < 0 || n.x > size.width) n.vx *= -1;
      if (n.y < 0 || n.y > size.height) n.vy *= -1;

      for (final m in _nodes) {
        final dx = n.x - m.x, dy = n.y - m.y;
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < 140 && dist > 0) {
          final alpha = (1 - dist / 140) * 0.12;
          canvas.drawLine(
            Offset(n.x, n.y),
            Offset(m.x, m.y),
            Paint()
              ..color = AppColors.cyan.withOpacity(alpha)
              ..strokeWidth = 0.5,
          );
        }
      }

      final pulse = (sin(n.pulse) + 1) / 2;
      canvas.drawCircle(
        Offset(n.x, n.y),
        n.r + pulse * 0.5,
        Paint()..color = AppColors.cyan.withOpacity(0.3 + pulse * 0.3),
      );
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
