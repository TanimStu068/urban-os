import 'package:flutter/material.dart';

class InjBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const InjBtn(this.label, this.color, this.onTap, {super.key});
  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: color.withOpacity(0.07),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 8.5,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );
}
