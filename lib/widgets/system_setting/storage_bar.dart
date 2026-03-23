import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class StorageBar extends StatelessWidget {
  final String label;
  final String used;
  final String total;
  final double percent;
  final Color color;

  const StorageBar({
    super.key,
    required this.label,
    required this.used,
    required this.total,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: color.withOpacity(0.1))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$used / $total',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: C.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 5,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(percent * 100).toStringAsFixed(1)}% USED',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 6,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
