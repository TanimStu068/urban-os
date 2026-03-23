import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ConsequencesList extends StatelessWidget {
  final List<ConsequenceItem> items;

  const ConsequencesList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard.withOpacity(0.85),
        border: Border.all(color: C.red.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WHAT WILL BE DELETED',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: C.red,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: item.color.withOpacity(0.12),
                    ),
                    child: Center(
                      child: Icon(item.icon, color: item.color, size: 12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.text,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7,
                        color: C.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Model class for an individual consequence item
class ConsequenceItem {
  final IconData icon;
  final Color color;
  final String text;

  const ConsequenceItem(this.icon, this.color, this.text);
}
