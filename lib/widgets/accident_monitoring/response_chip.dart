import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';

class ResponseChip extends StatelessWidget {
  final ResponseStatus status;
  const ResponseChip(this.status, {super.key});
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: status.color.withOpacity(0.08),
      border: Border.all(color: status.color.withOpacity(0.3)),
    ),
    child: Text(
      status.label,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 7.5,
        color: status.color,
        letterSpacing: 0.5,
      ),
    ),
  );
}
