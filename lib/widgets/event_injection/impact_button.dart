import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/event_injection_data_model.dart';

class ImpactButton extends StatelessWidget {
  final ImpactArea impact;
  final bool isSelected;
  final VoidCallback onTap;

  const ImpactButton({
    super.key,
    required this.impact,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: C.cyan.withOpacity(isSelected ? 0.2 : 0.08),
            border: Border.all(
              color: C.cyan.withOpacity(isSelected ? 0.5 : 0.2),
            ),
          ),
          child: Text(
            impact.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 6,
              color: C.cyan,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
