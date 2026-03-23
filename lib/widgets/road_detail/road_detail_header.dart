import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/status_pill.dart';

typedef C = AppColors;

/// Road detail screen header
class RoadDetailHeader extends StatelessWidget {
  final RoadDetailData road;
  final Animation<double> blinkT;
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final VoidCallback? onMore;

  const RoadDetailHeader({
    super.key,
    required this.road,
    required this.blinkT,
    this.onBack,
    this.onShare,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: C.bgCard.withOpacity(0.92),
        border: Border(bottom: BorderSide(color: C.gBdr)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.maybePop(context),
            child: _CircleBtn(Icons.arrow_back_ios_rounded, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [C.cyan, C.teal],
                  ).createShader(bounds),
                  child: Text(
                    road.name.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  '${road.id}  ·  ${road.district}  ·  ${road.type}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    letterSpacing: 1.8,
                    color: C.mutedLt,
                  ),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: blinkT,
            builder: (_, __) =>
                StatusPill(road.status, road.color, blinkT.value),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onShare,
            child: _CircleBtn(Icons.share_rounded, size: 16),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onMore,
            child: _CircleBtn(Icons.more_vert_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}

/// Small circular button used in header
class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  const _CircleBtn(this.icon, {this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 12,
      height: size + 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: C.bgCard.withOpacity(0.15),
      ),
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}
