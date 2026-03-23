import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_dashboard_data_model.dart';
import 'package:urban_os/models/logs/alert_log.dart';

typedef C = AppColors;

class AlertRow extends StatelessWidget {
  final AlertLog alert;
  final int index;
  const AlertRow({super.key, required this.alert, required this.index});

  @override
  Widget build(BuildContext context) {
    final col = alert.displayColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      color: index == 0 ? col.withOpacity(.04) : Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: col.withOpacity(.1),
              border: Border.all(color: col.withOpacity(.3)),
            ),
            child: Icon(alert.displayIcon, color: col, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: C.white,
                    letterSpacing: .3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  alert.description,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    color: C.muted,
                    letterSpacing: .3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                alert.timeLabel,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: col,
                  letterSpacing: .5,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: col.withOpacity(.1),
                  border: Border.all(color: col.withOpacity(.3)),
                ),
                child: Text(
                  alert.severityLabel,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    letterSpacing: 1,
                    color: col,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
