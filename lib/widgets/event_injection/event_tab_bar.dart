import 'package:flutter/material.dart';
import 'package:urban_os/widgets/event_injection/tap_button.dart';

/// EventTabBar widget
class EventTabBar extends StatelessWidget {
  final String selectedTab; // 'ACTIVE' or 'COMPLETED'
  final ValueChanged<String> onTabChanged;
  final VoidCallback onNewPressed;

  const EventTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.onNewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard2.withOpacity(0.6),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                TabButton(
                  label: 'ACTIVE',
                  isSelected: selectedTab == 'ACTIVE',
                  onTap: () => onTabChanged('ACTIVE'),
                ),
                const SizedBox(width: 6),
                TabButton(
                  label: 'COMPLETED',
                  isSelected: selectedTab == 'COMPLETED',
                  onTap: () => onTabChanged('COMPLETED'),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onNewPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: C.cyan.withOpacity(0.15),
                border: Border.all(color: C.cyan.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add_rounded, color: C.cyan, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'NEW',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 6.5,
                      color: C.cyan,
                      fontWeight: FontWeight.w700,
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
