import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/event_injection_data_model.dart';

class EventTypeButton extends StatelessWidget {
  final EventTemplate template;
  final bool isSelected;
  final VoidCallback onTap;

  const EventTypeButton({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: template.type.color.withOpacity(isSelected ? 0.15 : 0.05),
          border: Border.all(
            color: template.type.color.withOpacity(isSelected ? 0.5 : 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(template.type.icon, color: template.type.color, size: 24),
            const SizedBox(height: 6),
            Text(
              template.type.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7,
                color: template.type.color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
