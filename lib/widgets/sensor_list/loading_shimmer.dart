import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef T = AppColors;

class LoadingShimmer extends StatelessWidget {
  final AnimationController shimmer;
  const LoadingShimmer({super.key, required this.shimmer});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 60),
      itemCount: 6,
      itemBuilder: (_, i) => AnimatedBuilder(
        animation: shimmer,
        builder: (_, __) {
          final t = (shimmer.value - i * 0.08).clamp(0.0, 1.0);
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment(-1 + shimmer.value * 3, 0),
                end: Alignment(0 + shimmer.value * 3, 0),
                colors: [
                  T.surface,
                  T.surfaceHi.withOpacity(0.4 + t * 0.3),
                  T.surface,
                ],
              ),
              border: Border.all(color: T.border),
            ),
          );
        },
      ),
    );
  }
}
