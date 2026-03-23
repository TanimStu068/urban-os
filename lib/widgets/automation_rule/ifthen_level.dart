import 'package:flutter/material.dart';

class IfThenLabel extends StatelessWidget {
  final String label;
  final Color col;
  final IconData icon;
  const IfThenLabel(this.label, this.col, this.icon, {super.key});
  @override
  Widget build(BuildContext ctx) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: col.withOpacity(0.1),
          border: Border.all(color: col.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: col, size: 10),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8.5,
                fontWeight: FontWeight.w900,
                color: col,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
