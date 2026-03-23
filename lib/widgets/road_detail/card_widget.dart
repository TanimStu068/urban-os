import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/road_detail/live_chip.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class CardWidget extends StatelessWidget {
  final String title, sub;
  final IconData icon;
  final Widget child;
  final Widget? trailing;
  const CardWidget({
    super.key,
    required this.title,
    required this.sub,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext ctx) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: C.bgCard.withOpacity(0.9),
      border: Border.all(color: C.gBdr),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 11, 14, 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: C.gBdr)),
            color: kAccent.withOpacity(0.022),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
          ),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: kAccent,
                  boxShadow: [BoxShadow(color: kAccent, blurRadius: 5)],
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: kAccent, size: 13),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        letterSpacing: 2,
                        color: kAccent,
                      ),
                    ),
                    Text(
                      sub,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7,
                        color: C.muted,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing! else LiveChip(),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.all(14), child: child),
      ],
    ),
  );
}
