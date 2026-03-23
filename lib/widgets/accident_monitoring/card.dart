import 'package:flutter/material.dart';
import 'package:urban_os/widgets/accident_monitoring/live_chip.dart';

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
            color: C.red.withOpacity(0.015),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
          ),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: C.red,
                  boxShadow: [BoxShadow(color: C.red, blurRadius: 5)],
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: C.red, size: 13),
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
                        color: C.red,
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
              LiveChip(),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.all(14), child: child),
      ],
    ),
  );
}
