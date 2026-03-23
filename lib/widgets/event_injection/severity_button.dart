import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/event_injection_data_model.dart';

class SeverityButton extends StatelessWidget {
  final EventSeverity severity;
  final bool isSelected;
  final VoidCallback onTap;

  const SeverityButton({
    super.key,
    required this.severity,
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: severity.color.withOpacity(isSelected ? 0.2 : 0.08),
            border: Border.all(
              color: severity.color.withOpacity(isSelected ? 0.5 : 0.2),
            ),
          ),
          child: Text(
            severity.label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 6.5,
              color: severity.color,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
