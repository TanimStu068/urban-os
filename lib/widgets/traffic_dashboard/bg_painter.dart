import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/traffic_dashboard/node.dart';
import 'dart:math';

typedef C = AppColors;
// Traffic theme accent
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

class BgPainter extends CustomPainter {
  final Animation<double> anim;
  final _nodes = <Node>[];
  final _rng = Random(42);
  bool _init = false;
  BgPainter({required this.anim}) : super(repaint: anim);

  void _initNodes(Size s) {
    _nodes.clear();
    for (
      int i = 0;
      i < (s.width * s.height / 20000).floor().clamp(12, 45);
      i++
    ) {
      _nodes.add(
        Node(
          _rng.nextDouble() * s.width,
          _rng.nextDouble() * s.height,
          (_rng.nextDouble() - .5) * .22,
          (_rng.nextDouble() - .5) * .22,
          _rng.nextDouble() * 1.2 + .4,
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
          center: const Alignment(.1, -.3),
          colors: [const Color(0xFF020C18), C.bg],
          radius: 1.3,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    for (final n in _nodes) {
      n.x += n.vx;
      n.y += n.vy;
      n.pulse += .009;
      if (n.x < 0 || n.x > size.width) n.vx *= -1;
      if (n.y < 0 || n.y > size.height) n.vy *= -1;
      for (final m in _nodes) {
        final dx = n.x - m.x, dy = n.y - m.y, d = sqrt(dx * dx + dy * dy);
        if (d < 120 && d > 0)
          canvas.drawLine(
            Offset(n.x, n.y),
            Offset(m.x, m.y),
            Paint()
              ..color = kAccent.withOpacity((1 - d / 120) * .04)
              ..strokeWidth = .5,
          );
      }
      final p = (sin(n.pulse) + 1) / 2;
      canvas.drawCircle(
        Offset(n.x, n.y),
        n.r + p * .4,
        Paint()..color = kAccent.withOpacity(.07 + p * .09),
      );
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
