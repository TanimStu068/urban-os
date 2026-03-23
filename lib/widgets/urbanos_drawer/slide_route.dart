import 'package:flutter/material.dart';

class SlideRoute extends PageRouteBuilder {
  final Widget Function() builder;

  SlideRoute({required this.builder})
    : super(
        pageBuilder: (_, __, ___) => builder(),
        transitionDuration: const Duration(milliseconds: 380),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, anim, secondAnim, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));

          final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: anim,
              curve: const Interval(0, 0.6, curve: Curves.easeOut),
            ),
          );

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
      );
}
