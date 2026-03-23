import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/system_setting/setting_section.dart';
import 'package:urban_os/widgets/system_setting/storage_bar.dart';

typedef C = AppColors;

class StorageSection extends StatelessWidget {
  final String used;
  final String total;
  final double percent;
  final String cacheSize;
  final int cacheItemCount;
  final VoidCallback onClearCache;

  const StorageSection({
    super.key,
    required this.used,
    required this.total,
    required this.percent,
    required this.cacheSize,
    required this.cacheItemCount,
    required this.onClearCache,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'STORAGE',
      color: C.lime,
      children: [
        StorageBar(
          label: 'Device Storage',
          used: used,
          total: total,
          percent: percent,
          color: C.lime,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: C.bgCard.withOpacity(0.85),
            border: Border.all(color: C.cyan.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cache info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CACHE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: C.cyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    cacheSize,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8.5,
                      color: C.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Items info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ITEMS',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: C.cyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$cacheItemCount',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8.5,
                      color: C.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Clear cache button
              GestureDetector(
                onTap: onClearCache,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: C.red.withOpacity(0.15),
                    border: Border.all(color: C.red.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'CLEAR',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 6.5,
                      color: C.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
