import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class CardWrap extends StatelessWidget {
  final Widget child;
  final Color? accentColor;

  const CardWrap({super.key, required this.child, this.accentColor});

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.amber;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF071520).withOpacity(.88),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(.22)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(.08),
                blurRadius: 40,
                spreadRadius: -5,
              ),
              BoxShadow(color: Colors.black.withOpacity(.5), blurRadius: 30),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
