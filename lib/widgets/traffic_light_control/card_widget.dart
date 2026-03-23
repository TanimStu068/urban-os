import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/traffic_dashboard/live_chip.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class CardWidget extends StatelessWidget {
  final String title, sub;
  final IconData icon;
  final Widget child;
  const CardWidget({
    super.key,
    required this.title,
    required this.sub,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext ctx) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13),
      color: C.bgCard.withOpacity(0.9),
      border: Border.all(color: C.gBdr),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 9, 12, 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: C.gBdr)),
            color: kAccent.withOpacity(0.022),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: kAccent,
                  boxShadow: [BoxShadow(color: kAccent, blurRadius: 5)],
                ),
              ),
              const SizedBox(width: 7),
              Icon(icon, color: kAccent, size: 12),
              const SizedBox(width: 6),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        letterSpacing: 1.5,
                        color: kAccent,
                      ),
                    ),
                    Text(
                      sub,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 6.5,
                        color: C.muted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              LiveChip(),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.all(12), child: child),
      ],
    ),
  );
}
